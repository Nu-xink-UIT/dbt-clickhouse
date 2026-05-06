CREATE DATABASE IF NOT EXISTS raw;

CREATE TABLE IF NOT EXISTS raw.goldprice_raw_local (
    fetched_at DateTime64(3),
    ts Int64,
    tsj Int64,
    date String,
    curr String,
    xauPrice Float64,
    xagPrice Float64,
    chgXau Float64,
    chgXag Float64,
    pcXau Float64,
    pcXag Float64,
    xauClose Float64,
    xagClose Float64,
    _offset UInt64,
    _partition UInt32

)
ENGINE = MergeTree()
ORDER BY(curr, fetched_at);


CREATE TABLE IF NOT EXISTS raw.goldprice_raw
AS raw.goldprice_raw_local
ENGINE = Distributed('goldprice', raw, goldprice_raw_local, cityHash64(curr));