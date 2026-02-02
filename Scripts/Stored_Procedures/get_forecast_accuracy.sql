DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_forecast_accuracy`(
in_fiscal_year int )
BEGIN
SET sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));
with forecast_error as (SELECT 
s.customer_code,
sum(s.sold_quantity) as total_sold_qty,
sum(s.forecast_quantity) as total_forecast_qty,
 sum(forecast_quantity-sold_quantity) as net_error, 
sum(forecast_quantity-sold_quantity)*100/sum(forecast_quantity) as net_error_pct,
sum(abs(forecast_quantity-sold_quantity)) as abs_error,
sum(abs(forecast_quantity-sold_quantity))*100/sum(forecast_quantity) as abs_error_pct
FROM gdb0041.fact_act_est s
where s.fiscal_year=in_fiscal_year
group by s.customer_code)
select
e.*, c.customer, c.market,
if (abs_error_pct>100,0,(100-abs_error_pct)) as forecast_accuracy
 from forecast_error e
 join dim_customer c
 using (customer_code)
 order by forecast_accuracy desc;

END$$
DELIMITER ;
