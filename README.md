# SQL Data Analysis: Bike Store Relational Database

![MySQL](https://img.shields.io/badge/mysql-4479A1.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Kaggle](https://img.shields.io/badge/Kaggle-035a7d?style=for-the-badge&logo=kaggle&logoColor=white)


## Project Overview
This project provides a comprehensive analysis of sales data for a bike store using SQL. The primary goal is to extract key business insights from a relational database, focusing on sales performance, product trends, and customer behavior.

## Problem Statement & Key Questions
The analysis addresses the following core business questions:
1. **Sales Performance Analysis:** Which store has the highest total sales revenue? What are the monthly sales trends? Which staff member is the top performer?
2. **Product & Inventory Analysis:** Which products are the most popular, and from which categories and brands? Are there any products with low stock?
3. **Customer Analysis:** Who are the top 5 most valuable customers based on spending? From which regions do most customers come?

## Dataset
The dataset used is a [relational database for a bike store](https://www.kaggle.com/datasets/dillonmyrick/bike-store-sample-database/data?select=customers.csv), comprising 9 interconnected tables. The tables contain information on sales transactions, products, brands, stores, staff, and customers.

![Bike Store ERD](https://www.googleapis.com/download/storage/v1/b/kaggle-user-content/o/inbox%2F4146319%2Fc5838eb006bab3938ad94de02f58c6c1%2FSQL-Server-Sample-Database.png?generation=1692609884383007&alt=media)

## Tools Used
- **Database:** MySQL
- **Client:** MySQL Workbench
- **Language:** Structured Query Language (SQL)

## Analysis & Key Findings
###  1. Sales Performance Analysis
#### Best Performing Store
```sh
SELECT
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_income
FROM sales.stores AS s
JOIN sales.orders AS o
    ON s.store_id = o.store_id
JOIN sales.order_items AS oi 
    ON o.order_id = oi.order_id
GROUP BY
    s.store_name
ORDER BY
    total_income DESC;
```
##### Analysis & Findings

![Which store has the highest total sales revenue](https://github.com/NenaWorksLab/SQL-Data-Analysis-Bike-Store-Relational-Database/blob/main/Result/1.1%20Which%20store%20has%20the%20highest%20total%20sales%20revenue.png?raw=true)

>Based on the analysis, Baldwin Bikes is the store with the highest revenue. This finding indicates that this store's sales strategy and location are highly effective.



#### Monthly Sales Trends
```sh
SELECT
    YEAR(o.order_date) AS Year,
    MONTH(o.order_date) AS Month,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS monthly_sales_total
FROM sales.orders AS o
JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY
    YEAR(o.order_date),
    MONTH(o.order_date)
    DESC;
```
##### Analysis & Findings

![are the monthly sales trends](https://github.com/NenaWorksLab/SQL-Data-Analysis-Bike-Store-Relational-Database/blob/main/Result/1.2%20are%20the%20monthly%20sales%20trends.png?raw=true)

>Sales trend analysis shows that September was the peak month of sales in 2016, which was likely influenced by seasonal factors.

#### Staff Performance

```sh
npm install --production
SELECT
    st.first_name,
    st.last_name,
    COUNT(o.order_id) AS total_orders_processed,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_income
FROM sales.staffs AS st
JOIN sales.orders AS o
	ON st.staff_id = o.staff_id
JOIN sales.order_items AS oi
	ON o.order_id = oi.order_id
GROUP BY 
	st.staff_id,
    st.first_name,
    st.last_name
ORDER BY total_orders_processed DESC;
```
##### Analysis & Findings

![Which staff member is the top performer](https://github.com/NenaWorksLab/SQL-Data-Analysis-Bike-Store-Relational-Database/blob/main/Result/1.3%20%20Which%20staff%20member%20is%20the%20top%20performer.png?raw=true)

> Marcelene is the employee who handles the most orders, amounting to 1615 orders.

###  2. Product & Inventory Analysis
#### Most Popular Products

```sh
SELECT 
	p.product_name,
    c.category_name,
    b.brand_name,
    SUM(oi.quantity) AS total_sales
FROM production.products AS p
JOIN production.categories AS c
	ON p.category_id = c.category_id
JOIN production.brands as b 
	ON p.brand_id = b.brand_id
JOIN sales.order_items AS oi
	ON p.product_id = oi.product_id
GROUP BY 
	p.product_name,
    c.category_name,
    b.brand_name
ORDER BY
	total_sales DESC
LIMIT 10;
```

##### Analysis & Findings

![Which products are the most popular, and from which categories and brandsr](https://github.com/NenaWorksLab/SQL-Data-Analysis-Bike-Store-Relational-Database/blob/main/Result/2.1%20Which%20products%20are%20the%20most%20popular,%20and%20from%20which%20categories%20and%20brands.png?raw=true)

> Products from the Mountain Bikes category and the Surly brand are the best-selling, indicating high popularity among customers.

#### Product Availability

```sh
SELECT 
	p.product_name,
    s.store_name,
	st.quantity AS stok
FROM production.stocks AS st
JOIN production.products AS p 
	ON st.product_id = p.product_id
JOIN sales.stores AS s
	ON s.store_id = st.store_id
WHERE 
	st.quantity < 5
ORDER BY 
	st.quantity ASC;
	
	SELECT
    COUNT(*) AS total_p
FROM production.stocks AS st
JOIN production.products AS p
    ON st.product_id = p.product_id
WHERE
    st.quantity < 5;
```

##### Analysis & Findings

![Are there any products with low stock 5 unit](https://github.com/NenaWorksLab/SQL-Data-Analysis-Bike-Store-Relational-Database/blob/main/Result/2.1%20Which%20products%20are%20the%20most%20popular,%20and%20from%20which%20categories%20and%20brands.png?raw=true)

![Are there any products with low stock 5 unit](https://github.com/NenaWorksLab/SQL-Data-Analysis-Bike-Store-Relational-Database/blob/main/Result/2.2.2.png?raw=true)

> There are 166 products that are low on inventory (less than 5 units) in some stores. The company must immediately replenish these stocks to avoid lost sales.

###  3. Customer Analysis
#### Most Valuable Customers
```sh
SELECT 
	c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_sales
FROM sales.customers AS c 
JOIN sales.orders AS o 
	ON c.customer_id = o.customer_id
JOIN sales.order_items AS oi 
	ON o.order_id = oi.order_id
GROUP BY 
	 c.customer_id,
    c.first_name,
    c.last_name
ORDER BY 
	total_sales DESC
LIMIT 5; 
```

##### Analysis & Findings

![ Who are the top 5 most valuable customers based on spending](https://github.com/NenaWorksLab/SQL-Data-Analysis-Bike-Store-Relational-Database/blob/main/Result/3.1.%20Who%20are%20the%20top%205%20most%20valuable%20customers%20based%20on%20spending.png?raw=true)

> The top five customers, like Sharyn Hopkins, have contributed $34,807 of total revenue. Loyalty programs can be focused on this customer segment.

#### Customer Regions
```sh
SELECT
	state,
    city,
    COUNT(*) AS total_customer
FROM sales.customers
GROUP BY 
	state,
    city
ORDER BY total_customer DESC;
```
##### Analysis & Findings

![ From which regions do most customers come](https://github.com/NenaWorksLab/SQL-Data-Analysis-Bike-Store-Relational-Database/blob/main/Result/3.%202.%20From%20which%20regions%20do%20most%20customers%20come.png?raw=true)

> the majority of customers come from Mount Vernon, accounting for 20 consumers. This indicates that the store has a strong customer base in that specific city.

## Conclusion
###  1. Sales Performance Analysis

| What Was Found(WHAT)| Implications / Why (SO WHAT) | Recommendations (NOW WHAT)|
| ------ | ------ | ------ |
| Baldwin Bikes store is the store with the highest sales| Baldwin Bikes store is at the top of the bicycle market | learn more about why baldwin bikes can sell better and apply to low-performing stores |
| The highest sales in the year range were around 2016 - 2017 but the peak was in 2016 in the 9th month | This sales peak indicates a strong seasonal trend. The months around September experience particularly high demand | Management needs to prepare special promotional campaigns for peak sales months |
| Marcelene is the employee who handles the most orders, amounting to 1,615 orders | Marcelene is one of the team's valuable assets and could possibly serve as a mentor | give Marcelene incentives and provide training to other employees so they can work better |

###  2. Product & Inventory Analysis
| What Was Found(WHAT)| Implications / Why (SO WHAT) | Recommendations (NOW WHAT)|
| ------ | ------ | ------ |
| The best-selling product is the mountain bike with the Surly brand | The high sales of this product indicate very strong market demand. Maintaining adequate stock is key to preventing potential revenue loss and maintaining customer satisfaction | Businesses should prioritize and increase order quantities for Surly brand Mountain Bikes from suppliers. Additionally, consider running cross-promotional campaigns with relevant accessories for this product |
| There are 166 types of goods that have stock of under 5 units  | These low stock levels represent a significant potential for lost sales and customer dissatisfaction. This indicates that inventory management or the supply chain may be inefficient | Businesses should immediately prioritize replenishing these 166 products. Furthermore, a thorough analysis should be conducted to identify the cause of the low stock (e.g., unexpected demand or shipping delays) to prevent similar issues in the future |

###  3. Customer Analysis
| What Was Found(WHAT)| Implications / Why (SO WHAT) | Recommendations (NOW WHAT)|
| ------ | ------ | ------ |
| there are 5 top customers with purchase amounts from $31,925 to $34,807 and customer number 1 is sharyn Hopkins | The significant revenue contribution of these small numbers of customers demonstrates that they are the foundation of a business's revenue. Maintaining their satisfaction and loyalty is crucial to long-term success | Set up a loyalty program: Create a special program or offer personalized discounts to encourage repeat orders and increase customer retention|
| the most customers come from Mount Vernon with 20 customers | This high concentration of customers indicates that the city is a very strong and vital market for business | Businesses should focus their marketing and promotional efforts in the Mount Vernon area to further strengthen market share. Furthermore, it's important to evaluate the city's success factors to replicate those strategies in other cities |


## Contribution
This project was developed by **Nenna Khoirunnisa** as a self-initiated learning and portfolio endeavor.

* **GitHub:** [github.com/NenaWorksLab](https://github.com/NenaWorksLab)
* **LinkedIn:** [linkedin.com/in/nenna-khoirunnisa](https://www.linkedin.com/in/nenna-khoirunnisa-4852101b4/)


