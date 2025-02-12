WITH MarketingPerformance AS (
    SELECT 
        marketing_channel,
        campaign_name,
        spend,
        leads_generated,
        qualified_leads,
        CAST(qualified_leads AS FLOAT) / NULLIF(leads_generated, 0) AS conversion_rate,
        campaign_date
    FROM marketing_data
)
SELECT 
    marketing_channel,
    campaign_name,
    spend,
    leads_generated,
    qualified_leads,
    conversion_rate,
    campaign_date,
    
    SUM(spend) OVER (
        PARTITION BY marketing_channel 
        ORDER BY campaign_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_spend,

    AVG(conversion_rate) OVER (
        PARTITION BY marketing_channel
    ) AS avg_conversion_rate,

    RANK() OVER (
        PARTITION BY marketing_channel 
        ORDER BY conversion_rate DESC
    ) AS campaign_rank,

    leads_generated * 1.0 / SUM(leads_generated) OVER (
        PARTITION BY marketing_channel
    ) AS lead_contribution_percentage

FROM MarketingPerformance;
