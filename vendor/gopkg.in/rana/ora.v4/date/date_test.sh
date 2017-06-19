#!/bin/sh
export ORACLE_HOME=${ORACLE_HOME:-/u01/app/oracle/product/11.2.0/xe}
set -x
{
	cat <<EOF
// GENERATED by $0 on `date '+%Y-%m-%d %H:%M:%S'`
package date_test

var dateTestData = []struct{
	S string
	B [7]byte
} {
EOF
$ORACLE_HOME/bin/sqlplus -s $GO_ORA_DRV_TEST_USERNAME/$GO_ORA_DRV_TEST_PASSWORD@$GO_ORA_DRV_TEST_DB <<EOF
SET PAGES 0 PAUSE OFF LINESIZE 1000 TIMI OFF FEED OFF
SELECT '{"'||TO_CHAR(A.dt, 'YYYY-MM-DD"T"HH24:MI:SS')||'", [7]byte{'||
	SUBSTR(DUMP(A.dt), 15)||'}}, //'||DUMP(A.dt)
  FROM (SELECT CAST(TO_DATE('0001-01-01', 'YYYY-MM-DD') +
                    DBMS_RANDOM.VALUE * 23251 * 48 +
					dbms_random.value * ROWNUM
					AS DATE) dt
          FROM ALL_OBJECTS WHERE ROWNUM < 1001) A;
EXIT
EOF
echo '}'
} | gofmt >date_gen_test.go
