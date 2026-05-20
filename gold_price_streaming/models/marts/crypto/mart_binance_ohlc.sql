{{ config(
    materialized='materialized_view',
    engine='AggregatingMergeTree()',
    order_by='(symbol, event_time_bucket_1m)',
    partition_by='toYYYYMM(event_time_bucket_1m)'
) }}

SELECT
    toStartOfMinute(event_time) AS event_time_bucket_1m,
    symbol, -- Đổi từ product_id thành symbol để khớp với stg_binance

    -- Dùng close_price (giá hiện tại của tick stream) để tính toán State
    argMinState(close_price, event_time) AS open_price_state,
    maxState(close_price) AS high_price_state,
    minState(close_price) AS low_price_state,
    argMaxState(close_price, event_time) AS close_price_state

FROM {{ ref('stg_binance') }}
GROUP BY
    event_time_bucket_1m,
    symbol