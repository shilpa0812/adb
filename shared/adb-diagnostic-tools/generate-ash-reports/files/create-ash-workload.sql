BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ll_ash_orders PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ll_ash_customers PURGE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

CREATE TABLE ll_ash_customers AS
SELECT LEVEL AS customer_id,
       CASE MOD(LEVEL, 5)
         WHEN 0 THEN 'NORTHEAST'
         WHEN 1 THEN 'SOUTHEAST'
         WHEN 2 THEN 'MIDWEST'
         WHEN 3 THEN 'SOUTHWEST'
         ELSE 'WEST'
       END AS region
FROM dual
CONNECT BY LEVEL <= 50000;

CREATE TABLE ll_ash_orders AS
SELECT MOD(LEVEL - 1, 50000) + 1 AS customer_id,
       TRUNC(SYSDATE) - MOD(LEVEL, 730) AS order_date,
       CASE MOD(LEVEL, 3)
         WHEN 0 THEN 'NEW'
         WHEN 1 THEN 'SHIPPED'
         ELSE 'CLOSED'
       END AS order_status,
       ROUND(25 + DBMS_RANDOM.VALUE(0, 5000), 2) AS order_total
FROM dual
CONNECT BY LEVEL <= 600000;

BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(USER, 'LL_ASH_CUSTOMERS');
  DBMS_STATS.GATHER_TABLE_STATS(USER, 'LL_ASH_ORDERS');
END;
/

SELECT /* LL_ASH_TARGET */
       c.region,
       o.order_status,
       COUNT(*) AS order_count,
       ROUND(SUM(o.order_total), 2) AS total_revenue
FROM   ll_ash_orders o
JOIN   ll_ash_customers c
       ON c.customer_id = o.customer_id
JOIN   (SELECT LEVEL AS n FROM dual CONNECT BY LEVEL <= 100) multiplier
       ON multiplier.n >= 1
WHERE  o.order_date >= TRUNC(SYSDATE) - 180
GROUP  BY c.region, o.order_status
ORDER  BY c.region, o.order_status;
