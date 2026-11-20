DECLARE
  l_testcase CLOB;
BEGIN
  DBMS_SQLDIAG.EXPORT_SQL_TESTCASE(
    directory             => 'SQL_TCB_DIR',
    sql_id                => 'REPLACE_WITH_SQL_ID',
    exportData            => FALSE,
    preserveSchemaMapping => TRUE,
    testcase_name         => 'mytestcase',
    ctrlOptions           => '<parameter name="compress">yes</parameter>',
    testcase              => l_testcase);
END;
/
