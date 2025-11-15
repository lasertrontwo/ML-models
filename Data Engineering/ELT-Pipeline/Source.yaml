Step 1 — Snowflake Setup
use role accountadmin;

create warehouse dbt_wh with warehouse_size='x-small';
create database if not exists dbt_db;
create role if not exists dbt_role;

grant role dbt_role to user jayzern;
grant usage on warehouse dbt_wh to role dbt_role;
grant all on database dbt_db to role dbt_role;

use role dbt_role;
create schema if not exists dbt_db.dbt_schema;


Step 2 — dbt Configuration
File: dbt_project/profiles.yml
models:
  snowflake_workshop:
    staging:
      materialized: view
      snowflake_warehouse: dbt_wh
    marts:
      materialized: table
      snowflake_warehouse: dbt_wh


Step 3 — Sources & Staging Models
File:models/staging/tpch_sources.yml
version: 2

sources:
  - name: tpch
    database: snowflake_sample_data
    schema: tpch_sf1
    tables:
      - name: orders
        columns:
          - name: o_orderkey
            tests:
              - unique
              - not_null
      - name: lineitem
        columns:
          - name: l_orderkey
            tests:
              - relationships:
                  to: source('tpch', 'orders')
                  field: o_orderkey

file :models/staging/stg_tpch_orders.sql
select
    o_orderkey as order_key,
    o_custkey as customer_key,
    o_orderstatus as status_code,
    o_totalprice as total_price,
    o_orderdate as order_date
from {{ source('tpch', 'orders') }}

file:models/staging/stg_tpch_line_items.sql
select
    {{
        dbt_utils.generate_surrogate_key([
            'l_orderkey',
            'l_linenumber'
        ])
    }} as order_item_key,
    l_orderkey as order_key,
    l_partkey as part_key,
    l_linenumber as line_number,
    l_quantity as quantity,
    l_extendedprice as extended_price,
    l_discount as discount_percentage,
    l_tax as tax_rate
from {{ source('tpch', 'lineitem') }}

Step 4 — Custom Macro
{% macro discounted_amount(extended_price, discount_percentage, scale=2) %}
    (-1 * {{ extended_price }} * {{ discount_percentage }})::decimal(16, {{ scale }})
{% endmacro %}

Step 5 — Marts (Transform Models)
file:models/marts/int_order_items.sql
select
    line_item.order_item_key,
    line_item.part_key,
    line_item.line_number,
    line_item.extended_price,
    orders.order_key,
    orders.customer_key,
    orders.order_date,
    {{ discounted_amount('line_item.extended_price', 'line_item.discount_percentage') }}
        as item_discount_amount
from {{ ref('stg_tpch_orders') }} as orders
join {{ ref('stg_tpch_line_items') }} as line_item
    on orders.order_key = line_item.order_key
order by orders.order_date

file:models/marts/int_order_items_summary.sql
select 
    order_key,
    sum(extended_price) as gross_item_sales_amount,
    sum(item_discount_amount) as item_discount_amount
from {{ ref('int_order_items') }}
group by order_key

file:models/marts/fct_orders.sql
select
    orders.*,
    order_item_summary.gross_item_sales_amount,
    order_item_summary.item_discount_amount
from {{ ref('stg_tpch_orders') }} as orders
join {{ ref('int_order_items_summary') }} as order_item_summary
    on orders.order_key = order_item_summary.order_key
order by order_date

Step 6 — Tests
File: models/marts/generic_tests.yml
models:
  - name: fct_orders
    columns:
      - name: order_key
        tests:
          - unique
          - not_null
          - relationships:
              to: ref('stg_tpch_orders')
              field: order_key
              severity: warn
      - name: status_code
        tests:
          - accepted_values:
              values: ['P', 'O', 'F']

Singular Test — Discount must not be positive
File: tests/fct_orders_discount.sql
select *
from {{ ref('fct_orders') }}
where item_discount_amount > 0

Singular Test — Dates must be valid
File: tests/fct_orders_date_valid.sql
select *
from {{ ref('fct_orders') }}
where date(order_date) > CURRENT_DATE()
   or date(order_date) < date('1990-01-01')

dbt Pipeline commands:
# Install dbt packages
dbt deps

# Validate connection
dbt debug

# Run all models
dbt run

# Run tests
dbt test



