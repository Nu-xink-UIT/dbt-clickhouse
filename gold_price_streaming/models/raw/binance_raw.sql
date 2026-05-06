CREATE DATABASE IF NOT EXISTS raw;

CREATE TABLE IF NOT EXISTS raw.binance_raw_local (
    fetched_at String,
    e String,
    E Int64,
    s String,
    p Float64,
    P Float32,
    w Float64,
    x Float64,
    c Float64,
    Q Float64,
    b Float64,
    B Float64,
    a Float64,
    A Float64,
    o Float64,
    h Float64,
    l Float64,
    v Float64,
    q Float64,
    O Int64,
    C Int64,
    F Int64,
    L Int64,
    n Int64,
    _offset UInt64,
    _partition UInt32
)
ENGINE = MergeTree()
ORDER BY (E);

CREATE TABLE IF NOT EXISTS raw.binance_raw
AS raw.binance_raw_local
ENGINE = Distributed('goldprice', raw, binance_raw_local, E);