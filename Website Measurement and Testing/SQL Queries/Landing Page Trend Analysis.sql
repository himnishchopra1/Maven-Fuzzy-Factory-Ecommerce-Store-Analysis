-- Landing Page Trend Analysis

-- Step 1: finding the first website_pageview_id for relevant sessions
DROP TABLE IF EXISTS session_w_min_pv_id_and_view_cnt;

CREATE TEMPORARY TABLE session_w_min_pv_id_and_view_cnt
SELECT 
    ws.website_session_id,
    MIN(wp.website_pageview_id) AS first_pageview_id,
    COUNT(wp.website_pageview_id) AS pageview_cnt
    
FROM website_sessions ws
LEFT JOIN website_pageviews wp
        ON ws.website_session_id = wp.website_session_id

WHERE ws.created_at > '2012-06-01'  # asked by requestor
    AND ws.created_at < '2012-08-31' # prescribed by the assignment
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
    
GROUP BY 1;

SELECT * FROM session_w_min_pv_id_and_view_cnt LIMIT 5;

-- Step 2: identifying the landing page of each session
DROP TABLE IF EXISTS session_w_cnt_lander_and_created_at;

CREATE TEMPORARY TABLE session_w_cnt_lander_and_created_at
SELECT 
    swmpiavc.website_session_id,
    swmpiavc.first_pageview_id,
    swmpiavc.pageview_cnt,
    wp.pageview_url AS landing_page,
    wp.created_at AS session_created_at

FROM session_w_min_pv_id_and_view_cnt swmpiavc
LEFT JOIN website_pageviews wp ON swmpiavc.first_pageview_id = wp.website_pageview_id;

SELECT * FROM session_w_cnt_lander_and_created_at LIMIT 5;

-- Step 3: counting pageviews for each esssion, to identify "bounce"
SELECT 
    YEARWEEK(session_created_at) AS year_week,
    MIN(DATE(session_created_at)) AS week_start_date,
    COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN pageview_cnt = 1 THEN website_session_id ELSE NULL END)AS bounce_session,
    COUNT(DISTINCT CASE WHEN pageview_cnt = 1 THEN website_session_id ELSE NULL END)*1.0/COUNT(DISTINCT website_session_id)AS bounce_rate,
    COUNT(DISTINCT CASE WHEN landing_page = '/home' THEN website_session_id ELSE NULL END) AS home_sessions,
    COUNT(DISTINCT CASE WHEN landing_page = '/lander-1' THEN website_session_id ELSE NULL END) AS lander_sessions
FROM session_w_cnt_lander_and_created_at
GROUP BY 1;

--  Step 4: summarizing by week (bounce rate, sessions to each lander)

SELECT 
    MIN(DATE(session_created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN pageview_cnt = 1 THEN website_session_id ELSE NULL END)*1.0/COUNT(DISTINCT website_session_id)AS bounce_rate,
    COUNT(DISTINCT CASE WHEN landing_page = '/home' THEN website_session_id ELSE NULL END) AS home_sessions,
    COUNT(DISTINCT CASE WHEN landing_page = '/lander-1' THEN website_session_id ELSE NULL END) AS lander_sessions

FROM session_w_cnt_lander_and_created_at

GROUP BY YEARWEEK(session_created_at) ;

