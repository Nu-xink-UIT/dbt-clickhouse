{{ config(
    materialized='view'
) }}

WITH gold_marts_base AS (
    SELECT * FROM {{ ref('mart_gold_trend') }}
),

-- Gọi trực tiếp bảng tĩnh dim_product ở lớp silver làm nguồn map tên và chi nhánh chuẩn xác
product_dim AS (
    SELECT
        CAST(product_id AS String) AS product_id,
        product_name,
        branch
    FROM silver.dim_product
)

SELECT
    -- 1. Thời gian
    f.event_time,
    f.date_key,

    -- 2. Thông tin Vàng Thế Giới (Global)
    f.global_product_id,
    coalesce(p_global.product_name, 'Unknown Global Product') AS global_product_name,

    -- 3. Thông tin Vàng Trong Nước (Local - SJC)
    f.local_product_id,
    coalesce(p_local.product_name, 'Unknown Local Product') AS local_product_name,
    coalesce(p_local.branch, 'Nationwide') AS local_branch,

    -- 4. Các Metrics (Chỉ số)
    f.global_price_vnd,
    f.local_price_vnd,
    f.spread_vnd,
    f.spread_percent

FROM gold_marts_base f
-- Map thông tin bằng LEFT JOIN với bảng dim gốc để tránh lỗi Dictionary cache của ClickHouse
LEFT JOIN product_dim p_global ON toString(f.global_product_id) = p_global.product_id
LEFT JOIN product_dim p_local ON toString(f.local_product_id) = p_local.product_id