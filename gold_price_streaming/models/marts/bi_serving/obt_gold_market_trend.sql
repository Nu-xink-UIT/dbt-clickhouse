{{ config(
    materialized='view'
) }}

WITH gold_marts_base AS (
    SELECT
        event_time,
        date_key,
        global_product_id,
        local_product_id,
        global_price_vnd,
        local_price_vnd,
        spread_vnd,
        spread_percent
    FROM {{ ref('mart_gold_trend') }}
),

product_dim AS (
    SELECT
        CAST(product_id AS String) AS product_id,
        product_name,
        branch
    FROM {{ ref('dim_product') }}
)

SELECT
    f.event_time,
    f.date_key,
    f.global_product_id,
    coalesce(p_global.product_name, 'Unknown Global Product') AS global_product_name,
    f.local_product_id,
    coalesce(p_local.product_name, 'Unknown Local Product') AS local_product_name,
    coalesce(p_local.branch, 'Nationwide') AS local_branch,

    f.global_price_vnd,
    f.local_price_vnd,
    f.spread_vnd,
    f.spread_percent

FROM gold_marts_base f
LEFT JOIN product_dim p_global ON toString(f.global_product_id) = p_global.product_id
LEFT JOIN product_dim p_local ON toString(f.local_product_id) = p_local.product_id
