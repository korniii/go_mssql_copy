package main

import (
	"fmt"
	"log"
	"strings"

	_ "github.com/denisenkom/go-mssqldb"
	mssql "github.com/denisenkom/go-mssqldb"
	"github.com/jmoiron/sqlx"
	dynamicstruct "github.com/ompluscator/dynamic-struct"
)

type TableMetaData struct {
	ColumnName 	string	`db:"COLUMN_NAME"`
	DataType 	string 	`db:"DATA_TYPE"`
}

type Test struct {
	Id int
	RandString string
}

func main() {
	dbSource, err := sqlx.Connect("mssql", "sqlserver://sa:Password!123@localhost:1433?database=test_db")
	if err != nil {
		log.Fatalln(err)
	}

	// 1. Get all tables from source schema
	var tableNames []string;
	dbSource.Select(&tableNames, "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'source'")
	fmt.Println(tableNames)

	// 2. Get columnNames and dataType of table x
	metaData := []TableMetaData{}
	err = dbSource.Select(&metaData, "SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'testdata' AND TABLE_SCHEMA='source'")
	fmt.Println(metaData)

	// 3. Get all table entries of source table
	metaDataStructBuilder := dynamicstruct.NewStruct()
	var columnNames []string 

	for _, columnMetaData := range metaData {
		metaDataStructBuilder.AddField(strings.ToUpper(columnMetaData.ColumnName), stringToDataType(columnMetaData.DataType), "");
		columnNames = append(columnNames, columnMetaData.ColumnName)
	}
	
	rows, err := dbSource.Queryx("SELECT * FROM source.testdata")

	var arrayOfValueSlices [][]interface{}

	for rows.Next() {
		slice, err := rows.SliceScan()
		if err != nil {
			log.Fatal(err.Error())
		}
		arrayOfValueSlices = append(arrayOfValueSlices, slice)
	}

	txn, err := dbSource.Begin()
	if err != nil {
		log.Fatal(err)
	}

	stmt, err := txn.Prepare(mssql.CopyIn("dest.testdata", mssql.BulkOptions{}, columnNames...))
	if err != nil {
		log.Fatal(err.Error())
	}

	for _, valueSlice := range arrayOfValueSlices {
		_, err = stmt.Exec(valueSlice ...)
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
	log.Printf("bye\n")
}

func stringToDataType (stringifiedData string) interface{} {
	switch stringifiedData {
	case "int":
		var v *int64
		return v
	case "varchar":
		var v *string
		return v;
	default:
		log.Fatalf("Datatype nit found")
	}
	return nil;
}
