# Create a SQL Health Check Report

## Introduction

A SQL Health Check style report provides focused diagnostic evidence for one SQL statement. It includes the SQL text, execution plans, optimizer statistics, and related SQL management information. In this lab, you create a tagged workload, identify its SQL_ID, and use Oracle SQL Developer Desktop to create and review an HTML report with `DBMS_SQLDIAG.REPORT_SQL`.

Estimated Time: 25 minutes

### Objectives

In this lab, you will:

- Verify that the SQL diagnostic package and required performance views are available.
- Create a small workshop workload and capture its SQL_ID.
- Check the selected SQL statement and execution plan.
- Create a SQL Health Check style HTML report in SQL Developer script mode.
- Review the report and package useful diagnostic evidence.

### Prerequisites

- You have completed the previous labs to provision an Oracle Autonomous AI Database.
- Oracle SQL Developer Desktop is installed on your computer.
- You have created an SQL Developer connection to the Autonomous AI Database using the Cloud Wallet. Use the previous SQL Developer lab if you need to create the connection.
- You have permission to query `V$SQL` and run `DBMS_XPLAN.DISPLAY_CURSOR`.
- You have permission to run `DBMS_SQLDIAG.REPORT_SQL`.
- Use a non-production schema. The sample table is removed during cleanup.

> **Note:** The SQL Health Check report can contain SQL text, object names, and database metadata. Review the contents before sharing the HTML file.

## Task 1: Check Required Access

1. Open SQL Developer Desktop and connect to the Autonomous AI Database.

2. Verify that the SQL diagnostic report function is available.

    ```sql
    <copy>
    SELECT owner,
           object_name,
           procedure_name
    FROM   all_procedures
    WHERE  object_name = 'DBMS_SQLDIAG'
    AND    procedure_name = 'REPORT_SQL';
    </copy>
    ```

3. Verify that your user can read the SQL performance view.

    ```sql
    <copy>
    SELECT COUNT(*) AS visible_sql_rows
    FROM   v$sql;
    </copy>
    ```

Confirm that the queries return results. If either query fails, ask your database administrator to provide the required access before continuing.

## Task 2: Create the Workshop SQL_ID

1. Download and run [Create the SQL Health Check workload](files/sql-health-check-workload.sql) in a SQL Developer worksheet connected to a non-production schema.

2. The script creates the `ADB_SQLDEV_ORDERS` table, gathers optimizer statistics, and runs a tagged SQL statement.

3. Search `V$SQL` for the unique comment tag and record the SQL_ID, child number, plan hash value, execution count, and last active time.

    ```sql
    <copy>
    SELECT sql_id,
           child_number,
           plan_hash_value,
           executions,
           last_active_time,
           SUBSTR(sql_text, 1, 120) AS sql_text
    FROM   v$sql
    WHERE  UPPER(sql_text) LIKE '%ADB_SQLDEV_HEALTH_TARGET%'
    ORDER  BY last_active_time DESC
    FETCH FIRST 5 ROWS ONLY;
    </copy>
    ```

4. Confirm that the selected SQL_ID belongs to the tagged statement. If more than one row is returned, choose the row with the most recent `LAST_ACTIVE_TIME`.

5. Replace `<replace_with_sql_id>` in the following query and review the plan before generating the report.

    ```sql
    <copy>
    SELECT *
    FROM   TABLE(DBMS_XPLAN.DISPLAY_CURSOR(
             sql_id          => '<replace_with_sql_id>',
             cursor_child_no => NULL,
             format          => 'BASIC +PREDICATE +NOTE'));
    </copy>
    ```

Record the plan hash value and any access paths, predicates, or optimizer notes that you want to compare with the report.

## Task 3: Create the SQL Health Check Report

1. Download [Create the SQL Health Check report](files/generate-sql-health-check-report.sql), and open it in the same SQL Developer connection.

2. Replace `REPLACE_WITH_SQL_ID` with the SQL_ID recorded in Task 2.

3. Replace the `SPOOL` path with a local folder that exists on your computer. For example, use `C:\LiveLabsNew\sql_health_check_report.html`.

4. Run the script with **Run Script** or press **F5**. Do not use **Run Statement**, because the `SPOOL` commands must run in script mode.

5. Open the generated HTML file and confirm that the report header contains the same SQL_ID that you recorded in Task 2.

> **Note:** If the report is empty or shows a different SQL_ID, confirm the SQL_ID and child cursor, rerun the tagged workload, and run the script again.

## Task 4: Review and Package the Evidence

Review the report and record the following information:

| Report area | What to look for |
| --- | --- |
| SQL identity and text | Confirm the exact SQL_ID, SQL text, parsing schema, and statement signature. |
| Execution plans | Compare plan hash values, access paths, predicates, and plan notes. |
| Optimizer statistics | Review object, index, column, histogram, and statistics-history details. |
| SQL management objects | Check profiles, baselines, patches, or outlines that can influence plan choice. |
| Related evidence | Correlate with SQL Monitor, AWR, ASH, or SQL Tuning Advisor results when available. |

Keep the HTML report, the SQL_ID query results, the plan output, and the workload time window together if you need to share the evidence for follow-up analysis. Do not apply recommendations directly from the report without a separate change review.

## Task 5: Clean Up

1. Download and run [Clean up the SQL Health Check workload](files/cleanup-sql-health-check-workload.sql).

2. Remove the generated HTML report from your local folder if it is no longer needed.

```sql
<copy>
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE adb_sqldev_orders PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
</copy>
```

You may now **proceed to the next lab**.

## Acknowledgements

- **Authors** - Shilpa Sharma, Principal User Assistance Developer
- **Contributors** - Nigel Bayliss, Product Management Architect
- **Last Updated By/Date** - Shilpa Sharma, September 2026
