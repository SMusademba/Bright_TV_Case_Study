-- Databricks notebook source
--- CHECKING IF TABLES UPLOADED CORRECTLY
SELECT *
FROM workspace.bright_tv.user_profiles;

SELECT *
FROM workspace.bright_tv.viewership;
-------------------------------------------------------------------------------------------------------------------------------------------------------
--- Both Tables uploaded Correctly
-------------------------------------------------------------------------------------------------------------------------------------------------------


--- CHECKING FOR NULL VALUES
SELECT *
FROM workspace.bright_tv.user_profiles
WHERE Gender IS NULL;

SELECT *
FROM workspace.bright_tv.viewership
WHERE RecordDate2 IS NULL;
-------------------------------------------------------------------------------------------------------------------------------------------------------
--- No NULL Values in individual Tables
-------------------------------------------------------------------------------------------------------------------------------------------------------


--- CHECKING TABLES LEFT JOIN CHECK
SELECT  A.UserID,
        Gender,
        Race,
        Age,
        Province,
        Channel2,
        RecordDate2,
        Duration2 AS viewing_time
FROM workspace.bright_tv.user_profiles AS A
LEFT JOIN workspace.bright_tv.viewership AS B
ON A.UserID = B.UserID;
-------------------------------------------------------------------------------------------------------------------------------------------
--- Data Uploaded Correctly 
-------------------------------------------------------------------------------------------------------------------------------------------------------


--- Checking Data range in Viewership Table
SELECT  MIN(date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'yyyy-MM-dd')) AS Start, 
        MAX(date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'yyyy-MM-dd')) AS End
FROM  workspace.bright_tv.viewership;
-------------------------------------------------------------------------------------------------------------------------------------------------------
--- 3 Months of Viewership Data 1 Jan 2016 to 31 Mar 2016 (to 1 April because of UTC Timeshift to SAST but effectively 3 months)
-------------------------------------------------------------------------------------------------------------------------------------------------------


--- Checking Shortest and Longest Viewing Time
SELECT  MIN(date_format(Duration2, 'HH:mm:ss')) AS shortest_watch,
        MAX(date_format(Duration2, 'HH:mm:ss')) AS longest_watch
FROM workspace.bright_tv.viewership;
-------------------------------------------------------------------------------------------------------------------------------------------------------        
--- Longest watch time is 11h29m29s
-------------------------------------------------------------------------------------------------------------------------------------------------------


--- Checking Age Range
SELECT  MIN(Age),
        MAX(Age)
FROM  workspace.bright_tv.user_profiles;
-------------------------------------------------------------------------------------------------------------------------------------------------------
--- Youngest viewer Ranges from few months old child to 114 year old
-------------------------------------------------------------------------------------------------------------------------------------------------------


--- Checking Province/Area, Racial Groups, Channel Options, Registered Users and Actual Viewer
SELECT  COUNT(DISTINCT LOWER(TRIM(Province))) AS Province,
        COUNT(DISTINCT LOWER(TRIM(Race))) AS ethnic_group,
        COUNT(DISTINCT Channel2) AS channels,
        COUNT(DISTINCT A.UserID) AS total_registered_users,
        COUNT(DISTINCT B.UserID) AS total_actual_viewers
FROM workspace.bright_tv.user_profiles AS A
LEFT JOIN workspace.bright_tv.viewership AS B
ON A.UserID = B.UserID
WHERE Province IS NOT NULL AND LOWER(TRIM(Province)) NOT IN ('none', '') AND Race IS NOT NULL AND LOWER(TRIM(Race)) NOT IN ('none', '')
------------------------------------------------------------------------------------------------------------------------------------------------------
------ 9 Provinces, 5 Ethnic races, 21 Channels, 4065 registered users and 3838 actual viewers
------------------------------------------------------------------------------------------------------------------------------------------------------


