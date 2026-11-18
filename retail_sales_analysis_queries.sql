-- ============================================================
-- RETAIL SALES ANALYSIS
-- Database: retail_sale_project
-- Table: sales
-- Tool: MySQL Workbench
-- Description: SQL queries for exploring retail sales,
-- customer behaviour, revenue, and product category performance.
-- ============================================================

USE retail_sale_project;

-- Q1. Find the total revenue.
SELECT SUM(total_sale) AS total_revenue
FROM sales;

-- Q2. Count the total number of transactions.
SELECT COUNT(*) AS total_transactions
FROM sales;

-- Q3. Count the number of unique customers.
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM sales;

-- Q4. Display all unique product categories.
SELECT DISTINCT category
FROM sales;

-- Q5. Find total revenue for each category.
SELECT
    category,
    SUM(total_sale) AS total_revenue
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;

-- Q6. Find the average sales amount.
SELECT AVG(total_sale) AS average_sales
FROM sales;

-- Q7. Find total sales by gender.
SELECT
    gender,
    SUM(total_sale) AS total_sales
FROM sales
GROUP BY gender;

-- Q8. Count transactions in each category.
SELECT
    category,
    COUNT(*) AS total_transactions
FROM sales
GROUP BY category
ORDER BY total_transactions DESC;

-- Q9. Find the top 5 customers by total spending.
SELECT
    customer_id,
    SUM(total_sale) AS total_spent
FROM sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- Q10. Find the highest individual sale.
SELECT MAX(total_sale) AS highest_sale
FROM sales;

-- Q11. Find monthly revenue.
SELECT
    MONTHNAME(sale_date) AS month,
    SUM(total_sale) AS monthly_revenue
FROM sales
GROUP BY MONTH(sale_date), MONTHNAME(sale_date)
ORDER BY MONTH(sale_date);

-- Q12. Find total profit by category.
SELECT
    category,
    SUM(total_sale - cogs) AS total_profit
FROM sales
GROUP BY category
ORDER BY total_profit DESC;

-- Q13. Find customers who made more than 5 transactions.
SELECT
    customer_id,
    COUNT(*) AS total_transactions
FROM sales
GROUP BY customer_id
HAVING COUNT(*) > 5
ORDER BY total_transactions DESC;

-- Q14. Find each customer's average spending per transaction.
SELECT
    customer_id,
    AVG(total_sale) AS average_spending
FROM sales
GROUP BY customer_id
ORDER BY average_spending DESC;

-- Q15. Find the category with the highest quantity sold.
SELECT
    category,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY category
ORDER BY total_quantity DESC
LIMIT 1;

-- Q16. Find customers whose total spending is above
-- the average total spending per customer.
SELECT
    customer_id,
    SUM(total_sale) AS total_spending
FROM sales
GROUP BY customer_id
HAVING SUM(total_sale) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(total_sale) AS customer_total
        FROM sales
        GROUP BY customer_id
    ) AS customer_spending
)
ORDER BY total_spending DESC;

-- Q17. Find the second-highest distinct individual sale.
SELECT MAX(total_sale) AS second_highest_sale
FROM sales
WHERE total_sale < (
    SELECT MAX(total_sale)
    FROM sales
);

-- Q18. Rank categories by total revenue.
SELECT
    category,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS category_rank
FROM (
    SELECT
        category,
        SUM(total_sale) AS total_revenue
    FROM sales
    GROUP BY category
) AS category_sales;

-- Q19. Find the top 3 customers with the highest number
-- of transactions.
SELECT
    customer_id,
    COUNT(*) AS total_transactions
FROM sales
GROUP BY customer_id
ORDER BY total_transactions DESC
LIMIT 3;

-- Q20. Calculate each category's percentage contribution
-- to total revenue.
SELECT
    category,
    SUM(total_sale) AS category_revenue,
    ROUND(
        SUM(total_sale) * 100.0 /
        (SELECT SUM(total_sale) FROM sales),
        2
    ) AS revenue_percentage
FROM sales
GROUP BY category
ORDER BY revenue_percentage DESC;
