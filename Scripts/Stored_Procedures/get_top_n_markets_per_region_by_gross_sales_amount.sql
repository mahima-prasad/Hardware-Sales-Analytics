DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_markets_per_region_by_gross_sales_amount`(
in_fiscal_year int,
in_top_n int
)
BEGIN
-- Retrieve the top 2 markets in every region by their gross sales amount in FY=2021
with cte1 as
(
select
c.market ,c.region,
round(sum(g.gross_price_total)/1000000,2) as gross_sales_mln
from gross_sales g
join dim_customer c
on c.customer_code=g.customer_code
where fiscal_year=in_fiscal_year
GROUP BY c.market ,c.region
order by gross_sales_mln desc),
cte2 as
(
select
*, dense_rank() over(partition by region order by gross_sales_mln desc) as drnk
from cte1)
select* from cte2
where drnk<=in_top_n;
END$$
DELIMITER ;
