-- Traffic Source Trending
-- Getting the session volume for the gsearch nonbranded advertisment campaign
-- week by week before may.10
SELECT 
	MIN(DATE(created_at)) as week_start_date,
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions
FROM website_sessions
WHERE utm_source='gsearch' 
	AND utm_campaign='nonbrand'
    AND created_at<'2012-05-10'
GROUP BY YEAR(created_at),WEEK(created_at);
