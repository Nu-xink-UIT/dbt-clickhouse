{{ config(
    materialized='table',
    engine='MergeTree()',
    order_by='date_key'
) }}

WITH date_range AS(
    -- create date from 01.01.2026 to 31.12.2030
    SELECT
        toDate('2026-01-01') + number AS date_key
    FROM numbers(1827) -- 5 years
)
SELECT
    date_key,
    toDayOfWeek(date_key) AS day_of_week,
    formatDateTime(date_key, '%W') AS day_name,
    toDayOfMonth(date_key) AS day_of_month,
    toMonth(date_key) AS month,
    formatDateTime(date_key, '%M') AS month_name,
    toQuarter(date_key) AS quarter,
    toYear(date_key) AS year,
    if(toDayOfWeek(date_key) AS day_of_week IN (6,7), 1, 0) AS is_weekend,
    if(formatDateTime(date_key, '%m-%d') IN ('01-01', '04-30', '05-01', '09-02'), 1, 0) AS is_holiday -- không lấy được ngày âm

FROM date_range

