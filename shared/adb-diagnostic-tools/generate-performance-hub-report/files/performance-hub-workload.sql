BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ll_ph_orders PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE ll_ph_orders AS
SELECT level AS order_id,
       MOD(level, 50) AS customer_id,
       ROUND(DBMS_RANDOM.VALUE(10, 5000), 2) AS order_total,
       TRUNC(SYSDATE) - MOD(level, 365) AS order_date,
       DBMS_RANDOM.STRING('A', 40) AS notes
FROM dual
CONNECT BY level <= 50000;

BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(USER, 'LL_PH_ORDERS');
END;
/

SELECT /* LL_PERFORMANCE_HUB_TARGET */
       customer_id,
       COUNT(*) AS order_count,
       ROUND(SUM(LN(order_total)), 2) AS total_work
FROM   ll_ph_orders
WHERE  order_date >= TRUNC(SYSDATE) - 180
GROUP  BY customer_id
ORDER  BY total_work DESC
FETCH FIRST 10 ROWS ONLY;
