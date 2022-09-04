-- Calculate Bounce Rates
-- STEP 1: finding the first website_pageview_id for relevant sessions
use mavenfuzzyfactory;

DROP TABLE IF EXISTS first_pageviews;

CREATE TEMPORARY TABLE first_pageviews
SELECT 
    website_session_id,
    MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY website_session_id;

SELECT * FROM first_pageviews
LIMIT 5;

-- STEP 2: identifying the landing page of each session
DROP TABLE IF EXISTS session_w_landing_page_demo;

CREATE TEMPORARY TABLE session_w_landing_page_demo
SELECT
    fpd.website_session_id,
    wp.pageview_url AS landing_page
FROM first_pageviews_demo fpd
LEFT JOIN website_pageviews wp
ON wp.website_pageview_id = fpd.min_pageview_id # website pageview is the landing view
WHERE wp.pageview_url = '/home';

SELECT * FROM session_w_landing_page_demo
LIMIT 5;

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
