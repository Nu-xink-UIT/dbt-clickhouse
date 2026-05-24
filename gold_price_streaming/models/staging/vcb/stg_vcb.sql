{{ config(
    materialized='materialized_view',
    engine='ReplacingMergeTree(fetched_at)',
    order_by='(currency_code, event_time)',
    settings={'allow_nullable_key': 1}
) }}

WITH raw_vcb AS (
    SELECT
        CurrencyCode,
        CurrencyName,
        Buy,
        Sell,
        Transfer,
        DateTime,
        fetched_at
    FROM {{ source('raw_data', 'vcb_raw') }}
),

cleaned AS (
    SELECT
        CurrencyCode AS currency_code,
        CurrencyName AS currency_name,

        toFloat64OrNull(replaceAll(Buy, ',', '')) AS bid_price,
        toFloat64OrNull(replaceAll(Transfer, ',', '')) AS reference_price,
        toFloat64OrNull(replaceAll(Sell, ',', '')) AS ask_price,
        ifNull(
            parseDateTimeOrNull(DateTime, '%d/%m/%Y %H:%i:%s', 'Asia/Ho_Chi_Minh'),
            now('Asia/Ho_Chi_Minh')
        ) AS event_time,
        parseDateTime64BestEffort(fetched_at, 3, 'Asia/Ho_Chi_Minh') AS fetched_at,

        toDate(event_time) AS date_key,
        now64(3, 'Asia/Ho_Chi_Minh') AS processed_at
    FROM raw_vcb
)

SELECT * FROM cleaned