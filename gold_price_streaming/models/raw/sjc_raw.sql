CREATE DATABASE IF NOT EXISTS raw;

CREATE TABLE IF NOT EXISTS raw.sjc_raw_local (
    fetched_at DateTime64(3),
    latestDate String,
    Id UInt32,
    TypeName String,
    BranchName String,
    BuyValue Float64,
    SellValue Float64,
    BuyDifferValue Float64,
    SellDifferValue Float64,
    GroupDate String,
    _offset UInt64,
    _partition UInt32
)
-- ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/raw/sjc_raw_local', '{replica}')
ENGINE = MergeTree()
ORDER BY (Id, fetched_at);
-- should it be lastestDate??

CREATE TABLE IF NOT EXISTS raw.sjc_raw
AS raw.sjc_raw_local
ENGINE = Distributed('goldprice', raw, sjc_raw_local, Id);
-- insert và query đều thông qua distributed