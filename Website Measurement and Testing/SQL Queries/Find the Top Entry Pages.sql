USE mavenfuzzyfactory;

-- Find the Top Entry Pages
-- STEP1: find the first pageview for each session
CREATE TEMPORARY TABLE first_pageviews
SELECT 
    website_session_id,
    MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY website_session_id;


-- STEP2: find the url the customer saw on that first pageview
SELECT 
    w.pageview_url AS landing_page,
    COUNT(f.website_session_id) AS sessions_hit_landing_page
FROM first_pageviews f
LEFT JOIN website_pageviews w ON w.website_pageview_id = f.min_pageview_id 
GROUP BY w.pageview_url;

