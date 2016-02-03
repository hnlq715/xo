// {{ .Type }} represents a row from {{ if .TableSchema }}{{ .TableSchema }}.{{ end }}{{ .TableName }}.
type {{ .Type }} struct {
{{- range .Fields }}
	{{ .Field }} {{ retype .GoType }}{{ if .Tag }} `{{ .Tag }}`{{ end }} // {{ .ColumnName }}
{{- end }}
{{- if .PrimaryKeyField }}

	// xo fields
	_exists, _deleted bool
{{ end }}
}

{{ if .PrimaryKeyField }}
// Exists determines if the {{ .Type }} exists in the database.
func (t *{{ .Type }}) Exists() bool {
	return t._exists
}

// Deleted provides information if the {{ .Type }} has been deleted from the database.
func (t *{{ .Type }}) Deleted() bool {
	return t._deleted
}

// Insert inserts the {{ .Type }} to the database.
func (t *{{ .Type }}) Insert(db DB) error {
	var err error

	// if already exist, bail
	if t._exists {
		return errors.New("insert {{ .Type }} failed: already exists")
	}

	// sql query
	const sqlstr = `INSERT INTO {{ .TableSchema }}.{{ .TableName }} (` +
		`{{ fields .Fields .PrimaryKeyField }}` +
		`) VALUES (` +
		`{{ values .Fields .PrimaryKeyField }}` +
		`) RETURNING {{ .PrimaryKey }}`

	// run query
	err = db.QueryRow(sqlstr, {{ cols .Fields .PrimaryKeyField "t" }}).Scan(&t.{{ .PrimaryKeyField }})
	if err != nil {
		return err
	}

	t._exists = true

	return nil
}

// Update updates the {{ .Type }} in the database.
func (t *{{ .Type }}) Update(db DB) error {
	var err error

	// if doesn't exist, bail
	if !t._exists {
		return errors.New("update {{ .Type }} failed: does not exist")
	}

	// if deleted, bail
	if t._deleted {
		return errors.New("update {{ .Type }} failed: marked for deletion")
	}

	// sql query
	const sqlstr = `UPDATE {{ .TableSchema }}.{{ .TableName }} SET (` +
		`{{ fields .Fields .PrimaryKeyField }}` +
		`) = ( ` +
		`{{ values .Fields .PrimaryKeyField }}` +
		`) WHERE {{ .PrimaryKey }} = ${{ count .Fields .PrimaryKeyField }}`

	// run query
	_, err = db.Exec(sqlstr, {{ cols .Fields .PrimaryKeyField "t" }}, t.{{ .PrimaryKeyField }})
	return err
}

// Save saves the {{ .Type }} to the database.
func (t *{{ .Type }}) Save(db DB) error {
	if t.Exists() {
		return t.Update(db)
	}

	return t.Insert(db)
}

// Upsert performs an upsert for {{ .Type }}.
//
// NOTE: PostgreSQL 9.5+ only
func (t *{{ .Type }}) Upsert(db DB) error {
	return nil
}

// Delete deletes the {{ .Type }} from the database.
func (t *{{ .Type }}) Delete(db DB) error {
	var err error

	// if doesn't exist, bail
	if !t._exists {
		return nil
	}

	// if deleted, bail
	if t._deleted {
		return nil
	}

	// sql query
	const sqlstr = `DELETE FROM {{ .TableSchema }}.{{ .TableName }} WHERE {{ .PrimaryKey }} = $1`

	// run query
	_, err = db.Exec(sqlstr, t.{{ .PrimaryKeyField }})
	if err != nil {
		return err
	}

	t._deleted = true

	return nil
}
{{ end -}}
