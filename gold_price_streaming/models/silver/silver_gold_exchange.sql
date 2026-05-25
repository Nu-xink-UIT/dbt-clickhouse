{{ config(
    materialized='materialized_view',
    engine='ReplacingMergeTree(gold_prices_time)',
    order_by='(product_id, gold_prices_time)'
) }}

WITH gold_prices AS (
    SELECT
        product_id,
        product_name,
        currency_code,
        CASE
            WHEN currency_code = 'CNY' AND spot_price < 10000
                THEN (spot_price * 31.10347 * 2)
            WHEN currency_code = 'CNY' AND spot_price >= 10000
                THEN spot_price

            ELSE spot_price
        END AS price_foreign_oz,

        event_time,
        date_key
    FROM {{ ref('stg_goldprice') }}
),

filtered_vcb_rates AS (
    SELECT
        currency_code,
        reference_price,
        max_event_time
    FROM {{ ref('dim_vcb_rates') }}
)

SELECT
    g.product_id,
    g.product_name,
    g.currency_code,
    v.reference_price AS exchange_rate_to_vnd,
    v.max_event_time AS exchange_rate_time,

    g.price_foreign_oz,
    g.event_time AS gold_prices_time,

    (g.price_foreign_oz * v.reference_price * 1.205653) AS spot_price_vnd_luong,
    g.date_key,
    now64(3, 'Asia/Ho_Chi_Minh') as processed_at

FROM gold_prices AS g
LEFT JOIN filtered_vcb_rates AS v
  ON g.currency_code = v.currency_code