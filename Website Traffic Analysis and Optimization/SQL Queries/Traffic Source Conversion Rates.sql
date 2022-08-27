-- Traffic Source Conversion Rates
-- Determining the session to order conversion rate for gsearch utm source
-- to assess how effective it is at creating orders before April.12
SELECT
    COUNT(DISTINCT w.website_session_id)AS sessions,
    COUNT(DISTINCT o.order_id)AS orders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS sessions_to_order_conversion_rate
FROM website_sessions w LEFT JOIN orders o
ON o.website_session_id = w.website_session_id
WHERE w.created_at < '2012-04-14'
  AND utm_source = 'gsearch'
  AND utm_campaign = 'nonbrand';


