{{ config(
    materialized='materialized_view',
    engine='ReplacingMergeTree(gold_prices_time)',
    order_by='(product_id, gold_prices_time)'
) }}
-- just streaming so materialized view
-- incremental for batching
SELECT
    product_id,
    product_name,
    currency_code,
    dictGet('silver.dict_vcb_rates', 'reference_price', tuple(currency_code)) AS exchange_rate_to_vnd,
    dictGet('silver.dict_vcb_rates', 'event_time', tuple(currency_code)) AS exchange_rate_time,
    spot_price AS price_foreign_oz,
    event_time AS gold_prices_time,
    price_foreign_oz * exchange_rate_to_vnd * 1.205653 AS spot_price_vnd_luong,
    date_key,
    now64(3, 'Asia/Ho_Chi_Minh') as processed_at
FROM {{ source('staging', 'stg_goldprice')}}


-- WITH gold_prices AS(
--     SELECT * FROM {{ source('staging','stg_goldprice') }}

-- ),
-- vcb_rates AS(
--     SELECT * FROM {{ source('staging','stg_vcb') }}
-- ),
-- joined_data AS(
--     SELECT
--         g.product_id,
--         g.product_name,
--         g.currency_code,
--         g.spot_price AS price_foreign_oz,
--         v.reference_price AS exchange_rate_to_vnd, -- transfer_rate of vcb
--         g.event_time AS gold_prices_time,
--         v.event_time AS exchange_rate_time,
--         g.date_key
--     FROM gold_prices AS g ASOF LEFT JOIN vcb_rates AS v
--     ON g.currency_code = v.currency_code
--     AND g.event_time >= v.event_time -- the nearest event_time
-- )


-- SELECT
--     product_id,
--     product_name,
--     currency_code,
--     price_foreign_oz,
--     price_foreign_oz * exchange_rate_to_vnd * 1.205653 AS spot_price_vnd_luong,
--     exchange_rate_to_vnd,
--     gold_prices_time,
--     exchange_rate_time,
--     date_key,
--     now64(3, 'Asia/Ho_Chi_Minh') as processed_at
-- FROM joined_data

