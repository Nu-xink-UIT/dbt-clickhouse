# Real-Time Gold & Crypto Data Pipeline (dbt + ClickHouse)

## Project Overview
This project implements a highly scalable **Real-Time Data Warehouse** designed to ingest, process, and analyze time-series data from the Gold market (SJC vs. Global) and Cryptocurrency exchanges (Binance). 

Adhering strictly to the **Medallion Architecture** (Bronze - Silver - Gold), the pipeline leverages **dbt (Data Build Tool)** for robust data transformations and **ClickHouse** as the analytical (OLAP) engine to handle high-volume streaming data with ultra-low latency.

## 🛠 Tech Stack
* **Data Ingestion:** Kafka Connect (Real-time Streaming)
* **Data Warehouse / OLAP:** ClickHouse
* **Data Transformation:** dbt (Data Build Tool) - version 1.11.x
* **BI / Visualization:** Grafana / Power BI

## 🚀 Key Features
* **Real-time OHLC Aggregation:** Utilizes ClickHouse's `AggregatingMergeTree` and Materialized Views to unwrap state variables (`argMinState`, `maxState`, etc.) and compute continuous OHLC candlesticks (1m, 15m, 1h, 1d) at the exact moment of ingestion.
* **Time-Series "ASOF" Joins:** Implements highly optimized logic to map real-time Vietcombank (VCB) foreign exchange rates against global gold prices, ensuring accurate calculation of market spreads and premiums.
* **Incremental Loading Architecture:** Maximizes query performance and minimizes compute overhead for One Big Tables (OBTs) by combining dbt Incremental Models with ClickHouse's `ReplacingMergeTree` engine for automatic data deduplication.
* **Rigorous Data Quality & Testing:** * Integrated dbt Generic Tests (`unique`, `not_null`, `accepted_values`) to enforce data integrity.
  * Developed Custom Singular Tests to intercept anomalies before serving (e.g., `assert_positive_spot_price_vnd` to block negative converted gold prices).

## 📂 Medallion Data Architecture

| Data Layer | Schema | Description |
| :--- | :--- | :--- |
| **0. Raw (Bronze)** | `raw` | Raw payloads (JSON/Kafka) ingested directly into ClickHouse via Distributed Tables (`binance_raw`, `sjc_raw`, `goldprice_raw`). |
| **1. Staging** | `staging` | Light transformations, data type casting, and column name standardization. |
| **2. Silver** | `silver` | Conformed dimensions (`dim_product`, `dim_currency`) and cleansed fact tables (e.g., `silver_gold_exchange` integrating USD to VND conversions). |
| **3. Marts (Gold and Crypto)** | `marts` | Complex business logic and state aggregations handled via Materialized Views (`mart_binance_ohlc`). |
| **4. BI Serving** | `marts` | Flattened One Big Tables (OBTs) optimized for drag-and-drop BI dashboards (`obt_gold_market_trend`, `obt_binance_daily_ohlc`). |

## 📊 Data Lineage DAG
<img width="2908" height="1272" alt="dbt-dag-3" src="https://github.com/user-attachments/assets/9cefaadb-21a6-4adf-830e-45ba80e35ff7" />



## 💻 Getting Started

**1. Environment Setup:**
Ensure Python 3.9+ is installed. Create and activate a virtual environment:
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install dbt-clickhouse
```

** 2. ClickHouse Configuration:
Configure your ~/.dbt/profiles.yml file to securely connect to your ClickHouse server/cluster.

**3. Build the Pipeline:
Load environment variables and execute the full pipeline.
```bash
export $(grep -v '^#' .env | xargs) && dbt build
```

**4. Generate & Serve Documentation:
Launch the interactive Data Lineage and documentation portal:

```Bash
dbt docs generate --profiles-dir .
dbt docs serve --profiles-dir . --port 8080
```
## Data Testing & Quality Assurance
This project enforces strict Data Contracts to ensure BI dashboards consume only validated data:

```Bash
# Execute all configured generic and singular tests
dbt test

# Execute tests for a specific critical model
dbt test --select silver_gold_exchange
```
