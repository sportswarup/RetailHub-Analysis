SELECT * FROM Stores;
SELECT * FROM Employees;
SELECT * FROM Customers;
SELECT * FROM Categories;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
use RetailHub;
show tables;

#1.
select product_name, price from Products order by price desc;
#2.
select * from Customers where city = 'MUMBAI';
#3.
select employee_id, employee_name, hire_date from Employees where hire_date > '2024-01-01';
#4.
select product_id, product_name, price from Products where price between 500 and 2000 order by price asc;
#5.
select * from Customers where city = (select distinct city);
#6.
select * from Products where product_name like 's%';
#7.
select city, count(customer_name) as customer_count from Customers group by city;
#8.
select store_id, round(avg(salary)) as avg_salary from Employees group by store_id;
#9.
select c.category_name, count(*) as product_count
from Categories c
join Products p
on c.category_id = p.category_id
group by c.category_name
having count(*) > 100;
#10.
select product_id, quantity, sum(sales_amount) from OrderDetails group by product_id, quantity;
#11.
select store_id, avg(salary) over() from Employees where salary > 60000 group by store_id;

#12.
select city, count(*) from Customers group by city having count(city) > 5;
#13.
select c.customer_name, c.customer_id, o.order_id, p.product_name from Customers c 
join Orders o on c.customer_id = o.customer_id
join OrderDetails d on o.order_id = d.order_id
join Products p on d.product_id = p.product_id
group by c.customer_name, c.customer_id, o.order_id, p.product_name ;
#14.
select c.category_name, p.product_name, c.category_id, p.product_id from Categories c 
join Products p on c.category_id = p.category_id;
#15.
select e.employee_name, s.store_name from Employees e 
join Stores s on e.store_id = s.store_id
group by e.employee_name, s.store_name ;
#16.
select p.product_name, d.* from OrderDetails d
join Products p on d.product_id = p.product_id;
#17.
select e.employee_name, c.customer_name, o.order_date from Customers c
join Orders o on c.customer_id = o.customer_id
join Employees e on o.employee_id = e.employee_id;
#18.
select s.store_name, count(*) as employee_count from Employees e 
join Stores s on e.store_id = s.store_id
group by s.store_name;
#19.
select p.product_id, p.product_name from Products p
left join OrderDetails d on p.product_id = d.product_id
where d.order_id is null;
             #or
select * from Products where product_id not in (select product_id from OrderDetails);
#20
select distinct c.customer_id, c.customer_name from Customers c 
join Orders o on c.customer_id = o.customer_id;
#21.
select * from Products where price > (select avg(price) from Products);
#22.
select * from Employees where salary >( select avg(salary) from Employees);
#23.
select distinct c.* from Customers c
join Stores s on c.city = s.city;
#24.
select * from OrderDetails where sales_amount > ( select avg(sales_amount) from OrderDetails);
#25.
select p.category_id, c.category_name, max(price) from Products p 
join Categories c on p.category_id = c.category_id
group by category_id;
#26.
select o.customer_id, c.customer_name, count(o.order_id) as max_order_count from Orders o join OrderDetails d 
on o.order_id = d.order_id 
join Customers c 
on o.customer_id = c.customer_id 
group by o.customer_id, c.customer_name
having count(o.order_id) > (select avg(quantity) from OrderDetails);
#27.
select employee_id, employee_name, max(salary) as max_salary from Employees 
where salary > (select avg(salary) from Employees) group by employee_id, employee_name;
#28.
select c.category_name, sum(price) from Products p join Categories c
on p.category_id = c.category_id
group by c.category_name
having sum(price) > 100000;
#29.
with customer_sales as
(	select o.customer_id, sum(od.quantity * od.sales_amount) as total_sales
	from Orders o
	join OrderDetails od
	on o.order_id = od.order_id
	group by o.customer_id
)

select c.customer_id, c.customer_name, cs.total_sales
from Customers c
join Customer_sales cs
on c.customer_id = cs.customer_id;
#30.
with customer_sales as
(
    select o.customer_id, sum(od.quantity * od.sales_amount) as total_sales
    from Orders o
    join OrderDetails od
    on o.order_id = od.order_id
    group by o.customer_id
)

