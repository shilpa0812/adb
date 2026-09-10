SET ECHO OFF FEEDBACK OFF VERIFY OFF HEADING OFF PAGESIZE 0
SET LINESIZE 32767 TRIMSPOOL ON LONG 1000000 LONGCHUNKSIZE 32767

VARIABLE l_dbid NUMBER
VARIABLE l_inst_num NUMBER

BEGIN
  SELECT dbid INTO :l_dbid FROM v$database;
  SELECT instance_number INTO :l_inst_num FROM v$instance;
END;
/

SPOOL ash_report.html

SELECT output
FROM TABLE(DBMS_WORKLOAD_REPOSITORY.ASH_REPORT_HTML(
  l_dbid     => :l_dbid,
  l_inst_num => :l_inst_num,
  l_btime    => SYSDATE - (15 / 1440),
  l_etime    => SYSDATE,
  l_sql_id   => 'REPLACE_WITH_SQL_ID'));

SPOOL OFF
