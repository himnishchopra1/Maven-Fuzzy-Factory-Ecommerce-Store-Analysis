#Analyzing seasonality

#Business Patterns and Seasonality

SELECT  
    WEEK(created_at) AS wk,
    DATE(created_at) AS dt,
    WEEKDAY(created_at) AS wkday,
    HOUR(created_at) AS hr,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE website_session_id BETWEEN 10000 AND 115000
GROUP BY 1,2,3,4
LIMIT 5;