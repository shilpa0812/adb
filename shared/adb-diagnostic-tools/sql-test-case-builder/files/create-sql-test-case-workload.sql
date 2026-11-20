BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ll_tcb_orders PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE ll_tcb_orders NOLOGGING AS
SELECT LEVEL AS order_id,
       MOD(LEVEL, 10) AS region_id,
       TRUNC(SYSDATE) - MOD(LEVEL, 730) AS order_date,
       CASE WHEN MOD(LEVEL, 5) = 0 THEN 'OPEN' ELSE 'CLOSED' END AS order_status,
       ROUND(25 + MOD(LEVEL, 10000) / 10, 2) AS order_total
FROM   dual
CONNECT BY LEVEL <= 20000;

BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(USER, 'LL_TCB_ORDERS');
END;
/

SELECT /* LL_TCB_TARGET */
       region_id,
       order_status,
       COUNT(*) AS order_count,
       SUM(order_total) AS total_amount
FROM   ll_tcb_orders
WHERE  order_date >= TRUNC(SYSDATE) - 180
GROUP  BY region_id, order_status
ORDER  BY region_id, order_status;

SELECT sql_id,
       plan_hash_value,
       last_active_time
FROM   v$sql
WHERE  sql_text LIKE '%LL_TCB_TARGET%'
AND    sql_text NOT LIKE '%v$sql%'
ORDER  BY last_active_time DESC
FETCH FIRST 1 ROW ONLY;
