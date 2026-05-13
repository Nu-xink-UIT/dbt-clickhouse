{% macro create_dict_sjc() %}
{% set sql %}
    CREATE DICTIONARY IF NOT EXISTS silver.dict_sjc (
        product_id UInt64,
        product_name String,
        branch_name String,
        bid_price Float64,
        ask_price Float64,
        date_key Date,
        max_event_time DateTime64
    )
    PRIMARY KEY product_id
    SOURCE(CLICKHOUSE(
        HOST '10.148.0.4'
        PORT 31585
        USER 'admin'
        PASSWORD 'goldprice_2026'
        DB 'staging_dev'
        QUERY '
            SELECT
                product_id,
                argMax(product_name, event_time) AS product_name,
                argMax(branch_name, event_time) AS branch_name,
                argMax(bid_price, event_time) AS bid_price,
                argMax(ask_price, event_time) AS ask_price,
                argMax(date_key, event_time) AS date_key,
                max(event_time) AS max_event_time -- Đổi tên để tránh trùng lặp gây lỗi
            FROM (
                SELECT *
                FROM staging_dev.stg_sjc
                WHERE product_name = \'Vàng SJC 1L, 10L, 1KG\'
                AND branch_name = \'Hồ Chí Minh\'
            )
            GROUP BY product_id
        '
    ))
    LIFETIME(MIN 300 MAX 600)
    -- LAYOUT(HASHED())
    LAYOUT(FLAT())

{% endset %}
{% do run_query(sql) %}
{{log('Dictionary dict_sjc created', info=True)}}

{% endmacro %}


