DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_products_by_net_sales`(
in_fiscal_year int,
in_top_n int
)
BEGIN
select
p.product,
round(sum(net_sales)/1000000, 2) as net_sales_mln
from net_sales n
join dim_product p
on
n.product_code=p.product_code
where fiscal_year=in_fiscal_year
group by p.product
order by net_sales_mln desc
limit in_top_n;
END$$
DELIMITER ;
