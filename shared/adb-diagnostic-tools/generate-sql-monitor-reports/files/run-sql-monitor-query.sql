SELECT /* LL_SQLMON_TARGET */
       c.region,
       o.order_status,
       COUNT(*) AS order_count,
       ROUND(SUM(LN(o.order_total)), 2) AS total_revenue,
       ROUND(AVG(LN(o.order_total)), 2) AS average_order_value
FROM   ll_sqlmon_orders o
JOIN   ll_sqlmon_customers c
       ON c.customer_id = o.customer_id
JOIN   (SELECT LEVEL AS n FROM dual CONNECT BY LEVEL <= 100) multiplier
       ON multiplier.n >= 1
WHERE  o.order_date >= TRUNC(SYSDATE) - 180
GROUP  BY c.region, o.order_status
ORDER  BY c.region, o.order_status;