--- Creating Viewing Length Bands
SELECT  UserID,
        date_format(Duration2, 'HH:mm:ss') AS Watch_Time,
        CASE
                WHEN date_format(Duration2, 'HH:mm:ss') BETWEEN '00:00:00' AND '00:04:59' THEN '1. Skim'
                WHEN date_format(Duration2, 'HH:mm:ss') BETWEEN '00:05:00' AND '00:14:59' THEN '2. Short_watch'
                WHEN date_format(Duration2, 'HH:mm:ss') BETWEEN '00:15:00' AND '00:59:59' THEN '3. Regular_watch'
                WHEN date_format(Duration2, 'HH:mm:ss') BETWEEN '01:00:00' AND '02:00:00' THEN '4. Long_watch'
                ELSE 'Binge'
        END AS viewing_time 
FROM workspace.bright_tv.viewership;
------------------------------------------------------------------------------------------------------------------------------------------------------
--- Watch Time classification
------------------------------------------------------------------------------------------------------------------------------------------------------


--- Day and Month Names
SELECT  UserID,
        from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg') AS viewing_date,
        dayname(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg')) AS Day,
        dayofmonth(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg')) AS Date,
        monthname(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg')) AS Month
FROM workspace.bright_tv.viewership;
------------------------------------------------------------------------------------------------------------------------------------------------------
--- Converting Timestamp into Days and Month
------------------------------------------------------------------------------------------------------------------------------------------------------


--- Viewing time_classifications - Viewership Table 
SELECT  UserID,
        CASE
          WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '00:00:00' AND '04:59:59' THEN '1. Graveyard'
          WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '05:00:00' AND '08:59:59' THEN '2. Morning_Peak'
          WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '09:00:00' AND '11:59:59' THEN '3. Mid_Morning'
          WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '4. Afternoon'
          WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '17:00:00' AND '19:59:59' THEN '5. Evening'
          WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '20:00:00' AND '23:59:59' THEN '6. Evening_Peak'
    END AS viewing_classification 
FROM workspace.bright_tv.viewership
GROUP BY  UserID,
          CASE
            WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '00:00:00' AND '04:59:59' THEN '1. Graveyard'
            WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '05:00:00' AND '08:59:59' THEN '2. Morning_Peak'
            WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '09:00:00' AND '11:59:59' THEN '3. Mid_Morning'
            WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '4. Afternoon'
            WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '17:00:00' AND '19:59:59' THEN '5. Evening'
            WHEN date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'),'HH:mm:ss') BETWEEN '20:00:00' AND '23:59:59' THEN '6. Evening_Peak'
          END;


--- Weekend and weekday Split
SELECT  UserID,
        RecordDate2,
        CASE
          WHEN dayname(date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'), 'yyyy-MM-dd')) IN ('Sun','Sat') THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_classification
FROM workspace.bright_tv.viewership
------------------------------------------------------------------------------------------------------------------------------------------------------
--- Splitting weekend and weekday
------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT dayname(date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'), 'yyyy-MM-dd')) AS Day_classification
FROM workspace.bright_tv.viewership;


SELECT  RecordDate2,
        YEAR(date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'), 'yyyy-MM-dd')) AS year,
        MONTH(date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'), 'yyyy-MM-dd')) AS month,
        DAY(date_format(from_utc_timestamp(try_to_timestamp((RecordDate2),'dd/MM/yyyy HH:mm'),'Africa/Johannesburg'), 'yyyy-MM-dd')) AS day
FROM workspace.bright_tv.viewership;



--- Total Viewing hours
SELECT 
    Channel2,
    UserID,
    SUM(hour(try_to_timestamp(Duration2,'HH:mm:ss')) + minute(try_to_timestamp(Duration2,'HH:mm:ss'))/60.0 + second(try_to_timestamp(Duration2,'HH:mm:ss'))/3600.0) AS total_watch_time_hours,
    AVG(hour(try_to_timestamp(Duration2,'HH:mm:ss')) + minute(try_to_timestamp(Duration2,'HH:mm:ss'))/60.0 + second(try_to_timestamp(Duration2,'HH:mm:ss'))/3600.0) AS avg_watch_time_hours
FROM workspace.bright_tv.viewership
WHERE Duration2 IS NOT NULL
GROUP BY    Channel2,
            UserID
LIMIT 1000;
------------------------------------------------------------------------------------------------------------------------------------------------------
--- Adding Total view time of Subscribers and Average Watch time columns
------------------------------------------------------------------------------------------------------------------------------------------------------

