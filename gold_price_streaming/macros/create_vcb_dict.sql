{% macro create_vcb_dict() %}
    {% set sql %}
        -- DROP DICTIONARY IF EXISTS silver.dict_vcb_rates

        CREATE DICTIONARY IF NOT EXISTS silver.dict_vcb_rates (
            currency_code String,
            reference_price Float64,
            event_time DateTime64(3, 'Asia/Ho_Chi_Minh')
        )
        PRIMARY KEY currency_code
        SOURCE(CLICKHOUSE(
            HOST '10.148.0.4'
            PORT 31585
            USER 'admin'
            PASSWORD 'goldprice_2026'
            DB 'staging_dev'   -- Nơi chứa bảng gốc
            QUERY '
                SELECT currency_code, reference_price, event_time
                FROM staging_dev.staging_vcb
                WHERE currency_code, event_time IN (
                    SELECT currency_code, max(event_time)
                    FROM staging_dev.stg_vcb
                    GROUP BY currency_code)
                )
            '

        ))
        LIFETIME(MIN 300 MAX 600) -- each 5 to 10 minutes 
        LAYOUT(HASHED())

    {% endset %}
    {% do run_query(sql) %}
    {{log("Dictionary dict_vcb_rates created", info=True)}}

{% endmacro %}

