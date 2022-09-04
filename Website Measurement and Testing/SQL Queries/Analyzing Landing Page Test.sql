-- Analyzing Landing Page Test

-- Step 1: find out when the new page/ lander launched
SELECT
    MIN(created_at) AS first_created_at,
    MIN(website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/lander-1'
  AND created_at IS NOT NULL;
  
-- Step 2: find the first website_pageview_id for relevant session
DROP TABLE IF EXISTS first_test_pageviews;

CREATE TEMPORARY TABLE first_test_pageviews
SELECT 
    wp.website_session_id,
    MIN(wp.website_pageview_id) AS min_pageview_id
FROM website_pageviews wp
INNER JOIN website_sessions ws 
        ON ws.website_session_id = wp.website_session_id
       AND ws.created_at < '2012-07-28' #prescribed by the assignment
       AND wp.website_pageview_id > 23504 # the min_pageview_id we found for
       AND utm_source = 'gsearch'
       AND utm_campaign = 'nonbrand'
GROUP BY wp.website_session_id;

SELECT * FROM first_test_pageviews LIMIT 5;

-- Step 3: identifying the landing page of each session
DROP TABLE IF EXISTS nonbrand_test_sessions_w_landing_page;

CREATE TEMPORARY TABLE nonbrand_test_sessions_w_landing_page
SELECT 
    ftp.website_session_id,
    wp.pageview_url AS landing_page
FROM first_test_pageviews ftp
LEFT JOIN website_pageviews wp
ON wp.website_pageview_id = ftp.min_pageview_id
WHERE wp.pageview_url IN('/home','/lander-1');

SELECT * FROM nonbrand_test_sessions_w_landing_page LIMIT 5;

-- Step 4: counting pageviews for each session, to identify "bounce"
DROP TABLE IF EXISTS nonbrand_test_bounced_sessions;

CREATE TEMPORARY TABLE nonbrand_test_bounced_sessions
SELECT 
    ntswlp.website_session_id,
    ntswlp.landing_page,
    COUNT(wp.website_pageview_id) AS pageviewed_cnt
FROM nonbrand_test_sessions_w_landing_page ntswlp
LEFT JOIN website_pageviews wp
ON ntswlp.website_session_id = wp.website_session_id
GROUP BY 1,2
HAVING COUNT(wp.website_pageview_id) = 1;

SELECT * FROM nonbrand_test_bounced_sessions LIMIT 5;

-- Step 5: summarizing total sessions and bounced sessions, by LP
SELECT 
    ntswlp.landing_page,
    ntswlp.website_session_id,
    ntbs.website_session_id AS bounced_website_session_id
FROM nonbrand_test_sessions_w_landing_page ntswlp
LEFT JOIN nonbrand_test_bounced_sessions ntbs
ON ntswlp.website_session_id = ntbs.website_session_id
ORDER BY ntswlp.website_session_id;


SELECT 
    ntswlp.landing_page,
    COUNT(DISTINCT ntswlp.website_session_id) AS sessions,
    COUNT(DISTINCT ntbs.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT ntbs.website_session_id)/COUNT(DISTINCT ntswlp.website_session_id) AS bounced_rate
FROM nonbrand_test_sessions_w_landing_page ntswlp
LEFT JOIN nonbrand_test_bounced_sessions ntbs
ON ntswlp.website_session_id = ntbs.website_session_id
GROUP BY 1;




