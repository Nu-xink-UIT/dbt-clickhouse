{{ config(
    materialized='table',
    engine='MergeTree()',
    order_by='product_id'
) }}

SELECT
    product_id,
    argMax(product_name, event_time) AS product_name,
    argMax(branch_name, event_time) AS branch_name,
    argMax(bid_price, event_time) AS bid_price,
    argMax(ask_price, event_time) AS ask_price,
    argMax(date_key, event_time) AS date_key,
    max(event_time) AS max_event_time
FROM {{ ref('stg_sjc') }}
GROUP BY product_id
HAVING product_name = 'Vàng SJC 1L, 10L, 1KG'
   AND branch_name = 'Hồ Chí Minh'