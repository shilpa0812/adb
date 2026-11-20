SELECT testcase_name,
       sql_id,
       status,
       creation_date
FROM   v$sql_testcases
WHERE  sql_id = 'REPLACE_WITH_SQL_ID'
ORDER  BY creation_date DESC
FETCH FIRST 1 ROW ONLY;
