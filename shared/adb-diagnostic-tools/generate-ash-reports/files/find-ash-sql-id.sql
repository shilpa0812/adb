SELECT sql_id,
       child_number,
       elapsed_time,
       executions,
       last_active_time,
       sql_text
FROM   v$sql
WHERE  sql_text LIKE '%LL_ASH_TARGET%'
AND    sql_text NOT LIKE '%v$sql%'
ORDER  BY last_active_time DESC
FETCH FIRST 1 ROW ONLY;
