SET SERVEROUTPUT ON

DECLARE
  CURSOR c_files IS
    SELECT object_name
    FROM   DBMS_CLOUD.LIST_FILES(directory_name => 'SQL_TCB_DIR')
    WHERE  object_name LIKE 'mytestcase%';
BEGIN
  FOR rec IN c_files LOOP
    DBMS_OUTPUT.PUT_LINE('Copying: ' || rec.object_name);
    DBMS_CLOUD.PUT_OBJECT(
      credential_name => NULL,
      directory_name  => 'SQL_TCB_DIR',
      file_name       => rec.object_name,
      object_uri      => 'REPLACE_WITH_FOLDER_PAR_URL' || rec.object_name);
  END LOOP;
END;
/
