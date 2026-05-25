-- Mục tiêu: Cảnh báo nếu giá vàng (VND/Lượng) bị tính toán ra số âm, bằng 0 hoặc bị Null.

SELECT
    product_id,
    product_name,
    gold_prices_time,
    currency_code,
    spot_price_vnd_luong
FROM {{ ref('silver_gold_exchange') }}
WHERE spot_price_vnd_luong <= 0