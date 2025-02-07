SELECT 
    SUBSTRING(GoogleClientID_Prev, 1, LEN(GoogleClientID_Prev)-3) AS GoogleClientID
FROM (
    SELECT 
        [DateOccurred],
        [ContactEmail],
        [ContactFirst],
        [ContactLast],
        [LegacyId],
        [CRMRecordID],
        SUBSTRING(
            SerializedObject, 
            CHARINDEX('GA1.2.', SerializedObject) + 6,
            CHARINDEX('/', SUBSTRING(
                SerializedObject, 
                CHARINDEX('GA1.2.', SerializedObject) + 6, 
                LEN(CAST(SerializedObject AS VARCHAR(MAX)))
            )) - 2
        ) AS GoogleClientID_Prev
    FROM dbo.ServiceLog 
    WHERE SerializedObject LIKE '%GA1.2.%'
) t;
