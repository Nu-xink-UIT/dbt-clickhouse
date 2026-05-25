{{ config(
    materialized='materialized_view',
    engine='ReplacingMergeTree(processed_at)',
    order_by='(date_key, global_product_id, event_time)'
) }}

WITH raw_stream AS (
    SELECT
        toDate(g.gold_prices_time) AS date_key,
        g.gold_prices_time AS event_time,

        24 AS global_product_id,
        5 AS local_product_id,

        c.currency_id AS currency_id,

        g.price_foreign_oz AS global_price,
        g.spot_price_vnd_luong AS global_price_vnd
    FROM {{ ref('silver_gold_exchange') }} AS g
    LEFT JOIN {{ ref('dim_currency') }} AS c
      ON g.currency_code = c.currency_code
    WHERE g.currency_code != 'VND' 
),

local_sjc_price AS (
    SELECT ask_price
    FROM {{ ref('dim_sjc') }}
    LIMIT 1
)

SELECT
    s.date_key,
    s.event_time,
    s.global_product_id,
    s.local_product_id,
    s.currency_id,
    s.global_price,
    s.global_price_vnd,

    coalesce((SELECT ask_price FROM local_sjc_price), 0.0) AS local_price_vnd,

    if(s.global_price_vnd > 0, local_price_vnd - s.global_price_vnd, NULL) AS spread_amount,
    if(s.global_price_vnd > 0, ((local_price_vnd - s.global_price_vnd) / s.global_price_vnd) * 100, 0) AS spread_percent,

    now64(3, 'Asia/Ho_Chi_Minh') AS processed_at
FROM raw_stream AS s