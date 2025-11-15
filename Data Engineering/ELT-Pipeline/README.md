# 🚀 ELT Pipeline with dbt + Snowflake (TPC-H Demo)

This project is a **code-along ELT pipeline** built using:

- **Snowflake** → Data warehouse  
- **dbt** → Transformations (staging, marts, tests)

The pipeline uses the **Snowflake TPC-H sample dataset** (`SNOWFLAKE_SAMPLE_DATA.TPCH_SF1`) and builds a small but realistic analytics model on top of it.

---

## This Project Includes

- Snowflake setup script (warehouse, DB, schema, role)
- dbt project with:
  - Source definitions
  - Staging models
  - Intermediate marts
  - Final fact model: `fct_orders`
  - Custom macro for discount calculation
  - Generic & singular tests

---

## Project Structure

```bash
.
├── README.md
├── snowflake/
│   └── 01_setup_snowflake.sql
└── dbt_project/
    ├── dbt_project.yml          # (you will configure)
    ├── profiles.yml             # dbt profile pointing to Snowflake
    ├── macros/
    │   └── pricing.sql          # discounted_amount macro
    ├── models/
    │   ├── staging/
    │   │   ├── tpch_sources.yml
    │   │   ├── stg_tpch_orders.sql
    │   │   └── stg_tpch_line_items.sql
    │   └── marts/
    │       ├── int_order_items.sql
    │       ├── int_order_items_summary.sql
    │       ├── fct_orders.sql
    │       └── generic_tests.yml
    └── tests/
        ├── fct_orders_discount.sql
        └── fct_orders_date_valid.sql
