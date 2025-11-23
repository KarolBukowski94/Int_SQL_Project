CREATE OR REPLACE VIEW quarter_revenue_customer_trends AS -- Power BI visualization

WITH quarter_metrics AS (
  SELECT
      DATE_TRUNC('quarter', ca.orderdate)::date AS year_quarter,
      SUM(total_net_revenue) AS total_revenue,
      COUNT(DISTINCT ca.customerkey) AS total_customers,
      SUM(total_net_revenue) / COUNT(DISTINCT ca.customerkey) AS customer_revenue
  FROM cohort_analysis ca
  WHERE orderdate = first_purchase_date
  GROUP BY    
      year_quarter
  ORDER BY
      year_quarter
)
SELECT
    year_quarter,
    total_revenue,
    AVG(total_revenue) OVER (
        ORDER BY year_quarter 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS rolling_3mo_total_revenue,
    AVG(total_customers) OVER (
        ORDER BY year_quarter 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS rolling_3mo_total_customers,
    AVG(customer_revenue) OVER (
        ORDER BY year_quarter 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS rolling_3mo_customer_revenue
FROM quarter_metrics
ORDER BY
    year_quarter;