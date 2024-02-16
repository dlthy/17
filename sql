create table manager
(
	manager_id INT primary key,
	user_name varchar(20) unique,
	first_name varchar(50),
	last_name varchar(50) default 'no info',
	date_of_birth date,
	address_id int
);
drop table manager;
-- truy vấn dữ liệu lấy ra danh sách khách hàng và địa chỉ tương ứng
-- sau đó lưu thông tin vào bảng đặt tên là customer_info
create table customer_info as (
select customer_id, 
first_name||last_name as full_name,
email, b.address
from customer as A
join address as B on A.address_id = B.address_id);
select*from customer_info
-- chỉ user sử dụng được/tạo bảng tạm thời trong phiên làm việc, không tồn tại sau khi thoát ra
create temp table tmp_customer_info as (
select customer_id, 
first_name||last_name as full_name,
email, b.address
from customer as A
join address as B on A.address_id = B.address_id);
select * from tmp_customer_info;
--nhiều ông có thể truy cập, chạy câu lệnh làm như thông thường
create global temp table tmp_customer_info as (
select customer_id, 
first_name||last_name as full_name,
email, b.address
from customer as A
join address as B on A.address_id = B.address_id);
select * from tmp_customer_info;
--CTE: muốn chạy câu lệnh phải bôi đen hết
with tmp_customer_info as (
select customer_id, 
first_name||last_name as full_name,
email, b.address
from customer as A
join address as B on A.address_id = B.address_id);
select * from tmp_customer_info;
--Hạn chế: chỉ tạo tại thời điểm tạo ra, dữ liệu update nhưng bảng ko update theo
-- tạo bảng ảo: create view
create or replace view view_customer_info as (-- cập nhật thay đổi bảng
select customer_id, 
first_name||last_name as full_name,
email, b.address, a.active
from customer as A
join address as B on A.address_id = B.address_id);
select*from view_customer_info;
drop view view_customer_info;
/*Challenge: 
Tạo view có tên movie_category hiển thị danh sách các phim bao gồm: title, length,
category_name được sắp xếp giảm dần theo length
Lọc kết quả để chỉ những danh mục 'Action' và 'Comedy',...*/
create or replace view movie_category as (
select a.title, a.length, c.name as category_name
from film a
join public.film_category b on a.film_id = b.film_id
join public.category c on c.category_id = b.category_id);
select * from movie_category
where category_name in ('Action','Comedy')
order by length desc
--ALTER TABLE
--add, delete columns
alter table manager
drop first_name;
select * from manager;
alter table manager
add column first_name varchar(50);
select * from manager
--rename columns
alter table manager
rename column first_name to ten_KH;
select*from manager
--Alter data type
alter table manager
alter column ten_KH type text
--DML: INSERT, UPDATE, DELETE, TRUNCATE
--insert: chèn thêm
insert into city 
values 
(1001,'B','33', '2020-01-02 16:10:20');
select * from city 
where city_id = 1000;

insert into city (city, country_id)
values ('C',44);
select * from city 
where city = 'C';
--Update: sửa
update city 
set country_id = 100
where city_id = 3;
select*from city where city_id = 3;
/*Challenge: 
Viết truy vấn trả về tên KH, quốc gia,số lượng thanh toán mà họ có
sau đó tạo bảng xếp hạng những KH có doanh thu cao nhất cho mỗi quốc gia
lọc kết quả chỉ 3 KH hàng đầu của mỗi QG */
/*Challenge: 
1. Update giá cho thuê film 0.99 thành 1.99
2. Điều chỉnh bảng customer như sau
- Thêm cột initials (data type varchar(10))
- Update dữ liệu vào cột initials. Ex: Frank Smith should be F.S */
update film 
set rental_rate = 1.99
where rental_rate = 0.99 ;
select*from film
where rental_rate = 1.99 ;

alter table customer 
add column initials varchar(10);
select*from customer
update customer
set initials = left(first_name,1)||'.'||left(last_name,1)
--Delete, truncate
insert into manager
values
(1, 'HAPT', 'Tran', '1997-01-01',20, 'Ha'),
(2, 'NGANDP','Doan','1987-01-01',12,'Ngan'),
(3,'DUNGHT', 'Hoang','1991-02-10',19,'Thao');
select*from manager;
delete from manager --xóa hết bảng, quét từ đàu đến cuối
where manager_id = 1
--
truncate table manager -- xóa hết mà không quét