select c.customer_name, cs.total_sales
from customer_sales cs
join Customers c
on cs.customer_id = c.customer_id
order by cs.total_sales desc
limit 5;
#31.
with monthly_sales as
(
    select date_format(o.order_date,'%Y-%m') as month, sum(od.quantity * od.sales_amount) as total_sales
    from Orders o
    join OrderDetails od
    on o.order_id = od.order_id
    group by date_format(o.order_date,'%Y-%m')
)

select * from monthly_sales order by month;
#32.

#33.
select s.store_id, s.store_name, sum(sales_amount) as max_sales, avg(sales_amount) as avg_sales from OrderDetails d join Orders o 
on d.order_id = o.order_id
join Employees e
on o.employee_id = e.employee_id
join Stores s
on e.store_id = s.store_id
group by s.store_id, s.store_name
having sum(sales_amount) > avg(sales_amount);
#34
with recursive numbers as
(
    select 1 as number

    union all

    select number + 1
    from numbers
    where number < 12
)

select * from numbers;
#35
with monthly_sales as
(
    select
        date_format(o.order_date,'%Y-%m') as month,
        sum(od.quantity * od.unit_price) as sales
    from Orders o
    join Orderdetails od
    on o.order_id = od.order_id
    group by date_format(o.order_date,'%Y-%m')
)

select month, sales, sum(sales) over(order by month) as running_sales
from monthly_sales;
#36.
select *, rank() over(order by salary desc) as emp_rank from Employees;
#37.
select store_id, employee_id, employee_name, salary from
(select store_id, employee_id, employee_name, salary, row_number()
over( partition by store_id order by salary desc) as salary_rank from Employees) as ranked
where salary_rank <= 3 order by store_id, salary desc;
#38.
SELECT o.customer_id, o.order_date, o.order_id, d.sales_amount, sum(d.sales_amount) 
over(partition by o.customer_id order by o.order_date, o.order_id) as cumulative_sales
from Orders o join OrderDetails d 
on o.order_id = d.order_id
order by o.customer_id, o.order_date, o.order_id;
#39.
select customer_id, order_id, order_date,
lag(order_date) over (partition by customer_id order by order_date) as previous_order_date
from Orders;
#40.
select customer_id, order_id, order_date,
lead(order_date) over (partition by customer_id order by order_date) as next_order_date
from Orders;
#41.
select product_id, product_name, price, 
ntile(4) over(order by price) as price_quartile
from Products;
#42.
select employee_id, employee_name, store_id, salary,
avg(salary) over(partition by store_id) as average_salary, 
salary - avg(salary) over(partition by store_id) as salary_difference
from Employees;
#43.
select p.product_name,
    sum(od.quantity * od.sales_amount) as total_sales,
    round (sum(od.quantity * od.sales_amount) * 100 / sum(sum(od.quantity * od.sales_amount))
	over(), 2) as contribution_percentage
from Products p
join OrderDetails od
on p.product_id = od.product_id
group by p.product_id, p.product_name;
#44.
create view customer_total_sales as
select c.customer_id, c.customer_name,
sum(od.quantity * od.sales_amount) as total_sales
from Customers c
join Orders o
on c.customer_id = o.customer_id
join Orderdetails od
on o.order_id = od.order_id
group by c.customer_id, c.customer_name;
#45.
select *
from customer_total_sales
order by total_sales desc;
#46.
create view product_performance as
select p.product_id, p.product_name,
sum(od.quantity) as total_quantity_sold,
sum(od.quantity * od.sales_amount) as total_sales
from Products p
join OrderDetails od
on p.product_id = od.product_id
group by p.product_id, p.product_name;
#47.
select * from Orders
where month(order_date) = month(curdate())
and year(order_date) = year(curdate());
#48.
select employee_id, employee_name, hire_date,
timestampdiff(year, hire_date, curdate()) as tenure_years
from Employees;
#49.
select date_format(o.order_date,'%Y-%m') as month, sum(od.quantity * od.sales_amount) as total_sales
from Orders o
join OrderDetails od
on o.order_id = od.order_id
group by date_format(o.order_date,'%Y-%m')
order by month;
#50.
select * from Orders
where order_date >= date_sub(curdate(), interval 30 day);
