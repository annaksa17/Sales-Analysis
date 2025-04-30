select * from `sql - retail sales analysis_utf`;

ALTER TABLE `sql - retail sales analysis_utf`
RENAME COLUMN ï»¿transactions_id  TO transactions_id;

ALTER TABLE`sql - retail sales analysis_utf`
RENAME TO retail_sales;

ALTER TABLE retail_sales
MODIFY transactions_id INT;

select * from retail_sales;

Alter table retail_sales
add primary key (transactions_id);

SHOW KEYS FROM retail_sales WHERE Key_name = 'PRIMARY';

-- record count
SELECT COUNT(*) FROM retail_sales;

-- unique customers are in the dataset
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- unique product categories in the dataset
select count( distinct category) from retail_sales;

SELECT * FROM retail_sales

WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales where sale_date ='2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail_sales where category='Clothing' 
and quantiy>=4 
and sale_date< '2022-12-01'
and sale_date>='2022-11-01';

DESCRIBE retail_sales;

Alter table retail_sales
modify sale_date date;

-- Write a SQL query to calculate the total sales (total_sale) for each category.:
select sum(total_sale),category from retail_sales group by category;

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select avg(age),category from retail_sales where category='Beauty';

select * from retail_sales;

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select transactions_id, total_sale from retail_sales where total_sale> 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select count(transactions_id), gender, category from retail_sales group by gender,category order by category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select avg_sale,mm,yyyy from
(select avg(total_sale) as avg_sale,mm, yyyy,
rank() over(partition by yyyy order by yyyy, avg_sale desc) as best
from retail_sales group by yyyy,mm) as t1
where best=1;


alter table retail_sales
add month char(50);

alter table retail_sales 
rename column year to yyyy;

alter table retail_sales
add year char(50);

alter table retail_sales
drop column month;

update retail_sales set month=monthname(sale_date);

update retail_sales set year=year(sale_date);

-- Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,sum(total_sale) from retail_sales group by customer_id  order by sum(total_sale) desc limit  5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.:
select count(distinct customer_id), category from retail_sales group by category;

-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
select * from retail_sales 

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;