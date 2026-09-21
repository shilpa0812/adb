<copy>
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE adb_sqldev_orders PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE adb_sqldev_orders AS
SELECT LEVEL AS order_id,
       MOD(LEVEL, 50) AS customer_id,
       ROUND(DBMS_RANDOM.VALUE(10, 5000), 2) AS order_total,
       TRUNC(SYSDATE) - MOD(LEVEL, 365) AS order_date,
       DBMS_RANDOM.STRING('A', 40) AS notes
FROM   dual
CONNECT BY LEVEL <= 50000;

BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(USER, 'ADB_SQLDEV_ORDERS');
END;
/

SELECT /* ADB_SQLDEV_HEALTH_TARGET */ /*+ MONITOR */
       customer_id,
       COUNT(*) AS order_count,
       ROUND(SUM(LN(order_total)), 2) AS total_work
FROM   adb_sqldev_orders
WHERE  order_date >= TRUNC(SYSDATE) - 180
GROUP  BY customer_id
ORDER  BY total_work DESC
FETCH FIRST 10 ROWS ONLY;
</copy>
