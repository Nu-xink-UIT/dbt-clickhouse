{{ config(
    materialized='table',
    engine='MergeTree()',
    order_by='currency_code'
) }}

SELECT
    currency_code,
    argMax(reference_price, event_time) AS reference_price,
    argMax(date_key, event_time) AS date_key,
    max(event_time) AS max_event_time
FROM {{ ref('stg_vcb') }}
GROUP BY currency_code