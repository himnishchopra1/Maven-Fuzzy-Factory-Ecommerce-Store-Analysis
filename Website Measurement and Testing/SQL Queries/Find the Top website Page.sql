USE mavenfuzzyfactory;

-- Find the Top website Page
-- STEP1: find the first pageview for each session
SELECT 
    pageview_url,
    COUNT(DISTINCT website_session_id)AS sessions
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY pageview_url
ORDER BY sessions DESC;

-- STEP2: find the url the customer saw on that first pageview
SELECT 
    w.pageview_url AS landing_page,
    COUNT(f.website_session_id) AS sessions_hit_landing_page
FROM first_pageviews f
LEFT JOIN website_pageviews w ON w.website_pageview_id = f.min_pageview_id 
GROUP BY w.pageview_url;


