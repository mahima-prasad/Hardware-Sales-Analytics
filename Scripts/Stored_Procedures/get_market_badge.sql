DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_market_badge`(
	in in_market varchar(45),
	in in_fiscal_year year,
	out out_badge varchar(45)
)
BEGIN
declare qty int default 0; 
# set default market to be india
if in_market="" then
set in_market="india";
end if;
#retrive total qty for a market+fyear
SELECT 
	sum(s.sold_quantity) into qty
FROM fact_sales_monthly s
join dim_customer c
on s.customer_code=c.customer_code
where 
	get_fiscal_year(s.date)=in_fiscal_year and 
	c.market=in_market
group by c.market; 
# determine market badge
if qty>5000000 then
	set out_badge="Gold";
else 
	set out_badge="Silver";
end if;
END$$
DELIMITER ;
