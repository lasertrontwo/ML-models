/* loading csv files into  layer1 database tables with no transformation in data
   TRUNCATE removes old data from each Layer-1 table.
   Start and end timestamps are recorded but not used further.
*/

truncate layer1_crm_cust_info ;
SET @start_time = NOW();
load data local infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
into table layer1_crm_cust_info 
fields terminated by ',' optionally enclosed by '"'
Lines terminated by '\n' ignore 1 rows;
set @end_time=now();


truncate layer1_crm_prd_info ;
set @start_time=now();
load data local infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
into table layer1_crm_prd_info 
fields terminated by ',' optionally enclosed by '"'
Lines terminated by '\n' ignore 1 rows;
set @end_time=now();


truncate layer1_crm_sales_details;
set @start_time=now();
load data local infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
into table layer1_crm_sales_details 
fields terminated by ',' optionally enclosed by '"'
Lines terminated by '\n' ignore 1 rows;
set @end_time=now();




truncate layer1_erp_cust_az12;
set @start_time=now();
load data local infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CUST_AZ12.csv'
into table layer1_erp_cust_az12 
fields terminated by ',' optionally enclosed by '"'
Lines terminated by '\n' ignore 1 rows;
set @end_time=now();


truncate layer1_erp_loc_a101;
set @start_time=now();
load data local infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/LOC_A101.csv'
into table layer1_erp_loc_a101 
fields terminated by ',' optionally enclosed by '"'
Lines terminated by '\n' ignore 1 rows;
set @end_time=now();



truncate layer1_erp_px_cat_g1v2;
set @start_time=now();
load data local infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PX_CAT_G1V2.csv'
into table layer1_erp_px_cat_g1v2 
fields terminated by ',' optionally enclosed by '"'
Lines terminated by '\n' ignore 1 rows;
set @end_time=now();



