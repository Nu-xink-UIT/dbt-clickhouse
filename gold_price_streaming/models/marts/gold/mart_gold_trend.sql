{{ config(
    materialized='view'
) }}

SELECT
    event_time,
    date_key,
    currency_id,
    global_product_id,
    local_product_id,
    global_price_vnd,
    local_price_vnd,
    spread_amount AS spread_vnd,
    spread_percent

FROM {{ ref('fact_gold_price') }}
