--Q. WHAT IS THE NUMBER OF CURRENT YEAR CASUALTIES?
SELECT 
    SUM(number_of_casualties) AS "Current Year Casualties"
FROM mydata
WHERE EXTRACT(YEAR FROM accident_date) = 2022;

--Q. WHAT IS THE NUMBER OF CURRENT YEAR ACCIDENTS?
SELECT 
    COUNT(DISTINCT accident_index) AS "Current Year Accidents"
FROM mydata
WHERE accident_date >= DATE '2022-01-01'
  AND accident_date <  DATE '2023-01-01';

--Q. WHAT IS THE NUMBER OF CASUALTIES THAT RESULTED IN FATALITY
SELECT 
    SUM(number_of_casualties) AS "Fatal Casualties"
FROM mydata
WHERE accident_severity = 'Fatal';
--Q. WHAT IS THE NUMBER OF CASUALTIES THAT WERE SERIOUS 
SELECT 
    SUM(number_of_casualties) AS "Serious Casualties"
FROM mydata
WHERE accident_severity = 'Serious';
--Q. WHAT IS THE HUMBER OF CASUALTIES THAT WERE ONLY SLIGHTLY SERIOUS
SELECT 
    SUM(number_of_casualties) AS "Slight Casualties"
FROM mydata
WHERE accident_severity = 'Slight';
-- PERCENTAGE OF ALL CASUALTIES 
SELECT 
    accident_severity,
    SUM(number_of_casualties) AS total_casualties,
    ROUND(
        (SUM(number_of_casualties) * 100.0) / 
        (SELECT SUM(number_of_casualties) FROM mydata),
        2
    ) AS casualty_percentage
FROM mydata
GROUP BY accident_severity
ORDER BY casualty_percentage DESC;
-- TOTAL CASUALTIES BY VEHICLE TYPE
SELECT
    CASE
        WHEN vehicle_type ILIKE '%Motorcycle%' 
             OR vehicle_type ILIKE '%Pedal%' THEN 'Bike'
        WHEN vehicle_type ILIKE '%Bus%' 
             OR vehicle_type ILIKE '%coach%' THEN 'Bus'
        WHEN vehicle_type ILIKE '%Goods%' 
             OR vehicle_type ILIKE '%Van%' THEN 'Goods'
        WHEN vehicle_type ILIKE '%Agricultural%' THEN 'Agricultural'
        WHEN vehicle_type ILIKE '%Ridden horse%' 
             OR vehicle_type ILIKE '%Other%' THEN 'Other'
        ELSE 'Other'
    END AS vehicle_category,
    SUM(number_of_casualties) AS total_casualties
FROM mydata
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY vehicle_category
ORDER BY total_casualties DESC;
--MONTHLY TREND OF CY AND PY CASUALTIES
WITH year_bounds AS (
    SELECT MAX(EXTRACT(YEAR FROM accident_date)) AS current_year
    FROM mydata
)
SELECT
    EXTRACT(YEAR FROM accident_date) AS year,
    EXTRACT(MONTH FROM accident_date) AS month,
    SUM(number_of_casualties) AS total_casualties
FROM mydata
WHERE EXTRACT(YEAR FROM accident_date) IN (
    (SELECT current_year FROM year_bounds),
    (SELECT current_year - 1 FROM year_bounds)
)
GROUP BY year, month
ORDER BY year, month;
--CY CASUALTIES BY ROAD TYPE
SELECT
    road_type,
    SUM(number_of_casualties) AS total_casualties
FROM mydata
WHERE EXTRACT(YEAR FROM accident_date) = 2021
GROUP BY road_type
ORDER BY total_casualties DESC;
--CASULATIES BY URBAN AND RURAL 
SELECT
    urban_or_rural_area,
    SUM(number_of_casualties) AS total_casualties
FROM mydata
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY urban_or_rural_area;
-- PERCENTAGE CASUALTIES URBAN OR RURAL
SELECT
    urban_or_rural_area,
    SUM(number_of_casualties) AS total_casualties,
    ROUND(
        (SUM(number_of_casualties) * 100.0) /
        (SELECT SUM(number_of_casualties)
         FROM mydata
         WHERE EXTRACT(YEAR FROM accident_date) = 2022),
        2
    ) AS casualty_percentage
FROM mydata
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY urban_or_rural_area
ORDER BY casualty_percentage DESC;
--TOTAL CASUALTIES BY LIGHT CONDITIONS
SELECT
    CASE
        WHEN light_conditions ILIKE '%Daylight%' THEN 'Light'
        ELSE 'Dark'
    END AS light_type,
    SUM(number_of_casualties) AS total_casualties,
    ROUND(
        (SUM(number_of_casualties) * 100.0) /
        (SELECT SUM(number_of_casualties)
         FROM mydata
         WHERE EXTRACT(YEAR FROM accident_date) = 2022),
        2
    ) AS casualty_percentage
FROM mydata
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY light_type
ORDER BY casualty_percentage DESC;
--total casualties by weather conditions
SELECT
    CASE
        WHEN weather_conditions ILIKE '%Fine%' THEN 'Fine'
        WHEN weather_conditions ILIKE '%Rain%' THEN 'Rainy'
        WHEN weather_conditions ILIKE '%Snow%' THEN 'Snowy'
        WHEN weather_conditions ILIKE '%Fog%' 
             OR weather_conditions ILIKE '%Mist%' THEN 'Fog'
        ELSE 'Other'
    END AS weather_group,
    SUM(number_of_casualties) AS total_casualties
FROM mydata
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY weather_group
ORDER BY total_casualties DESC;













