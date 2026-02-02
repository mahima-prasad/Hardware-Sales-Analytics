DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_products_per_division_by_qty_sold`(
in_top_n int,
in_fiscal_year int
)
BEGIN
with cte1 as
(
select
 p.division,p.product,
sum(sold_quantity) as total_qty
from fact_sales_monthly s
join dim_product p
on p.product_code=s.product_code
where fiscal_year=in_fiscal_year
GROUP BY p.product, p.division),
cte2 as
(
select
*, dense_rank() over(partition by division order by total_qty desc) as drnk
from cte1)
select* from cte2
where drnk<=in_top_n;
END$$
DELIMITER ;
