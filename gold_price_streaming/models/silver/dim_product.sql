{{ config(
    materialized='table',
    engine='MergeTree()',
    order_by='product_id' 
) }}

SELECT 1 AS product_id, 'Vàng SJC 1L, 10L, 1KG' AS product_name, '2' AS symbol, 'Gold' AS asset_type, 'Local' AS origin, 'SJC' AS provider, 'Miền Bắc' AS branch, 'Lượng' AS unit, 1.205653 AS conversion_to_oz
UNION ALL SELECT 2, 'Vàng SJC 1L, 10L, 1KG', '10', 'Gold', 'Local', 'SJC', 'Quảng Ngãi', 'Lượng', 1.205653
UNION ALL SELECT 3, 'Vàng SJC 1L, 10L, 1KG', '4', 'Gold', 'Local', 'SJC', 'Nha Trang', 'Lượng', 1.205653
UNION ALL SELECT 4, 'Vàng SJC 5 chỉ', '17', 'Gold', 'Local', 'SJC', 'Hồ Chí Minh', 'Lượng', 1.205653
UNION ALL SELECT 5, 'Vàng SJC 1L, 10L, 1KG', '1', 'Gold', 'Local', 'SJC', 'Hồ Chí Minh', 'Lượng', 1.205653
UNION ALL SELECT 6, 'Vàng SJC 1L, 10L, 1KG', '7', 'Gold', 'Local', 'SJC', 'Huế', 'Lượng', 1.205653
UNION ALL SELECT 7, 'Vàng SJC 1L, 10L, 1KG', '177', 'Gold', 'Local', 'SJC', 'Hải Phòng', 'Lượng', 1.205653
UNION ALL SELECT 8, 'Vàng nhẫn SJC 99,99% 0.5 chỉ, 0.3 chỉ', '65', 'Gold', 'Local', 'SJC', 'Hồ Chí Minh', 'Lượng', 1.205653
UNION ALL SELECT 9, 'Nữ trang 68%', '129', 'Gold', 'Local', 'SJC', 'Hồ Chí Minh', 'Lượng', 1.205653
UNION ALL SELECT 10, 'Nữ trang 99,99%', '81', 'Gold', 'Local', 'SJC', 'Hồ Chí Minh', 'Lượng', 1.205653
UNION ALL SELECT 11, 'Vàng SJC 1L, 10L, 1KG', '5', 'Gold', 'Local', 'SJC', 'Cà Mau', 'Lượng', 1.205653
UNION ALL SELECT 12, 'Nữ trang 61%', '210', 'Gold', 'Local', 'SJC', 'Hồ Chí Minh', 'Lượng', 1.205653
UNION ALL SELECT 13, 'Nữ trang 99%', '97', 'Gold', 'Local', 'SJC', 'Hồ Chí Minh', 'Lượng', 1.205653
UNION ALL SELECT 14, 'Vàng nhẫn SJC 99,99% 1 chỉ, 2 chỉ, 5 chỉ', '49', 'Gold', 'Local', 'SJC', 'Hồ Chí Minh', 'Lượng', 1.205653
UNION ALL SELECT 15, 'Vàng SJC 1L, 10L, 1KG', '16', 'Gold', 'Local', 'SJC', 'Bạc Liêu', 'Lượng', 1.205653
UNION ALL SELECT 16, 'Vàng SJC 1L, 10L, 1KG', '188', 'Gold', 'Local', 'SJC', 'Miền Trung', 'Lượng', 1.205653
UNION ALL SELECT 17, 'Nữ trang 41,7%', '161', 'Gold', 'Local', 'SJC', 'Hồ Chí Minh', 'Lượng', 1.205653
UNION ALL SELECT 18, 'Nữ trang 75%', '113', 'Gold', 'Local', 'SJC', 'Hồ Chí Minh', 'Lượng', 1.205653
UNION ALL SELECT 19, 'Nữ trang 58,3%', '145', 'Gold', 'Local', 'SJC', 'Hồ Chí Minh', 'Lượng', 1.205653
UNION ALL SELECT 20, 'Vàng SJC 1L, 10L, 1KG', '8', 'Gold', 'Local', 'SJC', 'Biên Hòa', 'Lượng', 1.205653
UNION ALL SELECT 21, 'Vàng SJC 1L, 10L, 1KG', '13', 'Gold', 'Local', 'SJC', 'Hạ Long', 'Lượng', 1.205653
UNION ALL SELECT 22, 'Vàng SJC 1L, 10L, 1KG', '9', 'Gold', 'Local', 'SJC', 'Miền Tây', 'Lượng', 1.205653
UNION ALL SELECT 23, 'Vàng SJC 0.5 chỉ, 1 chỉ, 2 chỉ', '33', 'Gold', 'Local', 'SJC', 'Hồ Chí Minh', 'Lượng', 1.205653
UNION ALL SELECT 24, 'Gold', 'XAU', 'Gold', 'Global', 'Goldprice', 'New York', 'Ounce', 1.0
UNION ALL SELECT 25, 'Silver', 'XAG', 'Silver', 'Global', 'Goldprice', 'New York', 'Ounce', 1.0
UNION ALL SELECT 26, 'PAX Gold', 'PAXGUSDT', 'Crypto', 'Global', 'Binance', '', 'Token', 1.0