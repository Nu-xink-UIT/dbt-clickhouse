{% macro create_dict_product() %}
    {%set sql %}
        CREATE DICTIONARY IF NOT EXISTS silver.dict_dim_product (
            product_id String,
            product_name String,
            branch String
        )
        PRIMARY KEY product_name, branch
        SOURCE(CLICKHOUSE(
            HOST '10.148.0.4'
            PORT 31585
            USER 'admin'
            PASSWORD 'goldprice_2026'
            DB 'silver'
            QUERY '
                SELECT product_id, product_name, branch
                FROM silver.dim_product'
        ))
        LIFETIME(MIN 3600 MAX 7200)
        LAYOUT(COMPLEX_KEY_HASHED())
    {% endset %}
    {% do run_query(sql) %}
    {{log('Dictionary dict_dim_product created', info=True)}}
{% endmacro %}