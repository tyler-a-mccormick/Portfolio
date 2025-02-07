DECLARE @start_dt AS DATE = '1/1/2019';
DECLARE @end_dt AS DATE = '12/31/2099';

DECLARE @dates AS TABLE (
    date_id DATE PRIMARY KEY,
    date_year SMALLINT,
    date_month TINYINT,
    date_day TINYINT,
    weekday_id TINYINT,
    weekday_nm VARCHAR(10),
    day_of_year SMALLINT,
    quarter_id TINYINT,
    first_day_of_month DATE,
    last_day_of_month DATE,
    start_dt AS DATE
);

-- Loop through dates and populate the table
WHILE @start_dt < @end_dt
BEGIN
    INSERT INTO @dates (
        date_id, date_year, date_month, date_day, 
        weekday_id, weekday_nm, day_of_year, quarter_id,
        first_day_of_month, last_day_of_month, start_dt
    )
    VALUES (
        @start_dt, 
        YEAR(@start_dt), MONTH(@start_dt), DAY(@start_dt),
        DATEPART(WEEKDAY, @start_dt), DATENAME(WEEKDAY, @start_dt),
        DATEPART(DAYOFYEAR, @start_dt), DATEPART(QUARTER, @start_dt),
        DATEADD(DAY, - (DAY(@start_dt) - 1), @start_dt),
        DATEADD(SECOND, -1, CAST(DATEADD(DAY, 1, DATEADD(DAY, - (DAY(DATEADD(MONTH, 1, @start_dt)) - 1), DATEADD(MONTH, 1, @start_dt))) AS DATETIME)),
        @start_dt
    );

    -- Move to the next date
    SET @start_dt = DATEADD(DAY, 1, @start_dt);
END

-- Store data into a permanent table
INSERT INTO [_ds].[Calendar]
SELECT * FROM @dates;
