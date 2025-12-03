/* tranforming raw data in the layer1 to cleaned and structured data then loading into layer2 database tables.
 stored procedure is used to perform transformation and load operation in a single call basically its easy
*/

DELIMITER //
create procedure load_layer2()
BEGIN
truncate table layer2.layer2_crm_cust_info ;
insert into layer2.layer2_crm_cust_info  (
cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
   ) 
select cst_id,
 cst_key,
 trim(cst_firstname) as cst_firstname,
 trim(cst_lastname) as cst_lastname,
 case when upper(trim(cst_marital_status))='S' then 'Single'
       when upper(trim(cst_marital_status))='M' then 'MARRIED'
       Else 'NA'
	END cst_marital_status,
 case when upper(trim(cst_gndr))='F' then 'FEMALE'
       when upper(trim(cst_gndr))='M' then 'MALE'
       Else 'NA'
	END cst_gndr,
 cst_create_date
 from(
 select * ,row_number() over(partition by cst_id order by cst_create_date desc) as flag from 
 layer1.layer1_crm_cust_info) t where flag =1  AND cst_id IS NOT NULL
  AND cst_firstname IS NOT NULL AND cst_firstname <> ''
  AND cst_lastname  IS NOT NULL AND cst_lastname  <> '';
 
 truncate table layer2.layer2_crm_prd_info;
 insert into layer2.layer2_crm_prd_info(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
select 
prd_id,
replace(substring(prd_key,1,5),'-','_')as cat_id, 
substring(prd_key,7) as prd_key,
prd_nm,
coalesce(prd_cost,0) as prd_cost,
case upper(trim(prd_line)) 
when'R' then 'Road'
when 'M' then 'Mountain'
when 'S' then 'other sales'
when 'T' then 'Touring'
else 'NA'
END  prd_line,
prd_start_dt,
lead(prd_start_dt) over(partition by prd_key order by prd_start_dt )- interval 1 day as prd_end_dt
from layer1.layer1_crm_prd_info;

truncate table layer2.layer2_crm_sales_details;
insert into  layer2.layer2_crm_sales_details(
sls_ord_num ,
sls_prd_key,
sls_cust_id ,
sls_order_dt ,
sls_ship_dt ,
sls_due_dt ,
sls_sales ,
sls_quantity ,
sls_price 
)
WITH cleaned AS (
  SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE 
      WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
      ELSE STR_TO_DATE(CAST(sls_order_dt AS CHAR), '%Y%m%d')
    END AS sls_order_dt,
    CASE 
      WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
      ELSE STR_TO_DATE(CAST(sls_ship_dt AS CHAR), '%Y%m%d')
    END AS sls_ship_dt,
    CASE 
      WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
      ELSE STR_TO_DATE(CAST(sls_due_dt AS CHAR), '%Y%m%d')
    END AS sls_due_dt,
    sls_sales,
    sls_quantity,
    CASE 
      WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
      ELSE sls_price 
    END AS sls_price_clean
  FROM layer1.layer1_crm_sales_details
)
SELECT
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
  sls_order_dt,
  sls_ship_dt,
  sls_due_dt,
  CASE 
    WHEN sls_sales IS NULL OR sls_sales <= 0 
         OR sls_sales != sls_quantity * ABS(sls_price_clean)
    THEN sls_quantity * ABS(sls_price_clean)
    ELSE sls_sales
  END AS sls_sales,
  sls_quantity,
  sls_price_clean AS sls_price
FROM cleaned;

truncate table layer2.layer2_erp_cust_az12;
 insert into layer2.layer2_erp_cust_az12(
 CID,
 BDATE,
 GEN
 )
 
 select case when CID like 'NAS%' then substring(CID,4)
 else CID
 end as CID,
 case when BDATE >now() then null
 else BDATE
 end as BDATE,
 CASE
    WHEN UPPER(TRIM(REPLACE(GEN, CHAR(13), ''))) IN ('F','FEMALE')
      THEN 'Female'
    WHEN UPPER(TRIM(REPLACE(GEN, CHAR(13), ''))) IN ('M','MALE')
      THEN 'Male'
    ELSE 'NA'
  END AS GEN
 from layer1.layer1_erp_cust_az12;
 
 truncate table layer2.layer2_erp_loc_a101;
 insert into layer2.layer2_erp_loc_a101(
 CID ,
CNTRY 
 )
 select replace(CID,'-','') as CID,case
 when trim(replace(CNTRY,char(13),'')) ='DE' then 'Germany'
when trim(replace(CNTRY,char(13),'')) in('US','USA') then 'United States'
when CNTRY is null or trim(replace(CNTRY,char(13),'')) =''  
then 'NA'
else trim(replace(CNTRY,char(13),'')) END as
CNTRY from layer1.layer1_erp_loc_a101;
 
truncate table layer2.layer2_erp_px_cat_g1v2;
insert into layer2.layer2_erp_px_cat_g1v2(
ID,
CAT,
SUBCAT,
MAINTENANCE 
)
 select ID,
CAT,
SUBCAT,
case when trim(replace(MAINTENANCE,char(13),''))='' then 'NA'
else trim(replace(MAINTENANCE,char(13),'')) end as MAINTENANCE
from Layer1.layer1_erp_px_cat_g1v2;

 END //
 DELIMITER ;

 call load_layer2();
