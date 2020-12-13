package main

import (
	"fmt"
	"log"

	_ "github.com/denisenkom/go-mssqldb"
	"github.com/jmoiron/sqlx"
)

type TableMetaData struct {
	ColumnName 	string	`db:"COLUMN_NAME"`
	DataType 	string 	`db:"DATA_TYPE"`
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

	// 2.5 dynamic struct?

	// 3. Get all table entries of source table

	// 4. Truncate destination table

	// 5. Insert into destination table (disable table rules)


	// m := map[string]interface{}{}

	// rows, err := dbSource.Queryx("SELECT * FROM source.testdata")
	// for rows.Next() {
	// 	err := rows.MapScan(m)
	// 	if err != nil {
	// 		log.Fatal(err)
	// 	}
	// 	// b, _ := json.Marshal(m)
	// 	fmt.Println(len(m))
	// 	y := "id"
	// 	x := m[y]
	// 	fmt.Println(x)
	// 	// fmt.Println(string(b))

	// 	// err = json.Unmarshal(b, &instance)
	// 	// if err != nil {
	// 	// 	log.Fatal(err)
	// 	// }

	// 	// b, err = json.Marshal(instance)
	// 	// if err != nil {
	// 	// 	log.Fatal(err)
	// 	// }

	// 	// fmt.Println(string(data))
	// }

}
