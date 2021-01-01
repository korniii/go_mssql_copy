package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"strconv"
	"sync"
	"time"

	mssql "github.com/denisenkom/go-mssqldb"
	"github.com/jmoiron/sqlx"
	"github.com/joho/godotenv"
	"github.com/vbauerster/mpb/v5"
	"github.com/vbauerster/mpb/v5/decor"
)

// ColumnMetaData holds structred meta information of table columns / source -> INFORMATION_SCHEMA.COLUMNS
type ColumnMetaData struct {
	ColumnName       string        `db:"COLUMN_NAME"`
	DataType         string        `db:"DATA_TYPE"`
	NumericPrecision sql.NullInt32 `db:"NUMERIC_PRECISION"`
	NumericScale     sql.NullInt32 `db:"NUMERIC_SCALE"`
}

var (
	err error = godotenv.Load() //initialize godot environment variables

	server      string = os.Getenv("SERVER")
	user        string = os.Getenv("DB_USER")
	password    string = os.Getenv("DB_PASSWORD")
	port        string = os.Getenv("PORT")
	database    string = os.Getenv("DATABASE")
	source      string = os.Getenv("SOURCE")
	destination string = os.Getenv("DESTINATION")
)

//ToDo: panic if destination is prd or prod
func main() {
	start := time.Now()

	port, err := strconv.Atoi(port)
	connStringSource := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d;database=%s", server, user, password, port, database)

	dbSource, err := sqlx.Connect("mssql", connStringSource)
	if err != nil {
		log.Fatalln(err)
	}

	connStringDestination := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d;database=%s", server, user, password, port, database)

	dbDestination, err := sqlx.Connect("mssql", connStringDestination)
	if err != nil {
		log.Fatalln(err)
	}

	//cap max exectuted go routines with channel
	maxGoroutines := 2
	goRoutineThreshold := make(chan struct{}, maxGoroutines)

	var wg sync.WaitGroup
	// initialize progress bar together with WaitGroup
	p := mpb.New(mpb.WithWaitGroup(&wg))

	// 1. Get all tables from source schema
	var tableNames []string
	dbSource.Select(&tableNames, fmt.Sprintf("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '%s'", source))

	for _, tableName := range tableNames {
		// !!!might be better performance wise to remove all constraints truncate and re-add contrains
		// disable all constraints
		dbDestination.Exec(fmt.Sprintf("ALTER TABLE %s.%s NOCHECK CONSTRAINT all", destination, tableName))
	}

	for i := 0; i < len(tableNames); i++ {
		goRoutineThreshold <- struct{}{}
		wg.Add(1)

		name := fmt.Sprintf("Table#%s:", tableNames[i])

		bar := p.AddBar(int64(100),
			mpb.PrependDecorators(
				// simple name decorator
				decor.Name(name, decor.WC{W: 20, C: decor.DidentRight}), // TODO: W should be len() longest tableName
				// decor.DSyncWidth bit enables column width synchronization
				decor.Percentage(decor.WCSyncSpace),
			),
			mpb.AppendDecorators(
				// replace ETA decorator with "done" message, OnComplete event
				decor.OnComplete(
					// ETA decorator with ewma age of 60
					decor.EwmaETA(decor.ET_STYLE_GO, 60), "done",
				),
			),
		)

		go func(n int) {
			copyDataToDestinationTable(dbSource, dbDestination, &wg, bar, tableNames[n])
			<-goRoutineThreshold
		}(i)
	}

	wg.Wait()

	for _, tableName := range tableNames {
		// enable all constraints
		dbDestination.Exec(fmt.Sprintf("ALTER TABLE %s.%s WITH CHECK CHECK CONSTRAINT all", destination, tableName))
	}

	log.Println("finished copying data in", time.Since(start).Seconds(), "seconds")
}

func copyDataToDestinationTable(dbSource *sqlx.DB, dbDestination *sqlx.DB, wg *sync.WaitGroup, bar *mpb.Bar, tableName string) {
	defer wg.Done()

	for j := 0; j < 100; j++ {
		time.Sleep(time.Second)
		bar.Increment()
	}

	// delete data in destination table
	dbDestination.Exec(fmt.Sprintf("DELETE FROM %s.%s", destination, tableName))

	// 2. Get columnNames and dataType of table x
	metaData := []ColumnMetaData{}
	err = dbSource.Select(&metaData, fmt.Sprintf("SELECT COLUMN_NAME, DATA_TYPE, NUMERIC_PRECISION, NUMERIC_SCALE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '%s' AND TABLE_SCHEMA='%s'", tableName, source))

	var columnNames []string
	for _, columnMetaData := range metaData {
		columnNames = append(columnNames, columnMetaData.ColumnName)
	}

	// 3. Get all table entries of source table
	rows, err := dbSource.Queryx(fmt.Sprintf("SELECT * FROM %s.%s", source, tableName))

	var arrayOfValueSlices [][]interface{}

	for rows.Next() {
		slice, err := rows.SliceScan()
		if err != nil {
			log.Fatal(err.Error())
		}
		arrayOfValueSlices = append(arrayOfValueSlices, slice)
	}

	// Bulk insert
	txn, err := dbSource.Begin()
	if err != nil {
		log.Fatal(err)
	}

	stmt, err := txn.Prepare(mssql.CopyIn(fmt.Sprintf("%s.%s", destination, tableName), mssql.BulkOptions{}, columnNames...))
	if err != nil {
		log.Fatal(err.Error())
	}

	for _, valueSlice := range arrayOfValueSlices {

		for idx, val := range valueSlice {
			switch v := val.(type) {
			case []byte:
				valueSlice[idx] = string(v) //used to convert decimals since mssql driver cant consume raw []byte
			default:
			}
		}

		_, err = stmt.Exec(valueSlice...)
		if err != nil {
			log.Fatal(err.Error())
		}
	}

	result, err := stmt.Exec()
	if err != nil {
		log.Fatal(err)
	}

	err = stmt.Close()
	if err != nil {
		log.Fatal(err)
	}

	err = txn.Commit()
	if err != nil {
		log.Fatal(err)
	}
	rowCount, _ := result.RowsAffected()
	log.Printf("%d row copied\n", rowCount)
}
