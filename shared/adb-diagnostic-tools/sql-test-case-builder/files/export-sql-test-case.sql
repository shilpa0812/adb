DECLARE
  l_testcase CLOB;
BEGIN
  DBMS_SQLDIAG.EXPORT_SQL_TESTCASE(
    directory        => 'SQL_TCB_DIR',
    sql_id           => 'REPLACE_WITH_SQL_ID',
    plan_hash_value  => REPLACE_WITH_PLAN_HASH_VALUE,
    exportData       => FALSE,
    testcase_name    => 'LL_TCB_CASE',
    ctrlOptions      => '<parameter name="compress">yes</parameter>',
    testcase         => l_testcase);
END;
/
