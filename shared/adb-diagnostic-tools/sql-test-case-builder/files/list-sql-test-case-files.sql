SELECT object_name,
       bytes,
       created
FROM   DBMS_CLOUD.LIST_FILES(directory_name => 'SQL_TCB_DIR')
WHERE  object_name LIKE 'mytestcase%'
ORDER  BY created;
