CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `gross_sales` AS
    SELECT 
        `s`.`date` AS `date`,
        `s`.`fiscal_year` AS `fiscal_year`,
        `s`.`customer_code` AS `customer_code`,
        `c`.`customer` AS `customer`,
        `c`.`market` AS `market`,
        `s`.`product_code` AS `product_code`,
        `p`.`product` AS `product`,
        `p`.`variant` AS `variant`,
        `s`.`sold_quantity` AS `sold_quantity`,
        `g`.`gross_price` AS `gross_price_per_item`,
        ROUND((`g`.`gross_price` * `s`.`sold_quantity`),
                2) AS `gross_price_total`
    FROM
        (((`fact_sales_monthly` `s`
        JOIN `fact_gross_price` `g` ON (((`s`.`product_code` = `g`.`product_code`)
            AND (`s`.`fiscal_year` = `g`.`fiscal_year`))))
        JOIN `dim_product` `p` ON ((`s`.`product_code` = `p`.`product_code`)))
        JOIN `dim_customer` `c` ON ((`s`.`customer_code` = `c`.`customer_code`)))
