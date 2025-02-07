DECLARE @DateStart date = '2022-01-01'

SELECT *,
    DATEDIFF(day, maxend, actualclosedate) AS Apt_Diff 
FROM 
(
    SELECT * 
    FROM 
    (
        SELECT DISTINCT leadid, qualifyingopportunityid
        FROM [dbo].[lead]
        WHERE [ssi_firstcontactdate] >= @DateStart
    ) l1

    FULL OUTER JOIN 
    (
        --********** APPOINTMENTS **********
        SELECT [regardingobjectid], 
            COUNT([activityid]) AS apt_num,
            SUM(CAST([ssi_iscompleteactivity] AS FLOAT)) AS apt_cmp_num,
            SUM(CAST([ssi_iscompleteactivity] AS FLOAT)) / COUNT([activityid]) AS apt_ratio,
            SUM([actualdurationminutes]) AS apt_duration,
            MAX([actualend]) AS maxend,
            MAX([scheduledend]) AS maxschedend,
            MIN([scheduledend]) AS minschedend,
            COUNT(DISTINCT [ownerid]) AS own_apt_num,
            COUNT(DISTINCT [ssi_AssignedCommunityId]) AS u_comm_apt_num,
            COUNT(CASE [ssi_lspoppro] WHEN 867568208 THEN 1 ELSE NULL END) AS IPP_num,
            COUNT(CASE [ssi_lspoppro] WHEN 867568209 THEN 1 ELSE NULL END) AS SVPP_num,
            COUNT(CASE [ssi_lspoppro] WHEN 100000000 THEN 1 ELSE NULL END) AS VSPP_num,
            COUNT(CASE [ssi_lspoppro] WHEN 100000001 THEN 1 ELSE NULL END) AS AL_PPP_num,
            MAX([ssi_iscompleteactivity]) AS ssi_iscompleteactivity,
            MAX([ssi_salescalloutcome]) AS ssi_salescalloutcome,
            MAX([prioritycode]) AS prioritycode
        FROM [dbo].[appointment]
        WHERE ([actualend] >= @DateStart OR [scheduledend] >= @DateStart OR [createdon] >= @DateStart)
        GROUP BY [regardingobjectid]
        ORDER BY COUNT(DISTINCT [ownerid]) DESC, COUNT(DISTINCT [ssi_AssignedCommunityId]) DESC, [regardingobjectid]
    ) ap
    ON l1.qualifyingopportunityid = ap.[regardingobjectid]

    --********** EMAILS **********
    LEFT JOIN 
    (
        SELECT [regardingobjectid], 
            COUNT([activityid]) AS eml_num,
            SUM(CAST([ssi_iscompleteactivity] AS FLOAT)) AS eml_cmp_num,
            SUM(CAST([ssi_iscompleteactivity] AS FLOAT)) / COUNT([activityid]) AS eml_ratio,
            SUM([actualdurationminutes]) AS eml_duration,
            MAX([actualend]) AS maxend,
            MAX([scheduledend]) AS maxschedend,
            MIN([scheduledend]) AS minschedend,
            COUNT(DISTINCT [ownerid]) AS own_eml_num,
            COUNT(DISTINCT [ssi_AssignedCommunityId]) AS u_comm_eml_num,
            MAX([ssi_iscompleteactivity]) AS ssi_iscompleteactivity,
            MAX([ssi_salescalloutcome]) AS ssi_salescalloutcome,
            MAX([prioritycode]) AS prioritycode
        FROM [dbo].[email]
        WHERE ([actualend] >= @DateStart OR [scheduledend] >= @DateStart OR [createdon] >= @DateStart)
        GROUP BY [regardingobjectid]
    ) em
    ON l1.qualifyingopportunityid = em.[regardingobjectid]

    LEFT JOIN 
    (
        SELECT statcodename, statuscodename, ISNULL(actualclosedate, GETDATE()) AS actualclosedate, opportunityid 
        FROM [dbo].[vwOpportunity] vwo
    ) wvo
    ON l1.qualifyingopportunityid = wvo.opportunityid
) final
