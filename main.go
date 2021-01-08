package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"sync"
	"time"

	mssql "github.com/denisenkom/go-mssqldb"
	"github.com/jmoiron/sqlx"
	"github.com/joho/godotenv"
	"github.com/schollz/progressbar/v3"
)

// ColumnMetaData holds structred meta information of table columns / source -> INFORMATION_SCHEMA.COLUMNS
type ColumnMetaData struct {
	ColumnName       string        `db:"COLUMN_NAME"`
	DataType         string        `db:"DATA_TYPE"`
	NumericPrecision sql.NullInt32 `db:"NUMERIC_PRECISION"`
	NumericScale     sql.NullInt32 `db:"NUMERIC_SCALE"`
}

// ToDo: Load dotenv only in local mode e.g. with flag
// ToDo: EnvVar for ignored tables
var (
	forbiddenDestinations = []string{"prd", "prod", "production"}

	err error = godotenv.Load() //initialize godot environment variables

	server      string = os.Getenv("SERVER")
	user        string = os.Getenv("DB_USER")
	password    string = os.Getenv("DB_PASSWORD")
	port        string = os.Getenv("PORT")
	database    string = os.Getenv("DATABASE")
	source      string = os.Getenv("SOURCE")
	destination string = os.Getenv("DESTINATION")

	bulkOptions mssql.BulkOptions = mssql.BulkOptions{
		RowsPerBatch: 200,
	}
)

func main() {
	start := time.Now()

	for _, forbiddenDestination := range forbiddenDestinations {
		if strings.EqualFold(destination, forbiddenDestination) {
			panic(fmt.Sprintf(`You are not allowed to copy data to the following destinations: %v
	This is a safeguard, adjust the source code if needed.`, forbiddenDestinations))
		}
	}

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
	maxGoroutines := 5
	goRoutineThreshold := make(chan struct{}, maxGoroutines)

	var wg sync.WaitGroup

	// 1. Get all tables from source schema
	var tableNames []string
	dbSource.Select(&tableNames, fmt.Sprintf("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '%s'", source))

	// initialize progress bar
	bar := progressbar.NewOptions(len(tableNames),
		progressbar.OptionSetDescription("Copying tables ..."),
		progressbar.OptionSetPredictTime(false),
		progressbar.OptionFullWidth(),
		progressbar.OptionShowCount(),
		progressbar.OptionEnableColorCodes(true),
		progressbar.OptionSetTheme(progressbar.Theme{
			Saucer:        "[green]#[reset]",
			SaucerPadding: " ",
			BarStart:      "[",
			BarEnd:        "]",
		}))

	for _, tableName := range tableNames {
		// !!!might be better performance wise to remove all constraints truncate and re-add contrains
		// disable all constraints
		dbDestination.Exec(fmt.Sprintf("ALTER TABLE %s.%s NOCHECK CONSTRAINT all", destination, tableName))
	}

	for i := 0; i < len(tableNames); i++ {
		goRoutineThreshold <- struct{}{}
		wg.Add(1)

		go func(n int) {
			copyDataToDestinationTable(dbSource, dbDestination, &wg, tableNames[n])
			bar.Add(1)
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

func copyDataToDestinationTable(dbSource *sqlx.DB, dbDestination *sqlx.DB, wg *sync.WaitGroup, tableName string) {
	defer wg.Done()

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

	stmt, err := txn.Prepare(mssql.CopyIn(fmt.Sprintf("%s.%s", destination, tableName), bulkOptions, columnNames...))
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

	_, err = stmt.Exec()
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
}
