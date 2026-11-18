-- Run in SQL Developer Desktop using Run Script (F5).
VAR task_name VARCHAR2(30)
SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF
SET PAGESIZE 0
SET LINESIZE 200
SET LONG 1000000
-- Use a full path to an existing local folder if required.
SPOOL SQL_Tuning_Advisor_Report.txt

DECLARE
  statement_text CLOB := q'[
SELECT /* LL_STA_TARGET */
       region_id,
       order_status,
       COUNT(*) AS order_count,
       SUM(order_total) AS total_amount
FROM ll_sta_orders
WHERE order_date >= TRUNC(SYSDATE) - 180
GROUP BY region_id, order_status
ORDER BY region_id, order_status
]';
BEGIN
  :task_name := DBMS_SQLTUNE.CREATE_TUNING_TASK(
    sql_text   => statement_text,
    time_limit => 120);
END;
/

BEGIN
  DBMS_SQLTUNE.EXECUTE_TUNING_TASK(:task_name);
END;
/

SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK(
         :task_name, 'TEXT', 'ALL', 'ALL') AS report
FROM dual;
SPOOL OFF
