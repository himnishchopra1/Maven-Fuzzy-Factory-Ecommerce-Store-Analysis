-- Bid Optimization for Paid Traffic
-- Sorted the conversion rate by device type(mobile or desktop) for gsearch nonbranded advertisment campaign
SELECT w.device_type,
	COUNT(DISTINCT w.website_session_id) as sessions,
	COUNT(DISTINCT o.order_id) as orders,
	COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS device_type_conversion_rate
FROM website_sessions w LEFT JOIN orders o
	ON o.website_session_id = w.website_session_id
WHERE w.created_at<'2012-05-11'
	AND w.utm_campaign='nonbrand'
    AND w.utm_source='gsearch'
GROUP BY 1;
-- 3.7% of desktop visits convert to revenue for the company but less than 1%
-- of mobile visits convert to revenue
