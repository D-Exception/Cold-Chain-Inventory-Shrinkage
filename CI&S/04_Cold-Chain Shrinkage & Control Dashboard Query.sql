/* =========================================
   1. DATABASE EXPLORATION
   Inspect available tables
========================================= */
use `cold_chain_inventory_&_shrinkage`;

select * from suppliers_coldchain_c limit 5;
select * from products_coldchain_c limit 5;
select * from purchase_orders_coldchain_c limit 5;
select * from purchase_order_lines_coldchain_c limit 5;
select * from stock_movements_coldchain_c limit 5;
select * from cycle_counts_coldchain_c limit 5;
select * from temperature_logs_coldchain_c limit 5;

-- END --

/* =========================================
   2. DATA CLEANING
   Standardize date formats
========================================= */
update purchase_order_lines_coldchain_c
set order_date = STR_TO_DATE(order_date, '%m/%d/%Y %H:%i');

alter table purchase_order_lines_coldchain_c
modify order_date datetime;

update stock_movements_coldchain_c
set movement_date = STR_TO_DATE(movement_date, '%m/%d/%Y %H:%i');

alter table stock_movements_coldchain_c
modify movement_date datetime;

-- End --

/* =========================================
   3. INVENTORY SHRINKAGE ANALYSIS
   Compare ordered quantity vs received quantity
========================================= */
-- Which products are missing from the supply chain? --
-- Products are Ordered -> Delivered to warehouses -> sold/moved(transfered in or out from warehouses) --
-- To know which products is missing, where its going missing and why its going missing hey have to be tracked in that order --
-- i need to see products that were orderd within a particular time frame (day) along with the number of products that were orderd and compare em with products received--

with ordered as (
	select po_line_id, product_id, supplier_id,
    date(expected_delivery_date) as expected_delivery_day,
    ordered_qty
    from purchase_order_lines_coldchain_c),
received as (
	select po_line_id, product_id,
    date(movement_date) as received_day,
    quantity as received_qty
    from stock_movements_coldchain_c)
select o.po_line_id, o.product_id, o.supplier_id, o.expected_delivery_day, o.ordered_qty, 
	coalesce(r.received_qty,0) as received_qty
from ordered o
left join received r 
	on o.po_line_id = r.po_line_id
    and r.received_day between date_sub(o.expected_delivery_day, interval 3 day)
                          and date_add(o.expected_delivery_day, interval 3 day);

-- The query above can be used to ans Questions like What(Product) is going missing?, where it is going missing?, why it is going missing? and which supplier could be responsible for this --
-- END --

/* =========================================
   4. WAREHOUSE TRANSFER ANALYSIS
   Compare ordered quantity vs received quantity
========================================= */
-- The Query below is to create a sheet to help track if products moved from warehouses A succefully got to Warehouse B --
select reference_id, 
	sum(
    case when movement_type = 'Transfer_Out' then quantity end) as Moved_quantity,
    sum(
    case when movement_type = 'Transfer_In' then quantity end) as Received_quantity
from stock_movements_coldchain_c
Where movement_type in ('Transfer_Out' , 'Transfer_In')
group by reference_id;

-- END --

/* =========================================
   5. PRODUCT DAMAGE ANALYSIS
   Compare ordered quantity vs received quantity
========================================= */
-- The query below tracks the quantity of all products in a warehouse as well as the quantity of all products with damaged packaging and the quantity of all products that got damaged by temperature excursion --
select warehouse_id, 
	Sum(
    Case when movement_type = 'Receipt' then quantity else 0 end ) as total_qty,
	Sum(case when movement_type = 'Write_Off'
    and reason = 'Damaged_Packaging' then quantity else 0 end) as damaged_write_off_qty,
    Sum(case when movement_type = 'Write_Off'
    and reason = 'Temperature_Excursion' then quantity else 0 end) as temprature_write_off_qty
from stock_movements_coldchain_c
group by warehouse_id
order by total_qty desc, damaged_write_off_qty desc, temprature_write_off_qty desc;

-- End -- 

/* =========================================
   6. TEMPERATURE ANALYSIS
   Compare ordered quantity vs received quantity
========================================= */
-- The query below tracks Warehouse staus --

with Warning_count as (
	select warehouse_id,
		count(log_id) as Warning_count
from temperature_logs_coldchain_c
where sensor_status = 'WARN'
group by warehouse_id),

Offline_count as (
	select warehouse_id,
		count(log_id) as Offline_count
from temperature_logs_coldchain_c
where sensor_status = 'OFFLINE'
group by warehouse_id),

Warehouse_id as (
	select warehouse_id
from temperature_logs_coldchain_c
group by warehouse_id)

select wi.warehouse_id, coalesce(wc.Warning_count, 0) as Warning_count, coalesce(oc.Offline_count, 0) as Offline_count
from Warehouse_id wi
left join Warning_count wc on wi.warehouse_id = wc.warehouse_id
left join Offline_count oc on wi.warehouse_id = oc.warehouse_id;

-- END --
