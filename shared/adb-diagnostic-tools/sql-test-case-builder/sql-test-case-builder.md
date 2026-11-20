# Generate a SQL Test Case for Oracle Support

## Introduction

SQL Test Case Builder packages a SQL statement and the metadata needed to reproduce its execution plan on another database. This information can help Oracle Support investigate a SQL performance problem without requiring access to the source database.

In this lab, you create a small workload, identify its SQL ID, export a compressed SQL test case, and copy the generated files to Object Storage for download. The export does not include table data.

Estimated Time: 15 minutes

### Objectives

In this lab, you will:

- Create and run a tagged SQL workload.
- Identify the SQL ID for the workload statement.
- Export and verify a compressed SQL test case.
- Copy the generated files to Object Storage for download.

### Prerequisites

- An available Oracle Autonomous AI Database instance.
- Access to SQL Developer or Database Actions SQL Worksheet.
- Access to the `ADMIN` user or another account authorized to run `DBMS_SQLDIAG.EXPORT_SQL_TESTCASE` and read `SQL_TCB_DIR`.
- An Object Storage bucket and a pre-authenticated request for the target folder, or another transfer method approved by your administrator.

> **Note:** SQL Test Case Builder is an advanced diagnostic tool. Use it for a SQL statement identified during an AWR, ASH, SQL Monitor, Performance Hub, or Oracle Support investigation.

## Task 1: Create a Test Workload

1. Download [Create the SQL Test Case Builder workload](files/create-sql-test-case-workload.sql), and then open it in a SQL worksheet connected to a non-production schema.

2. Click **Run Script** or press **F5**. The script recreates `LL_TCB_ORDERS`, gathers optimizer statistics, and runs a query tagged with `LL_TCB_TARGET`.

    ```sql
    <copy>
    SELECT /* LL_TCB_TARGET */
           region_id,
           order_status,
           COUNT(*) AS order_count,
           SUM(order_total) AS total_amount
    FROM   ll_tcb_orders
    WHERE  order_date >= TRUNC(SYSDATE) - 180
    GROUP  BY region_id, order_status
    ORDER  BY region_id, order_status;
    </copy>
    ```

3. Run the following query immediately after the workload. Record the SQL ID returned for the tagged statement.

    ```sql
    <copy>
    SELECT sql_id,
           plan_hash_value,
           last_active_time
    FROM   v$sql
    WHERE  sql_text LIKE '%LL_TCB_TARGET%'
    AND    sql_text NOT LIKE '%v$sql%'
    ORDER  BY last_active_time DESC
    FETCH FIRST 1 ROW ONLY;
    </copy>
    ```

The SQL statement must remain in the cursor cache when you export the test case. If the export cannot find it, rerun the workload query and repeat the SQL ID lookup.

## Task 2: Export the SQL Test Case

`SQL_TCB_DIR` is created automatically in Autonomous AI Database. The export writes the test case files to this directory.

1. Download [Export the SQL test case](files/export-sql-test-case.sql), and then open it in a SQL worksheet connected as `ADMIN` or another authorized user.

2. Replace `REPLACE_WITH_SQL_ID` with the SQL ID recorded in Task 1.

3. Review the `preserveSchemaMapping` setting:

    - `TRUE` preserves the source schema mapping. The corresponding schema users must exist on the target database.
    - `FALSE` allows the test case to be imported into a single target user.

4. Click **Run Script** or press **F5**.

    ```sql
    <copy>
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
    </copy>
    ```

`exportData => FALSE` is the default behavior and prevents table rows from being included. The package contains SQL, object definitions, optimizer statistics, and other environment metadata needed to reproduce the SQL execution plan.

## Task 3: Verify and Download the Test Case

1. Download and run [List the SQL test case files](files/list-sql-test-case-files.sql).

    ```sql
    <copy>
    SELECT object_name,
           bytes,
           created
    FROM   DBMS_CLOUD.LIST_FILES(directory_name => 'SQL_TCB_DIR')
    WHERE  object_name LIKE 'mytestcase%'
    ORDER  BY created;
    </copy>
    ```

The output normally includes `mytestcase.zip`, `mytestcasesql.xml`, and `mytestcasemain.xml`. Retain all files created for the test case.

2. Download [Copy the SQL test case to Object Storage](files/copy-sql-test-case-to-object-storage.sql).

3. Replace `REPLACE_WITH_FOLDER_PAR_URL` with the pre-authenticated request URL for the target Object Storage folder. Keep the trailing slash in the URL.

4. Click **Run Script** or press **F5**. The script copies every file beginning with `mytestcase` from `SQL_TCB_DIR` to Object Storage.

5. Download the files from Object Storage. If Oracle Support requested the test case, attach the files to the applicable Service Request and include the SQL ID and a brief description of the issue.

> **Caution:** Treat a pre-authenticated request URL as sensitive. Do not include it in the test case package or share it in the Service Request.

## Task 4: Clean Up

1. Download and run [Clean up the SQL Test Case Builder lab](files/cleanup-sql-test-case-builder.sql). The script removes the lab table and the generated `mytestcase` files from `SQL_TCB_DIR`.

2. Remove the copied files from Object Storage when they are no longer needed and your retention policy allows it.

You may now **proceed to the next lab**.

## Learn More

- [Diagnosing and Resolving Problems with SQL Test Case Builder](https://docs.oracle.com/en/database/oracle/oracle-database/26/admin/diagnosing-and-resolving-problems.html)
- [DBMS_SQLDIAG Package Reference](https://docs.oracle.com/en/database/oracle/oracle-database/26/arpls/DBMS_SQLDIAG.html)
- [List Directory Contents in Autonomous AI Database](https://docs.oracle.com/en/cloud/paas/autonomous-database/serverless/adbsb/list-directory-contents.html)
- [DBMS_CLOUD Subprograms](https://docs.oracle.com/en-us/iaas/autonomous-database-serverless/doc/dbms-cloud-subprograms.html)

## Acknowledgements

- **Authors** - Shilpa Sharma, Principal User Assistance Developer
- **Contributors** - Nigel Bayliss, Product Management Architect
- **Last Updated By/Date** - Shilpa Sharma, November 2026
