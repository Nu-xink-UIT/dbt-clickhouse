{{ config(
    materialized='incremental',
    engine='ReplacingMergeTree(fetched_at)',
    order_by='(product_id, event_time)'
) }}

WITH gold_prices AS(
    SELECT * FROM {{ ref('stg_goldprice') }}

),
vcb_rates AS(
    SELECT * FROM {{ ref('stg_vcb') }}
)
joined_data AS(
    SELECT
        g.product_id,
        g.product_name,
        g.currency_code,
        g.spot_price AS price_foreign_oz,
        v.reference_price AS exchange_rate_to_vnd, -- transfer_rate of vcb
        g.event_time,
        g.fetched_at,
        g.date_key
    FROM gold_prices AS g ASOF JOIN vcb_rates AS v
    ON g.currency_code = v.currency_code
    AND g.event_time >= v.event_time -- the nearest event_time
)

SELECT
    product_id,
    product_name,
    currency_code,
    price_foreign_oz,
    price_foreign_oz * exchange_rate_to_vnd * 1.205653 AS spot_price_vnd_luong,
    exchange_rate_to_vnd,
    event_time,
    fetched_at,
    date_key,
    now64(3, 'Asis/Ho_Chi_minh') as processed_at
FROM joined_data