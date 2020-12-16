package main

import (
	"fmt"
	"log"
	"os"
	"strconv"

	_ "github.com/denisenkom/go-mssqldb"
	mssql "github.com/denisenkom/go-mssqldb"
	"github.com/jmoiron/sqlx"
	"github.com/joho/godotenv"
)

// ColumnMetaData holds structred meta information of table columns / source -> INFORMATION_SCHEMA.COLUMNS
type ColumnMetaData struct {
	ColumnName string `db:"COLUMN_NAME"`
	DataType   string `db:"DATA_TYPE"`
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

//ToDo: panic if destination if prd or prod
func main() {
	port, err := strconv.Atoi(port)
	connString := fmt.Sprintf("server=%s;user id=%s;password=%s;port=%d;database=%s", server, user, password, port, database)

	dbSource, err := sqlx.Connect("mssql", connString)
	if err != nil {
		log.Fatalln(err)
	}

	// 1. Get all tables from source schema
	var tableNames []string
	dbSource.Select(&tableNames, fmt.Sprintf("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '%s'", source))

	// 2. Get columnNames and dataType of table x
	metaData := []ColumnMetaData{}
	err = dbSource.Select(&metaData, fmt.Sprintf("SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'testdata' AND TABLE_SCHEMA='%s'", source))

	var columnNames []string
	for _, columnMetaData := range metaData {
		columnNames = append(columnNames, columnMetaData.ColumnName)
	}

	// 3. Get all table entries of source table
	rows, err := dbSource.Queryx(fmt.Sprintf("SELECT * FROM %s.testdata", source))

	var arrayOfValueSlices [][]interface{}

	for rows.Next() {
		slice, err := rows.SliceScan()
		if err != nil {
			log.Fatal(err.Error())
		}
		arrayOfValueSlices = append(arrayOfValueSlices, slice)
	}

	// Remove table columns from destination
	dbSource.Exec(fmt.Sprintf("TRUNCATE TABLE %s.testdata", destination))

	// Bulk insert
	txn, err := dbSource.Begin()
	if err != nil {
		log.Fatal(err)
	}

	stmt, err := txn.Prepare(mssql.CopyIn(fmt.Sprintf("%s.testdata", destination), mssql.BulkOptions{}, columnNames...))
	if err != nil {
		log.Fatal(err.Error())
	}

	for _, valueSlice := range arrayOfValueSlices {
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
