-- Find the Top Traffic Sources
-- Determining the source, campaign,and http link of visitors of the website and which source
-- genrated the most amount of vistors before April.12 
SELECT 
	utm_source,
	utm_campaign,
	http_referer, 
	COUNT(DISTINCT website_session_id) AS sessions_count
FROM website_sessions
WHERE created_at <'2012-04-12'
GROUP BY utm_source,
		utm_campaign,
        http_referer
ORDER BY sessions_count DESC;


