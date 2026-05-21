{{ config(
    materialized='materialized_view',
    engine='ReplacingMergeTree(processed_at)',
    order_by='(date_key, global_product_id, event_time)'
) }}

WITH raw_stream AS (
    SELECT
        toDate(gold_prices_time) AS date_key,
        gold_prices_time AS event_time,

        dictGet('silver.dict_dim_product', 'product_id', tuple('Gold', 'New York')) AS global_product_id,
        dictGet('silver.dict_dim_product', 'product_id', tuple('Vàng SJC 1L, 10L, 1KG', 'Hồ Chí Minh')) AS local_product_id,
        dictGet('silver.dict_dim_currency', 'currency_id', tuple(currency_code)) AS currency_id,

        price_foreign_oz AS global_price,
        spot_price_vnd_luong AS global_price_vnd,

        dictGetOrDefault('silver.dict_sjc', 'ask_price', toUInt64(1), 0.0) AS local_price_vnd
    FROM {{ ref('silver_gold_exchange') }}
)

SELECT
    date_key,
    event_time,
    global_product_id,
    local_product_id,
    currency_id,
    global_price,
    global_price_vnd,
    local_price_vnd,
    (local_price_vnd - global_price_vnd) AS spread_amount,
    if(global_price_vnd > 0, ((local_price_vnd - global_price_vnd) / global_price_vnd) * 100, 0) AS spread_percent,
    now64(3, 'Asia/Ho_Chi_Minh') AS processed_at
FROM raw_stream