{{ config(
    materialized='view'
) }}

SELECT
    f.event_time_bucket AS date_key,
    f.symbol,
    f.symbol AS product_name,
    'Binance' AS branch,
    f.open_price,
    f.high_price,
    f.low_price,
    f.close_price,

    (f.close_price - f.open_price) AS daily_price_change,
    if(f.open_price > 0,
       round(((f.close_price - f.open_price) / f.open_price) * 100, 2),
       0) AS daily_price_change_percent,
    if(f.close_price > f.open_price, 'Bullish', 'Bearish') AS daily_trend_status

FROM {{ ref('view_binance_ohlc_1d') }} f

{% if is_incremental() %}
  WHERE f.event_time_bucket >= (SELECT max(date_key) FROM {{ this }})
{% endif %}