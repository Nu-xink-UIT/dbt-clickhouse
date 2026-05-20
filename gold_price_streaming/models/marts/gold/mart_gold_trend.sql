{{ config(
    materialized='view'
) }}

SELECT
    event_time,
    date_key,
    global_product_id,
    local_product_id,

    -- Hai đường giá chính để vẽ Line Chart
    global_price_vnd,
    local_price_vnd,

    -- Hai cột này dùng để vẽ Fill Area (vùng mờ) hoặc Secondary Axis thể hiện độ chênh lệch
    spread_amount AS spread_vnd,
    spread_percent

FROM {{ ref('fact_gold_price') }}
-- Có thể thêm bộ lọc (VD: event_time >= now() - INTERVAL 30 DAY)
-- để View mặc định luôn load nhanh nếu dữ liệu phình to.