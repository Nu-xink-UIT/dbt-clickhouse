{{ config(
    materialized='materialized_view',
    engine='ReplacingMergeTree(fetched_at)',
    order_by='(symbol, event_time)',
    settings={'allow_nullable_key': 1}
) }}

WITH raw_binance AS (
    SELECT * FROM {{ source('raw_data', 'binance_raw') }}
),

cleaned AS (
    SELECT
        s AS symbol,
        toDateTime64(E / 1000, 3, 'Asia/Ho_Chi_Minh') AS event_time,

        -- OHLC cho Candle Chart
        CAST(o AS Float64) AS open_price,
        CAST(h AS Float64) AS high_price,
        CAST(l AS Float64) AS low_price,
        CAST(c AS Float64) AS close_price,


        CAST(x AS Float64) AS reference_price,
        CAST(b AS Float64) AS bid_price,
        CAST(a AS Float64) AS ask_price,


        CAST(p AS Float64) AS price_change_abs,
        CAST(P AS Float64) AS price_change_pct,
        CAST(w AS Float64) AS vw_avg_price,
        CAST(v AS Float64) AS volume_base,
        CAST(q AS Float64) AS volume_quote,
        CAST(n AS UInt32)  AS trades_count,

        -- 6. Time Window
        toDateTime64(O / 1000, 3, 'Asia/Ho_Chi_Minh') AS window_start_time,
        toDateTime64(C / 1000, 3, 'Asia/Ho_Chi_Minh') AS window_end_time,

        parseDateTime64BestEffort(fetched_at, 3, 'Asia/Ho_Chi_Minh') AS fetched_at,
        toDate(toDateTime64(E / 1000, 3, 'Asia/Ho_Chi_Minh')) AS date_key,
        now64(3, 'Asia/Ho_Chi_Minh') AS processed_at

    FROM raw_binance
)

SELECT * FROM cleaned