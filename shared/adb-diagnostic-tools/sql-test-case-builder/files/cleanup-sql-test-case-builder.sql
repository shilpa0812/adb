BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ll_tcb_orders PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
  FOR rec IN (
    SELECT object_name
    FROM   DBMS_CLOUD.LIST_FILES(directory_name => 'SQL_TCB_DIR')
    WHERE  object_name LIKE 'LL_TCB_CASE%'
  ) LOOP
    DBMS_CLOUD.DELETE_FILE(
      directory_name => 'SQL_TCB_DIR',
      file_name      => rec.object_name);
  END LOOP;
END;
/
