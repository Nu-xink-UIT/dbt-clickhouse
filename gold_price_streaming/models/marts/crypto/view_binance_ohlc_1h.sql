{{ config(materialized='view') }}

SELECT
    toStartOfHour(event_time_bucket_1m) AS event_time_bucket,
    symbol,
    argMinMerge(open_price_state) AS open_price,
    maxMerge(high_price_state) AS high_price,
    minMerge(low_price_state) AS low_price,
    argMaxMerge(close_price_state) AS close_price
FROM {{ ref('mart_binance_ohlc') }}
GROUP BY
    event_time_bucket,
    symbol