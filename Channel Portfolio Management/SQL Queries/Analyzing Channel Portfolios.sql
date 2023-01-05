#Analyzing Channel Portfolios
#Task: Identify traffic coming from multiple marketing channels

SELECT 
    utm_content,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT ws.website_session_id) AS conv_rt
FROM website_sessions ws
LEFT JOIN orders o
ON o.website_session_id = ws.website_session_id
WHERE ws.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY 1
ORDER BY 2 DESC; # most orders


SELECT
    YEARWEEK(created_at) AS year_week,
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS gsearch_session,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS bsearch_session
FROM website_sessions
WHERE created_at > '2012-08-22'
  AND created_at < '2012-11-29'
  AND utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(created_at);
