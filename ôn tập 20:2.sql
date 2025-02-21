-- 2
-- 2.1
create database quanlybanhang;

-- 2.2
use quanlybanhang;

create table Customers(
	customer_id int primary key auto_increment,
    customer_name varchar(100) not null,
    phone varchar(20) not null unique,
    address varchar(255)
);

create table Products(
	product_id int primary key auto_increment,
    product_name varchar(100) not null,
    price decimal(10,2) not null,
	quantity int not null 
    check (quantity >= 0),
    category varchar(50) not null
);

create table Employees(
	employee_id int primary key auto_increment,
    employee_name varchar(100) not null,
    birthday date ,
    position varchar(50) not null,
    salary decimal(10,2) not null,
    revenue decimal(10,2) default 0
);

create table Orders(
	order_id int primary key auto_increment,
    customer_id int,
    foreign key (customer_id) references Customers(customer_id),
    employee_id int,
    foreign key (employee_id) references Employees(employee_id),
    order_date datetime default current_timestamp,
    total_amount decimal(15,2) default 0
);

create table OrderDetails(
	order_detail_id int primary key auto_increment,
    order_id int,
    foreign key (order_id) references Orders(order_id),
    product_id int,
    foreign key (product_id) references Products(product_id),
    quantity int not null,
    check (quantity > 0),
    unit_price decimal(10,2) not null
);

-- 3

-- 3.1
alter table Customers
add column email varchar(100) not null unique;

-- 3.2
alter table Employees
drop column birthday;

-- Phan 2

-- 4
insert into Customers (customer_name,phone,address,email)
values 
('Văn A', '0987654325', 'HN', 'vana@gmail.com'),
('Thị B', '0974732724', 'TN','thib@gmail.com'),
('Trần C', '0856361468', 'ĐN','tranc@gmail.com'),
('Diên D', '0393782485', 'TH','diend@gmail.com'),
('Huy E', '0787234626', 'VP', 'huye@gmail.com');

insert into Products (product_name,price,quantity,category)
values
('Máy Tính MacPro', 99999999, 9 , 'Máy Tính'),
('Iphone 16', 40111, 4,  'Điện Thoại'),
('Sách Đắc Nhân Tâm', 120, 12,'Sách'),
('Áo polo cho nam giới', 300, 5, 'Thời Trang Nam'),
('Đồng hồ Rolex', 3344242, 2, 'Đồng Hồ');

insert into Employees (employee_name,position,salary)
values
('Tiến' ,'Kế Toán',15000000),
('Đoan', 'Saler',12000000),
('Dương', 'Bảo vệ',7000000),
('Hoàng' , 'Lao Công',5000000),
('Nghĩa',  'Trưởng phòng kinh doanh',25000000);

INSERT INTO Orders (customer_id, employee_id, order_date, total_amount) VALUES
(1, 2, '2024-02-01 10:00:00', 100000239),
(2, 3, '2024-02-02 11:30:00', 41011),
(3, 1, '2024-02-03 14:00:00', 3424464),
(4, 5, '2024-02-04 16:20:00', 100000359),
(5, 4, '2024-02-05 18:45:00', 3344842);

INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 99999999),
(1, 3, 2, 120),
(2, 2, 1, 40111),
(2, 4, 3, 300),
(3, 5, 1, 3344242),
(3, 2, 2, 40111),
(4, 1, 1, 99999999),
(4, 3, 3, 120),
(5, 4, 2, 300),
(5, 5, 1, 3344242);

-- 5
-- 5.1

select customer_id as 'Mã Khách Hàng', customer_name as 'Tên khách hàng', 
email as Email, phone as 'Số điện thoại', address as 'Địa chỉ'
from Customers;

-- 5.2
update Products
set product_name = 'Laptop Dell XPS' , price = 99.99
where product_id = 1;

-- 5.3
select o.order_id as 'mã đơn hàng', c.customer_name as 'tên khách hàng', e.employee_name as 'tên nhân viên'
,o.total_amount as 'Tổng Tiền', order_date as 'Ngày đặt hàng'
from Orders o
join Customers c on o.customer_id = c.customer_id
join Employees e on o.employee_id = e.employee_id;

-- cau 6

-- 6.1
select c.customer_id as 'Mã khách hàng', c.customer_name as 'Tên khánh hàng',
count(o.customer_id) as 'Tổng số đơn'
from Orders o 
join Customers c on o.customer_id = c.customer_id
group by c.customer_id, c.customer_name;

