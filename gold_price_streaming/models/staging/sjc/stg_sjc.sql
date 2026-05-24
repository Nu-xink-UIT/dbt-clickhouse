{{ config(
    materialized='materialized_view',
    engine='ReplacingMergeTree(fetched_at)',
    order_by='(product_id, event_time)',
    settings={'allow_nullable_key': 1}
)}}

WITH raw_sjc AS(
    SELECT
        Id,
        TypeName,
        BranchName,
        BuyValue,
        SellValue,
        BuyDifferValue,
        SellDifferValue,
        latestDate,
        fetched_at
    FROM {{ source('raw_data', 'sjc_raw') }}
),

renamed AS(
    SELECT
        CAST(Id as UInt32) AS product_id,
        TypeName AS product_name,
        BranchName AS branch_name,
        CAST(BuyValue AS Float64) AS bid_price,
        CAST(SellValue AS Float64) AS ask_price,
        CAST(BuyDifferValue AS Float64) AS change_buy_abs,
        CAST(SellDifferValue AS Float64) AS change_sell_abs,
        toDateTime64(fetched_at, 3, 'Asia/Ho_Chi_Minh') AS fetched_at,
        toDateTime64(parseDateTime(latestDate, '%H:%i %d/%m/%Y'), 3) AS event_time, -- is HCM already - not need to +7 anymore --> take not of original data
        toDate(event_time) AS date_key,
        now64(3, 'Asia/Ho_Chi_Minh') AS processed_at
    FROM raw_sjc
)

SELECT * FROM renamed

