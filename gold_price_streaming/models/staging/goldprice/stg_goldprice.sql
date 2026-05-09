{{ config(
    materialized='materialized_view',
    engine='ReplacingMergeTree(fetched_at)',
    order_by='(product_id, currency_code)',
    settings={'allow_nullable_key': 1}
) }}

WITH raw_goldprice AS(
    SELECT * FROM {{ source('raw_data', 'goldprice_raw') }}
),
unfold AS(
    SELECT
        toDateTime64(fetched_at, 3, 'Asia/Ho_Chi_Minh') AS fetched_at,
        toDateTime64(ts / 1000, 3, 'Asia/Ho_Chi_Minh') AS event_time,
        -- parseDateTimeBestEffort(
        --              replaceRegexpOne(date, '(\d+)(st|nd|rd|th)|, | NY', '\\1'),
        --              'Asia/Ho_Chi_Minh') AS event_time_ny,
        curr AS currency_code,

        arrayJoin([
            ('XAU', 'Gold', xauPrice , xauClose, chgXau, pcXau),
            ('XAG', 'Silver', xagPrice, xagClose, chgXag, pcXag)
        ]) AS product_data

    FROM raw_goldprice
),
normalized AS(
    SELECT
        product_data.1  AS product_id,
        product_data.2  AS product_name,
        CAST(product_data.3 AS Float64) AS spot_price,
        CAST(product_data.4 AS Float64) AS reference_price, -- Giá đóng cửa của phiên trước. Đây chính là "mốc" để tính toán biến động.
        CAST(product_data.5 AS Float64) AS change_sell_abs,
        CAST(product_data.6 AS Float64) AS change_sell_pct,
        currency_code,
        fetched_at,
        event_time,
        -- event_time_ny,
        toDate(event_time) AS date_key,
        now64(3, 'Asia/Ho_Chi_Minh') AS processed_at
    FROM unfold
)

SELECT * FROM normalized