-- 6.2
select e.employee_id as 'Mã nhân viên', e.employee_name as 'Tên Nhân viên', sum(o.total_amount) as 'Tong doanh thu'
from Orders o 
join Employees e on o.employee_id = e.employee_id
group by e.employee_id, e.employee_name;

-- 6.3
select p.product_id as 'Mã sản phẩm', p.product_name as 'Tên sản phẩm', 
       sum(od.quantity) as 'Số lượt đặt'
from OrderDetails od
join Products p on od.product_id = p.product_id
join Orders o on od.order_id = o.order_id
where month(o.order_date) = month(current_date()) and year(o.order_date) = year(current_date())
group by p.product_id, p.product_name
having sum(od.quantity) > 100
order by sum(od.quantity) desc;

-- 7.1
select c.customer_id as 'Mã khách hàng', c.customer_name as 'Tên khách hàng'
from Customers c
left join Orders o on c.customer_id = o.customer_id
where o.order_id is null;

-- 7.2
select product_id as 'Mã sản phẩm', product_name as 'Tên sản phẩm', price as 'Giá'
from Products
where price > (select avg(price) from Products);

-- 7.3
select c.customer_id as 'Mã khách hàng', c.customer_name as 'Tên khách hàng', sum(o.total_amount) as 'Tổng chi tiêu'
from Orders o
join Customers c on o.customer_id = c.customer_id
group by c.customer_id, c.customer_name
having sum(o.total_amount) = (select max(total_spent) from 
                              (select sum(total_amount) as total_spent from Orders group by customer_id) t);

-- 8.1
create view view_order_list as
select o.order_id as 'Mã đơn hàng', c.customer_name as 'Tên khách hàng', 
       e.employee_name as 'Tên nhân viên', o.total_amount as 'Tổng tiền', o.order_date as 'Ngày đặt'
from Orders o
join Customers c on o.customer_id = c.customer_id
join Employees e on o.employee_id = e.employee_id
order by o.order_date desc;

-- 8.2
create view view_order_detail_product as
select od.order_detail_id as 'Mã chi tiết đơn hàng', p.product_name as 'Tên sản phẩm', 
       od.quantity as 'Số lượng', od.unit_price as 'Giá tại thời điểm mua'
from OrderDetails od
join Products p on od.product_id = p.product_id
order by od.quantity desc;

-- 9.1
delimiter //
create procedure proc_insert_employee(
    in p_employee_name varchar(100),
    in p_position varchar(50),
    in p_salary decimal(10,2)
)
begin
    insert into Employees(employee_name, position, salary) values (p_employee_name, p_position, p_salary);
    select last_insert_id() as 'Mã nhân viên vừa thêm';
end //
delimiter ;

-- 9.2
delimiter //
create procedure proc_get_orderdetails(
    in p_order_id int
)
begin
    select * from OrderDetails where order_id = p_order_id;
end //
delimiter ;

-- 9.3
delimiter //
create procedure proc_cal_total_amount_by_order(
    in p_order_id int
)
begin
    select count(distinct product_id) as 'Số lượng loại sản phẩm' from OrderDetails where order_id = p_order_id;
end //
delimiter ;

-- 10
delimiter //
create trigger trigger_after_insert_order_details
after insert on OrderDetails
for each row
begin
    declare stock int;
    select quantity into stock from Products where product_id = NEW.product_id;
    if stock < NEW.quantity then
        signal sqlstate '45000' set message_text = 'Số lượng sản phẩm trong kho không đủ';
    else
        update Products set quantity = quantity - NEW.quantity where product_id = NEW.product_id;
    end if;
end //
delimiter ;

-- 11
delimiter //
create procedure proc_insert_order_details(
    in p_order_id int, in p_product_id int, in p_quantity int, in p_unit_price decimal(10,2)
)
begin
    declare order_exists int;
    start transaction;
    select count(*) into order_exists from Orders where order_id = p_order_id;
    if order_exists = 0 then
		rollback;
        signal sqlstate '45000' set message_text = 'Không tồn tại mã hóa đơn';
    else
        insert into OrderDetails(order_id, product_id, quantity, unit_price) 
        values (p_order_id, p_product_id, p_quantity, p_unit_price);
        update Orders set total_amount = total_amount + (p_quantity * p_unit_price) where order_id = p_order_id;
    end if;
    commit;
end //
delimiter ;







