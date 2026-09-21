<copy>
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ll_awr_addm_orders PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE ll_awr_addm_orders AS
SELECT LEVEL AS order_id,
       MOD(LEVEL, 50) AS customer_group,
       TRUNC(SYSDATE) - MOD(LEVEL, 180) AS order_date,
       ROUND(10 + DBMS_RANDOM.VALUE(0, 5000), 2) AS order_total
FROM   dual
CONNECT BY LEVEL <= 100000;

BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(USER, 'LL_AWR_ADDM_ORDERS');
END;
/

SELECT /* LL_AWR_ADDM_TARGET */
       customer_group,
       COUNT(*) AS order_count,
       ROUND(SUM(LN(order_total)), 2) AS total_work
FROM   ll_awr_addm_orders
JOIN   (SELECT LEVEL AS n FROM dual CONNECT BY LEVEL <= 50)
       multiplier ON 1 = 1
WHERE  order_date >= TRUNC(SYSDATE) - 90
GROUP  BY customer_group
ORDER  BY total_work DESC;
</copy>
