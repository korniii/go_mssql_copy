package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"strconv"

	mssql "github.com/denisenkom/go-mssqldb"
	"github.com/jmoiron/sqlx"
	"github.com/joho/godotenv"
)

// ColumnMetaData holds structred meta information of table columns / source -> INFORMATION_SCHEMA.COLUMNS
type ColumnMetaData struct {
	ColumnName 			string 			`db:"COLUMN_NAME"`
	DataType 			string 			`db:"DATA_TYPE"`
	NumericPrecision	sql.NullInt32 	`db:"NUMERIC_PRECISION"`
	NumericScale		sql.NullInt32 	`db:"NUMERIC_SCALE"`
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

	// 1. Get all tables from source schema
	var tableNames []string
	dbSource.Select(&tableNames, fmt.Sprintf("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '%s'", source))

	for _, tableName := range tableNames {
		// !!!might be better performance wise to remove all constraints truncate and re-add contrains
		// disable all constraints
		dbDestination.Exec(fmt.Sprintf("ALTER TABLE %s.%s NOCHECK CONSTRAINT all", destination, tableName))
	}

	for _, tableName := range tableNames {
		copyDataToDestinationTable(dbSource, dbDestination, tableName)
	}

	for _, tableName := range tableNames {
		// enable all constraints
		dbDestination.Exec(fmt.Sprintf("ALTER TABLE %s.%s WITH CHECK CHECK CONSTRAINT all", destination, tableName))
	}
}

func copyDataToDestinationTable(dbSource *sqlx.DB, dbDestination *sqlx.DB, tableName string) {
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
			case []byte: valueSlice[idx] = string(v) //used to convert decimals since mssql driver cant consume raw []byte
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