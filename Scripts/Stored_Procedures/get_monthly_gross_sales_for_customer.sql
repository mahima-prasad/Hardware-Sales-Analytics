DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monthly_gross_sales_for_customer`(
in_customer_codes text
)
BEGIN
SELECT 
s.date,
sum(round(g.gross_price*s.sold_quantity, 2)) as monthly_sales
FROM fact_sales_monthly s
join fact_gross_price g
on
	s.product_code=g.product_code and
    g.fiscal_year=get_fiscal_year(s.date)
where 
	find_in_set (s.customer_code, in_customer_codes)>0
group by date;
END$$
DELIMITER ;
