-- Databricks notebook source
--- FINAL Query
SELECT  Channel2,
        Gender,
        COALESCE(NULLIF(TRIM(Race), ''), 'None') AS Race,
        Age,
--- Age group classifications
        CASE
                WHEN Age BETWEEN 0 AND 12 THEN '1. Children'
                WHEN Age BETWEEN 13 AND 19 THEN '2. Teen'
                WHEN Age BETWEEN 20 AND 35 THEN '3. Young Adult'
                WHEN Age BETWEEN 36 AND 64 THEN '4. Adult'
                ELSE '5. Senior'
        END AS Age_Group,
        Province,
        date_format(Duration2, 'HH:mm:ss') AS Watch_Time,


--- Creating Viewing Length Bands
        CASE
                WHEN date_format(Duration2, 'HH:mm:ss') BETWEEN '00:00:00' AND '00:04:59' THEN '1. Skim'
                WHEN date_format(Duration2, 'HH:mm:ss') BETWEEN '00:05:00' AND '00:14:59' THEN '2. Short_watch'
                WHEN date_format(Duration2, 'HH:mm:ss') BETWEEN '00:15:00' AND '00:59:59' THEN '3. Regular_watch'
                WHEN date_format(Duration2, 'HH:mm:ss') BETWEEN '01:00:00' AND '02:00:00' THEN '4. Long_watch'
                ELSE 'Binge'
        END AS watch_time_classification,


--- Total_watch time in hours and Average_watch_time in hours 
        SUM(hour(try_to_timestamp(Duration2,'HH:mm:ss')) + minute(try_to_timestamp(Duration2,'HH:mm:ss'))/60.0 + second(try_to_timestamp(Duration2,'HH:mm:ss'))/3600.0) AS total_watch_time_hours,
        AVG(hour(try_to_timestamp(Duration2,'HH:mm:ss')) + minute(try_to_timestamp(Duration2,'HH:mm:ss'))/60.0 + second(try_to_timestamp(Duration2,'HH:mm:ss'))/3600.0) AS avg_watch_time_hours,


--- Converting from  UTC to SAST
       from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg') AS viewing_date,


--- Day and Month Names
        dayname(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg')) AS Day,
        dayofmonth(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg')) AS Date,
        monthname(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg')) AS Month,
        

--- Weekday/Weekend classification
        CASE
          WHEN dayname(date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'), 'yyyy-MM-dd')) IN ('Sun','Sat') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_classification,

--- Viewing time_classifications - Viewership Table 
        CASE
                WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '00:00:00' AND '04:59:59' THEN '1. Graveyard'
                WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '05:00:00' AND '08:59:59' THEN '2. Morning_Peak'
                WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '09:00:00' AND '11:59:59' THEN '3. Mid_Morning'
                WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '4. Afternoon'
                WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '17:00:00' AND '19:59:59' THEN '5. Evening'
                WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '20:00:00' AND '23:59:59' THEN '6. Evening_Peak'
        END AS viewing_segment_classification 

FROM workspace.bright_tv.user_profiles AS A
LEFT JOIN workspace.bright_tv.viewership AS B
ON A.UserID = B.UserID
WHERE from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg') IS NOT NULL AND Duration2 IS NOT NULL
GROUP BY        Channel2,
        Gender,
        COALESCE(NULLIF(TRIM(Race), ''), 'None'),
        Age,
        Province,
        Duration2,

--- Converting from  UTC to SAST
       from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),


--- Day and Month Names
        dayname(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg')),
        dayofmonth(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg')),
        monthname(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg')),

--- Age group classifications
        CASE
                WHEN Age BETWEEN 0 AND 12 THEN '1. Children'
                WHEN Age BETWEEN 13 AND 19 THEN '2. Teen'
                WHEN Age BETWEEN 20 AND 35 THEN '3. Young Adult'
                WHEN Age BETWEEN 36 AND 64 THEN '4. Adult'
                ELSE '5. Senior'
        END,

--- Weekday/Weekend classification
        CASE
                WHEN dayname(date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'), 'yyyy-MM-dd')) IN ('Sun','Sat') THEN 'Weekend'
                ELSE 'Weekday'
        END,

--- Viewing time_classifications - Viewership Table 
        CASE
                WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '00:00:00' AND '04:59:59' THEN '1. Graveyard'
                WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '05:00:00' AND '08:59:59' THEN '2. Morning_Peak'
                WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '09:00:00' AND '11:59:59' THEN '3. Mid_Morning'
                WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '4. Afternoon'
                WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '17:00:00' AND '19:59:59' THEN '5. Evening'
                WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '20:00:00' AND '23:59:59' THEN '6. Evening_Peak'
        END, 

--- Creating Viewing Length Bands
        CASE
                WHEN date_format(Duration2, 'HH:mm:ss') BETWEEN '00:00:00' AND '00:04:59' THEN '1. Skim'
                WHEN date_format(Duration2, 'HH:mm:ss') BETWEEN '00:05:00' AND '00:14:59' THEN '2. Short_watch'
                WHEN date_format(Duration2, 'HH:mm:ss') BETWEEN '00:15:00' AND '00:59:59' THEN '3. Regular_watch'
                WHEN date_format(Duration2, 'HH:mm:ss') BETWEEN '01:00:00' AND '02:00:00' THEN '4. Long_watch'
                ELSE 'Binge'
        END;
