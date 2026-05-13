{% macro create_dict_currency() %}
    {%set sql %}
        CREATE DICTIONARY IF NOT EXISTS silver.dict_dim_currency (
            currency_id String,
            currency_code String,
        )
        PRIMARY KEY currency_code
        SOURCE(CLICKHOUSE(
            HOST '10.148.0.4'
            PORT 31585
            USER 'admin'
            PASSWORD 'goldprice_2026'
            DB 'silver'
            TABLE 'dim_currency'
        ))
        LIFETIME(MIN 3600 MAX 7200)
        LAYOUT(HASHED())
    {% endset %}
    {% do run_query(sql) %}
    {{log("Dictionary dict_dim_currency created", info=True)}}
{% endmacro %}