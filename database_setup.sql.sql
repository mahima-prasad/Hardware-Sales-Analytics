-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: gdb0041
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dim_customer`
--

DROP TABLE IF EXISTS `dim_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_customer` (
  `customer_code` int unsigned NOT NULL,
  `customer` varchar(150) NOT NULL,
  `platform` varchar(45) NOT NULL,
  `channel` varchar(45) NOT NULL,
  `market` varchar(45) DEFAULT NULL,
  `sub_zone` varchar(45) DEFAULT NULL,
  `region` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`customer_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dim_date`
--

DROP TABLE IF EXISTS `dim_date`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_date` (
  `calendar_date` date NOT NULL,
  `fiscal_year` year GENERATED ALWAYS AS (year((`calendar_date` + interval 4 month))) VIRTUAL,
  PRIMARY KEY (`calendar_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dim_product`
--

DROP TABLE IF EXISTS `dim_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dim_product` (
  `product_code` varchar(45) NOT NULL,
  `division` varchar(45) NOT NULL,
  `segment` varchar(45) NOT NULL,
  `category` varchar(45) NOT NULL,
  `product` varchar(200) NOT NULL,
  `variant` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`product_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fact_act_est`
--

DROP TABLE IF EXISTS `fact_act_est`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_act_est` (
  `date` date NOT NULL,
  `fiscal_year` year GENERATED ALWAYS AS (year((`date` + interval 4 month))) VIRTUAL,
  `product_code` varchar(45) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `customer_code` int NOT NULL DEFAULT '0',
  `sold_quantity` int DEFAULT NULL,
  `forecast_quantity` int DEFAULT NULL,
  PRIMARY KEY (`date`,`product_code`,`customer_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fact_forecast_monthly`
--

DROP TABLE IF EXISTS `fact_forecast_monthly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_forecast_monthly` (
  `date` date NOT NULL,
  `fiscal_year` year DEFAULT NULL,
  `product_code` varchar(45) NOT NULL,
  `customer_code` int NOT NULL,
  `forecast_quantity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `fact_forecast_monthly_AFTER_INSERT` AFTER INSERT ON `fact_forecast_monthly` FOR EACH ROW BEGIN
	insert into fact_act_est
    (date, product_code, customer_code, forecast_quantity)
    values(
		new.date,
		new.product_code,
		new.customer_code,
		new.forecast_quantity
    )
    on duplicate key update
		forecast_quantity=values(forecast_quantity);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `fact_freight_cost`
--

DROP TABLE IF EXISTS `fact_freight_cost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_freight_cost` (
  `market` varchar(45) NOT NULL,
  `fiscal_year` year NOT NULL,
  `freight_pct` decimal(5,4) unsigned NOT NULL,
  `other_cost_pct` decimal(5,4) unsigned NOT NULL,
  PRIMARY KEY (`market`,`fiscal_year`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fact_gross_price`
--

DROP TABLE IF EXISTS `fact_gross_price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_gross_price` (
  `product_code` varchar(45) NOT NULL,
  `fiscal_year` year NOT NULL,
  `gross_price` decimal(15,4) unsigned NOT NULL,
  PRIMARY KEY (`product_code`,`fiscal_year`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fact_manufacturing_cost`
--

DROP TABLE IF EXISTS `fact_manufacturing_cost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_manufacturing_cost` (
  `product_code` varchar(45) NOT NULL,
  `cost_year` year NOT NULL,
  `manufacturing_cost` decimal(15,4) unsigned NOT NULL,
  PRIMARY KEY (`product_code`,`cost_year`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fact_post_invoice_deductions`
--

DROP TABLE IF EXISTS `fact_post_invoice_deductions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_post_invoice_deductions` (
  `customer_code` int unsigned NOT NULL,
  `product_code` varchar(45) NOT NULL,
  `date` date NOT NULL,
  `discounts_pct` decimal(5,4) NOT NULL,
  `other_deductions_pct` decimal(5,4) NOT NULL,
  PRIMARY KEY (`customer_code`,`product_code`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fact_pre_invoice_deductions`
--

DROP TABLE IF EXISTS `fact_pre_invoice_deductions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_pre_invoice_deductions` (
  `customer_code` int unsigned NOT NULL,
  `fiscal_year` year NOT NULL,
  `pre_invoice_discount_pct` decimal(5,4) NOT NULL,
  PRIMARY KEY (`customer_code`,`fiscal_year`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fact_sales_monthly`
--

DROP TABLE IF EXISTS `fact_sales_monthly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fact_sales_monthly` (
  `date` date NOT NULL,
  `fiscal_year` year GENERATED ALWAYS AS (year((`date` + interval 4 month))) VIRTUAL,
  `product_code` varchar(45) NOT NULL,
  `customer_code` int unsigned NOT NULL,
  `sold_quantity` int unsigned NOT NULL,
  PRIMARY KEY (`date`,`product_code`,`customer_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `fact_sales_monthly_AFTER_INSERT` AFTER INSERT ON `fact_sales_monthly` FOR EACH ROW BEGIN
	insert into fact_act_est
    (date, product_code, customer_code, sold_quantity)
    values(
		new.date,
		new.product_code,
		new.customer_code,
		new.sold_quantity
    )
    on duplicate key update
		sold_quantity=values(sold_quantity);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `gross_sales`
--

DROP TABLE IF EXISTS `gross_sales`;
/*!50001 DROP VIEW IF EXISTS `gross_sales`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `gross_sales` AS SELECT 
 1 AS `date`,
 1 AS `fiscal_year`,
 1 AS `customer_code`,
 1 AS `customer`,
 1 AS `market`,
 1 AS `product_code`,
 1 AS `product`,
 1 AS `variant`,
 1 AS `sold_quantity`,
 1 AS `gross_price_per_item`,
 1 AS `gross_price_total`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `net_sales`
--

DROP TABLE IF EXISTS `net_sales`;
/*!50001 DROP VIEW IF EXISTS `net_sales`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `net_sales` AS SELECT 
 1 AS `date`,
 1 AS `fiscal_year`,
 1 AS `customer_code`,
 1 AS `market`,
 1 AS `product_code`,
 1 AS `product`,
 1 AS `variant`,
 1 AS `sold_quantity`,
 1 AS `gross_price_total`,
 1 AS `pre_invoice_discount_pct`,
 1 AS `net_invoice_sales`,
 1 AS `post_invoice_discount_pct`,
 1 AS `net_sales`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `sales_postinv_discount`
--

DROP TABLE IF EXISTS `sales_postinv_discount`;
/*!50001 DROP VIEW IF EXISTS `sales_postinv_discount`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `sales_postinv_discount` AS SELECT 
 1 AS `date`,
 1 AS `fiscal_year`,
 1 AS `customer_code`,
 1 AS `market`,
 1 AS `product_code`,
 1 AS `product`,
 1 AS `variant`,
 1 AS `sold_quantity`,
 1 AS `gross_price_total`,
 1 AS `pre_invoice_discount_pct`,
 1 AS `net_invoice_sales`,
 1 AS `post_invoice_discount_pct`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `sales_preinv_discount`
--

DROP TABLE IF EXISTS `sales_preinv_discount`;
/*!50001 DROP VIEW IF EXISTS `sales_preinv_discount`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `sales_preinv_discount` AS SELECT 
 1 AS `date`,
 1 AS `fiscal_year`,
 1 AS `customer_code`,
 1 AS `market`,
 1 AS `product_code`,
 1 AS `product`,
 1 AS `variant`,
 1 AS `sold_quantity`,
 1 AS `gross_price_per_item`,
 1 AS `gross_price_total`,
 1 AS `pre_invoice_discount_pct`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'gdb0041'
--

--
-- Dumping routines for database 'gdb0041'
--
/*!50003 DROP FUNCTION IF EXISTS `get_fiscal_quarter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_quarter`(calendar_date date) RETURNS char(2) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
declare qtr char(2);
declare fm tinyint;
set fm = month(calendar_date);
case
when fm in (09,10,11) then set qtr="Q1";
when fm in (12,01,02) then set qtr="Q2";
when fm in (03,04,05) then set qtr="Q3";
else set qtr="Q4";
end CASE;
RETURN qtr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_fiscal_year` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_fiscal_year`(
calendar_date date
) RETURNS int
    DETERMINISTIC
BEGIN
	declare fiscal_year int;
	set fiscal_year=year(date_add(calendar_date, interval 4 month));
return fiscal_year;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_forecast_accuracy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_market_badge` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_monthly_gross_sales_for_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_n_customers_by_net_sales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_customers_by_net_sales`(
in_fiscal_year int,
in_top_n int,
in_market varchar(45)
)
BEGIN
	select
	c.customer,
	round(sum(net_sales)/1000000, 2) as net_sales_mln
	from net_sales s
	join dim_customer c
	on
	s.customer_code=c.customer_code
	where s.fiscal_year=in_fiscal_year
    and s.market=in_market
	group by c.customer
	order by net_sales_mln desc
	limit in_top_n;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_n_markets_by_net_sales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_n_markets_by_net_sales`(
in_fiscal_year int,
in_top_n int
)
BEGIN
	select
	market,
	round(sum(net_sales)/1000000, 2) as net_sales_mln
	from net_sales n
	where fiscal_year=in_fiscal_year
	group by market
	order by net_sales_mln desc
	limit in_top_n;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_n_markets_per_region_by_gross_sales_amount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_n_products_by_net_sales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_n_products_per_division_by_qty_sold` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `gross_sales`
--

/*!50001 DROP VIEW IF EXISTS `gross_sales`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `gross_sales` AS select `s`.`date` AS `date`,`s`.`fiscal_year` AS `fiscal_year`,`s`.`customer_code` AS `customer_code`,`c`.`customer` AS `customer`,`c`.`market` AS `market`,`s`.`product_code` AS `product_code`,`p`.`product` AS `product`,`p`.`variant` AS `variant`,`s`.`sold_quantity` AS `sold_quantity`,`g`.`gross_price` AS `gross_price_per_item`,round((`g`.`gross_price` * `s`.`sold_quantity`),2) AS `gross_price_total` from (((`fact_sales_monthly` `s` join `fact_gross_price` `g` on(((`s`.`product_code` = `g`.`product_code`) and (`s`.`fiscal_year` = `g`.`fiscal_year`)))) join `dim_product` `p` on((`s`.`product_code` = `p`.`product_code`))) join `dim_customer` `c` on((`s`.`customer_code` = `c`.`customer_code`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `net_sales`
--

/*!50001 DROP VIEW IF EXISTS `net_sales`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `net_sales` AS select `sales_postinv_discount`.`date` AS `date`,`sales_postinv_discount`.`fiscal_year` AS `fiscal_year`,`sales_postinv_discount`.`customer_code` AS `customer_code`,`sales_postinv_discount`.`market` AS `market`,`sales_postinv_discount`.`product_code` AS `product_code`,`sales_postinv_discount`.`product` AS `product`,`sales_postinv_discount`.`variant` AS `variant`,`sales_postinv_discount`.`sold_quantity` AS `sold_quantity`,`sales_postinv_discount`.`gross_price_total` AS `gross_price_total`,`sales_postinv_discount`.`pre_invoice_discount_pct` AS `pre_invoice_discount_pct`,`sales_postinv_discount`.`net_invoice_sales` AS `net_invoice_sales`,`sales_postinv_discount`.`post_invoice_discount_pct` AS `post_invoice_discount_pct`,round(((1 - `sales_postinv_discount`.`post_invoice_discount_pct`) * `sales_postinv_discount`.`net_invoice_sales`),2) AS `net_sales` from `sales_postinv_discount` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `sales_postinv_discount`
--

/*!50001 DROP VIEW IF EXISTS `sales_postinv_discount`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `sales_postinv_discount` AS select `s`.`date` AS `date`,`s`.`fiscal_year` AS `fiscal_year`,`s`.`customer_code` AS `customer_code`,`s`.`market` AS `market`,`s`.`product_code` AS `product_code`,`s`.`product` AS `product`,`s`.`variant` AS `variant`,`s`.`sold_quantity` AS `sold_quantity`,`s`.`gross_price_total` AS `gross_price_total`,`s`.`pre_invoice_discount_pct` AS `pre_invoice_discount_pct`,round(((1 - `s`.`pre_invoice_discount_pct`) * `s`.`gross_price_total`),2) AS `net_invoice_sales`,(`po`.`discounts_pct` + `po`.`other_deductions_pct`) AS `post_invoice_discount_pct` from (`sales_preinv_discount` `s` join `fact_post_invoice_deductions` `po` on(((`s`.`date` = `po`.`date`) and (`s`.`product_code` = `po`.`product_code`) and (`s`.`customer_code` = `po`.`customer_code`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `sales_preinv_discount`
--

/*!50001 DROP VIEW IF EXISTS `sales_preinv_discount`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `sales_preinv_discount` AS select `s`.`date` AS `date`,`s`.`fiscal_year` AS `fiscal_year`,`s`.`customer_code` AS `customer_code`,`c`.`market` AS `market`,`s`.`product_code` AS `product_code`,`p`.`product` AS `product`,`p`.`variant` AS `variant`,`s`.`sold_quantity` AS `sold_quantity`,`g`.`gross_price` AS `gross_price_per_item`,round((`s`.`sold_quantity` * `g`.`gross_price`),2) AS `gross_price_total`,`pre`.`pre_invoice_discount_pct` AS `pre_invoice_discount_pct` from ((((`fact_sales_monthly` `s` join `dim_customer` `c` on((`s`.`customer_code` = `c`.`customer_code`))) join `dim_product` `p` on((`s`.`product_code` = `p`.`product_code`))) join `fact_gross_price` `g` on(((`g`.`fiscal_year` = `s`.`fiscal_year`) and (`g`.`product_code` = `s`.`product_code`)))) join `fact_pre_invoice_deductions` `pre` on(((`pre`.`customer_code` = `s`.`customer_code`) and (`pre`.`fiscal_year` = `s`.`fiscal_year`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-31 20:43:31
