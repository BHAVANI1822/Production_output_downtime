CREATE TABLE production_downtime (
    machine_id VARCHAR(50),
    operation_mode VARCHAR(50),
    fault_type VARCHAR(50),
    temperature_c NUMERIC,
    vibration_mm_s NUMERIC,
    pressure_bar NUMERIC,
    humidity_pct NUMERIC,
    energy_consumption_kwh NUMERIC,
    machine_speed_rpm NUMERIC,
    downtime_minutes NUMERIC,
    throughput_units_hr NUMERIC,
    product_quality_score NUMERIC,
    reject_rate_pct NUMERIC,
    target_class VARCHAR(50)
);

SELECT * FROM production_downtime;

SELECT COUNT(*)
FROM production_downtime;

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT ("machine_id", "operation_mode",
                       "fault_type", "temperature_c",
                       "vibration_mm_s", "pressure_bar",
                       "humidity_pct", "energy_consumption_kwh",
                       "machine_speed_rpm", "downtime_minutes",
                       "throughput_units_hr",
                       "product_quality_score",
                       "reject_rate_pct", "target_class"))
       AS unique_rows
FROM production_downtime;


SELECT
    COUNT(*) AS duplicate_groups,
    SUM(row_count - 1) AS extra_rows
FROM (
    SELECT COUNT(*) AS row_count
    FROM production_downtime
    GROUP BY
        "machine_id", 
		"operation_mode",
        "fault_type",
		"temperature_c",
        "vibration_mm_s", 
		"pressure_bar",
                      "humidity_pct", "energy_consumption_kwh",
                       "machine_speed_rpm", "downtime_minutes",
                       "throughput_units_hr",
                       "product_quality_score",
                       "reject_rate_pct", "target_class"
    HAVING COUNT(*) > 1
) AS duplicates;


CREATE TABLE production_downtime_clean AS
SELECT DISTINCT *
FROM ;




SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT ("machine_id", "operation_mode",
                       "fault_type", "temperature_c",
                       "vibration_mm_s", "pressure_bar",
                       "humidity_pct", "energy_consumption_kwh",
                       "machine_speed_rpm", "downtime_minutes",
                       "throughput_units_hr",
                       "product_quality_score",
                       "reject_rate_pct", "target_class"))
       AS unique_rows
FROM production_downtime;


SELECT
    COUNT(*) AS duplicate_groups,
    SUM(row_count - 1) AS extra_rows
FROM (
    SELECT COUNT(*) AS row_count
    FROM production_downtime
    GROUP BY
        "machine_id", 
		"operation_mode",
        "fault_type",
		"temperature_c",
        "vibration_mm_s", 
		"pressure_bar",
                      "humidity_pct", "energy_consumption_kwh",
                       "machine_speed_rpm", "downtime_minutes",
                       "throughput_units_hr",
                       "product_quality_score",
                       "reject_rate_pct", "target_class"
    HAVING COUNT(*) > 1
) AS duplicates;


CREATE TABLE production_downtime_clean AS
SELECT DISTINCT *
FROM production_downtime;


SELECT COUNT(*) AS cleaned_rows
FROM production_downtime_clean;


SELECT COUNT(*) AS unique_rows
FROM (
    SELECT DISTINCT *
    FROM production_downtime_clean
) AS unique_data;




SELECT
    COUNT(*) FILTER (WHERE "machine_id" IS NULL) AS missing_machine_id,
    COUNT(*) FILTER (WHERE "fault_type" IS NULL) AS missing_fault_type,
    COUNT(*) FILTER (WHERE "downtime_minutes" IS NULL) AS missing_downtime,
    COUNT(*) FILTER (WHERE "energy_consumption_kwh" IS NULL) AS missing_energy,
    COUNT(*) FILTER (WHERE "operation_mode" IS NULL) AS missing_operation_mode
FROM production_downtime_clean;



SELECT *
FROM production_downtime_clean
WHERE "downtime_minutes" < 0
   OR "downtime_minutes" IS NULL;

select * from production_downtime_clean;

#machine with the highest total downtime
==========================================

SELECT
    "machine_id",
    SUM("downtime_minutes") AS total_downtime_minutes,
    ROUND(SUM("downtime_minutes") / 60.0, 2)
        AS total_downtime_hours,
    ROUND(AVG("downtime_minutes"), 2)
        AS average_downtime_minutes
FROM production_downtime_clean
GROUP BY "machine_id"
ORDER BY total_downtime_minutes DESC;




Overall production downtime
===========================

SELECT
    SUM(downtime_minutes) AS total_downtime_minutes,
    ROUND(SUM(downtime_minutes) / 60.0, 2)
        AS total_downtime_hours,
    ROUND(AVG(downtime_minutes), 2)
        AS average_downtime_minutes
FROM production_downtime_clean;



Downtime by fault type
=======================

SELECT
    fault_type,
    COUNT(*) AS fault_records,
    ROUND(SUM(downtime_minutes), 2)
        AS total_downtime_minutes,
    ROUND(SUM(downtime_minutes) / 60.0, 2)
        AS total_downtime_hours
FROM production_downtime_clean
GROUP BY fault_type
ORDER BY total_downtime_minutes DESC;



Downtime by operation mode
===========================
SELECT
    operation_mode,
    COUNT(*) AS total_records,
    ROUND(SUM(downtime_minutes), 2)
        AS total_downtime_minutes,
    ROUND(AVG(downtime_minutes), 2)
        AS average_downtime_minutes
FROM production_downtime_clean
GROUP BY operation_mode
ORDER BY total_downtime_minutes DESC;
Downtime by target classSELECT
    target_class,
    COUNT(*) AS total_records,
    ROUND(SUM(downtime_minutes), 2)
        AS total_downtime_minutes,
    ROUND(AVG(downtime_minutes), 2)
        AS average_downtime_minutes
FROM production_downtime_clean
GROUP BY target_class
ORDER BY total_downtime_minutes DESC;


==Production throughput by machine
================================

SELECT machine_id,
    ROUND(AVG(throughput_units_hr), 2)
        AS avg_throughput_units_hr,
    ROUND(AVG(downtime_minutes), 2)
        AS avg_downtime_minutes,
    ROUND(AVG(reject_rate_pct), 2)
        AS avg_reject_rate_pct
FROM production_downtime_clean
GROUP BY machine_id
ORDER BY avg_downtime_minutes DESC;



