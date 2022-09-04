-- Analyzing Bounce Rates & Landing Page Tests
-- STEP 1: finding the first website_pageview_id for relevant sessions

DROP TABLE IF EXISTS first_pageviews_demo;

CREATE TEMPORARY TABLE first_pageviews_demo
SELECT
    wp.website_session_id,
    MIN(wp.website_pageview_id)AS min_pageview_id
FROM website_pageviews wp
INNER JOIN website_sessions ws 
ON ws.website_session_id = wp.website_session_id
AND ws.created_at BETWEEN'2014-01-01' AND '2014-02-01'
GROUP BY wp.website_session_id;

-- STEP 2: identifying the landing page of each session
DROP TABLE IF EXISTS session_w_landing_page_demo;

CREATE TEMPORARY TABLE session_w_landing_page_demo
SELECT
    fpd.website_session_id,
    wp.pageview_url AS landing_page
FROM first_pageviews_demo fpd
LEFT JOIN website_pageviews wp
ON wp.website_pageview_id = fpd.min_pageview_id; # website pageview is the landing view

-- STEP 3: counting pageviews for each session, to identify "bounces"
DROP TABLE IF EXISTS bounced_session_only;

CREATE TEMPORARY TABLE bounced_session_only
SELECT
    swlpd.website_session_id,
    swlpd.landing_page,
    COUNT(wp.website_pageview_id)AS pageviews_cnt
    
FROM session_w_landing_page_demo swlpd
LEFT JOIN website_pageviews wp
ON wp.website_session_id = swlpd.website_session_id
GROUP BY 1,2
HAVING COUNT(wp.website_pageview_id) = 1;

SELECT * FROM bounced_session_only
LIMIT 5;

-- Step 4: summarizing by counting total sessions and bounced sessions, by LP
SELECT 
    swlpd.landing_page,
    COUNT(DISTINCT swlpd.website_session_id)AS sessions,
    COUNT(DISTINCT bso.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bso.website_session_id)/COUNT(DISTINCT swlpd.website_session_id)AS bounced_rate
FROM session_w_landing_page_demo swlpd
LEFT JOIN bounced_session_only bso
ON swlpd.website_session_id = bso.website_session_id
GROUP BY 1;

-- Step 4: summarizing by counting total sessions and bounced sessions, by LP
SELECT 
    swlpd.landing_page,
    COUNT(DISTINCT swlpd.website_session_id)AS sessions,
    COUNT(DISTINCT bso.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bso.website_session_id)/COUNT(DISTINCT swlpd.website_session_id)AS bounced_rate
FROM session_w_landing_page_demo swlpd
LEFT JOIN bounced_session_only bso
ON swlpd.website_session_id = bso.website_session_id
GROUP BY 1;










