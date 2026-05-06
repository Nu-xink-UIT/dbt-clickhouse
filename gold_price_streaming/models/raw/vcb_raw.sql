CREATE DATABASE IF NOT EXISTS raw;

CREATE TABLE IF NOT EXISTS raw.vcb_raw_local (
    fetched_at String,
    DateTime String,
    Source String,
    CurrencyCode String,
    CurrencyName String,
    Buy String,
    Transfer String,
    Sell String,
    _offset UInt64,
    _partition UInt32
)
ENGINE = MergeTree()
ORDER BY (CurrencyCode);

CREATE TABLE IF NOT EXISTS raw.vcb_raw
AS raw.vcb_raw_local
ENGINE = Distributed('goldprice', raw, vcb_raw_local, cityHash64(CurrencyCode));