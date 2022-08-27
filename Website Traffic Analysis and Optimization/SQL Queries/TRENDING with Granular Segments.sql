-- TRENDING with Granular Segments
-- weekly trends of both desktop and mobile. 
-- amount of desktop sessions and mobile sessions counted from week to week
-- between april.12 and june.6
SELECT
    MIN(DATE(created_at))AS week_start_date,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN w.website_session_id ELSE NULL END)AS desktop_session,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN w.website_session_id ELSE NULL END)AS mobile_session
FROM website_sessions w
WHERE w.created_at BETWEEN '2012-04-15' AND '2012-06-09'
  AND w.utm_source = 'gsearch'
  AND w.utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(w.created_at);
