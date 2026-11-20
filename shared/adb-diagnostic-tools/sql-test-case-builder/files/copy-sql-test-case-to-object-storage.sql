BEGIN
  DBMS_CLOUD.PUT_OBJECT(
    credential_name => 'REPLACE_WITH_CREDENTIAL_NAME',
    object_uri      => 'https://objectstorage.<region>.oraclecloud.com/n/<namespace>/b/<bucket>/o/LL_TCB_CASE.zip',
    directory_name  => 'SQL_TCB_DIR',
    file_name       => 'REPLACE_WITH_ZIP_FILENAME');
END;
/
