-- Assigns marketing spend to lead sources based on UTM tracking and calculates cost per lead
WITH marketing_data AS (
    SELECT 
        l.LeadID,
        l.LeadSource,
        m.UTM_Campaign,
        m.UTM_Source,
        m.UTM_Medium,
        COUNT(l.LeadID) AS TotalLeads,
        SUM(m.Ad_Spend) AS TotalSpend,
        SUM(CASE WHEN l.Converted = 1 THEN 1 ELSE 0 END) AS ConvertedLeads
    FROM Leads l
    JOIN MarketingSpend m ON l.UTM_Campaign = m.UTM_Campaign
    WHERE l.LeadDate BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY l.LeadSource, m.UTM_Campaign, m.UTM_Source, m.UTM_Medium
)
SELECT 
    LeadSource,
    UTM_Campaign,
    UTM_Source,
    UTM_Medium,
    TotalLeads,
    TotalSpend,
    ConvertedLeads,
    ROUND((TotalSpend / NULLIF(TotalLeads, 0)), 2) AS CostPerLead,
    ROUND((ConvertedLeads * 100.0 / NULLIF(TotalLeads, 0)), 2) AS ConversionRate
FROM marketing_data
ORDER BY ConversionRate DESC;
