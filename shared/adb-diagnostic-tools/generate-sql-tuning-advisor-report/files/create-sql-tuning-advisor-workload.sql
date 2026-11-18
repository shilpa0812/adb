-- Run only in a non-production lab schema.
-- This script recreates LL_STA_ORDERS.
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ll_sta_orders';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE ll_sta_orders NOLOGGING AS
SELECT level AS order_id,
       MOD(level, 10) AS region_id,
       TRUNC(SYSDATE) - MOD(level, 730) AS order_date,
       CASE WHEN MOD(level, 5) = 0 THEN 'OPEN' ELSE 'CLOSED' END AS order_status,
       ROUND(25 + MOD(level, 10000) / 10, 2) AS order_total
FROM dual
CONNECT BY level <= 100000;

BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(USER, 'LL_STA_ORDERS');
END;
/
