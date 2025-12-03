
/*Integration of CRM customer data (crm_cust_info) with ERP customer and location data (erp_cust_az12, erp_loc_a101)*/
create view layer3.dim_customer as
select
row_number() over(order by ci.cst_id) as customer_key,
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as firstname,
ci.cst_lastname as lastname,
ci.cst_marital_status as marital_status,
 case when ci.cst_gndr !='NA' then ci.cst_gndr
 else coalesce(ca.GEN,'NA')
 END as gender,
 la.CNTRY as country ,
 ca.BDATE as birthdate,
ci.cst_create_date as create_date
 from layer2.layer2_crm_cust_info as ci
 left join layer2.layer2_erp_cust_az12 as ca on ci.cst_key  =ca.CID
 left join layer2.layer2_erp_loc_a101 as la on ci.cst_key =la .CID;
 
 /*data integration on CRM product info with erp_px_cat_g1v2 */
 create view layer3.dim_products as
 select 
 row_number() over(order by pn.prd_key,pn.prd_start_dt) as product_key,
 pn.prd_id as product_id,
 pn.prd_key as product_number,
 pn.prd_nm as product_name,
 pn.cat_id as category_id,
 pc.CAT as category,
  pc.SUBCAT as sub_category,
  pc.MAINTENANCE as maintenance,
 pn.prd_cost as cost,
 pn.prd_line as product_line,
 pn.prd_start_dt as start_date
from layer2.layer2_crm_prd_info as pn left join layer2.layer2_erp_px_cat_g1v2 as pc on pn.cat_id=pc.ID where
 pn.prd_end_dt is null;
 
 
 /*Creating a fact table and establishing relationships with the related dimension tables.*/
 create view layer3.fact_sales as
 select sd.sls_ord_num as order_number,
 pr.product_key as product_key,
 cs.customer_key as customer_key,
 sd.sls_order_dt as order_date,
 sd.sls_ship_dt as shipping_date,
 sd.sls_due_dt as due_date,
 sd.sls_sales as sales,
 sd.sls_quantity as quantity,
 sd.sls_price as price
 from layer2.layer2_crm_sales_details as sd
 left join layer3.dim_products as pr on sd.sls_prd_key=pr.product_number
 left join layer3.dim_customer as cs  on sd.sls_cust_id=cs.customer_id;

