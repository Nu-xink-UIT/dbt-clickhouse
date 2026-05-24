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
        spot_price,
        event_time,
        date_key
    FROM {{ ref('stg_goldprice') }}
),

-- Bốc toàn bộ danh mục tỷ giá mới nhất của TẤT CẢ các đồng tiền từ bảng tĩnh của bạn
filtered_vcb_rates AS (
    SELECT
        currency_code,
        reference_price,
        max_event_time -- Gọi đúng cột thời gian sau gom cụm của bạn
    FROM {{ ref('dim_vcb_rates') }}
)

SELECT
    g.product_id,
    g.product_name,
    g.currency_code,
    v.reference_price AS exchange_rate_to_vnd,
    v.max_event_time AS exchange_rate_time,

    g.spot_price AS price_foreign_oz,
    g.event_time AS gold_prices_time,

    -- Tính toán quy đổi tự động dựa trên tỷ giá tương ứng của từng dòng currency_code
    (g.spot_price * v.reference_price * 1.205653) AS spot_price_vnd_luong,
    g.date_key,
    now64(3, 'Asia/Ho_Chi_Minh') as processed_at

FROM gold_prices AS g
ASOF LEFT JOIN filtered_vcb_rates AS v
  ON g.currency_code = v.currency_code
 -- Sửa điều kiện thời gian: Giá vàng sẽ bốc tỷ giá mới nhất hiện tại của bảng tĩnh vcb
AND g.event_time <= v.max_event_time