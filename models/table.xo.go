// Package models contains the types for schema 'public'.
package models

// GENERATED BY XO. DO NOT EDIT.

// Table represents table info.
type Table struct {
	Type         string // type
	TableName    string // table_name
	TableComment string // table_comment
	ManualPk     bool   // manual_pk
}

// PgTables runs a custom query, returning results as Table.
func PgTables(db XODB, schema string, relkind string) ([]*Table, error) {
	var err error

	// sql query
	const sqlstr = `SELECT ` +
		`c.relkind, ` + // ::varchar AS type
		`c.relname, ` + // ::varchar AS table_name
		`false ` + // ::boolean AS manual_pk
		`FROM pg_class c ` +
		`JOIN ONLY pg_namespace n ON n.oid = c.relnamespace ` +
		`WHERE n.nspname = $1 AND c.relkind = $2`

	// run query
	XOLog(sqlstr, schema, relkind)
	q, err := db.Query(sqlstr, schema, relkind)
	if err != nil {
		return nil, err
	}
	defer q.Close()

	// load results
	res := []*Table{}
	for q.Next() {
		t := Table{}

		// scan
		err = q.Scan(&t.Type, &t.TableName, &t.ManualPk)
		if err != nil {
			return nil, err
		}

		res = append(res, &t)
	}

	return res, nil
}

// MyTables runs a custom query, returning results as Table.
func MyTables(db XODB, schema string, relkind string) ([]*Table, error) {
	var err error

	// sql query
	const sqlstr = `SELECT ` +
		`table_name, ` +
		`table_comment ` +
		`FROM information_schema.tables ` +
		`WHERE table_schema = ? AND table_type = ?`

	// run query
	XOLog(sqlstr, schema, relkind)
	q, err := db.Query(sqlstr, schema, relkind)
	if err != nil {
		return nil, err
	}
	defer q.Close()

	// load results
	res := []*Table{}
	for q.Next() {
		t := Table{}

		// scan
		err = q.Scan(&t.TableName, &t.TableComment)
		if err != nil {
			return nil, err
		}

		res = append(res, &t)
	}

	return res, nil
}

// SqTables runs a custom query, returning results as Table.
func SqTables(db XODB, relkind string) ([]*Table, error) {
	var err error

	// sql query
	const sqlstr = `SELECT ` +
		`tbl_name AS table_name ` +
		`FROM sqlite_master ` +
		`WHERE tbl_name NOT LIKE 'sqlite_%' AND type = ?`

	// run query
	XOLog(sqlstr, relkind)
	q, err := db.Query(sqlstr, relkind)
	if err != nil {
		return nil, err
	}
	defer q.Close()

	// load results
	res := []*Table{}
	for q.Next() {
		t := Table{}

		// scan
		err = q.Scan(&t.TableName)
		if err != nil {
			return nil, err
		}

		res = append(res, &t)
	}

	return res, nil
}

// MsTables runs a custom query, returning results as Table.
func MsTables(db XODB, schema string, relkind string) ([]*Table, error) {
	var err error

	// sql query
	const sqlstr = `SELECT ` +
		`xtype AS type, ` +
		`name AS table_name ` +
		`FROM sysobjects ` +
		`WHERE SCHEMA_NAME(uid) = $1 AND xtype = $2`

	// run query
	XOLog(sqlstr, schema, relkind)
	q, err := db.Query(sqlstr, schema, relkind)
	if err != nil {
		return nil, err
	}
	defer q.Close()

	// load results
	res := []*Table{}
	for q.Next() {
		t := Table{}

		// scan
		err = q.Scan(&t.Type, &t.TableName)
		if err != nil {
			return nil, err
		}

		res = append(res, &t)
	}

	return res, nil
}

// OrTables runs a custom query, returning results as Table.
func OrTables(db XODB, schema string, relkind string) ([]*Table, error) {
	var err error

	// sql query
	const sqlstr = `SELECT ` +
		`LOWER(object_name) AS table_name ` +
		`FROM all_objects ` +
		`WHERE owner = UPPER(:1) AND object_type = UPPER(:2) ` +
		`AND object_name NOT LIKE '%$%' ` +
		`AND object_name NOT LIKE 'LOGMNR%_%' ` +
		`AND object_name NOT LIKE 'REDO_%' ` +
		`AND object_name NOT LIKE 'SCHEDULER_%_TBL' ` +
		`AND object_name NOT LIKE 'SQLPLUS_%'`

	// run query
	XOLog(sqlstr, schema, relkind)
	q, err := db.Query(sqlstr, schema, relkind)
	if err != nil {
		return nil, err
	}
	defer q.Close()

	// load results
	res := []*Table{}
	for q.Next() {
		t := Table{}

		// scan
		err = q.Scan(&t.TableName)
		if err != nil {
			return nil, err
		}

		res = append(res, &t)
	}

	return res, nil
}
