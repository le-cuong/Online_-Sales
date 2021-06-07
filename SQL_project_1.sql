
use project_1;
/* so sanh doanh thu va loi nhuan theo thang*/
select (sales) as doanh_thu, left(round((profit),4),8) as loi_nhuan, left(order_date,7) as ngay_mua 
into ss_ln_dt_tháng from Orders 
group by year(order_date),MONTH(ORDER_DATE)
order by year(order_date),month(order_date);


select*from ss_ln_dt_tháng1 order by month(ngay_mua) asc;

/* so sánh doanh thu và lợi nhuận theo năm*/
select sum(sales) as doanh_thu, left(round(sum(profit),4),8) as loi_nhuan, year(order_date) as thoigian_muaban 
into ss_ln_dt_năm from Orders 
group by year(order_date)
order by year(order_date);

/* so sánh doanh thu và lợi nhuận 2017 */
select sum(sales) as doanh_thu, left(round(sum(profit),4),8) as loi_nhuan, concat(year(order_date),'-',month(order_date)) as ngay_mua 
into ss_ln_dt_2017 from Orders 
where year(order_date)=2017
group by year(order_date),month(order_date) 
order by month(order_date);

/* so sánh  doanh thu và lợi nhuận giữa các bang*/
select states,sum(sales)  doanhthu,sum(profit)  loinhuan, (sum(profit)/sum(sales)) as ty_le_ln
into dt_ln_state from orders where year(order_date)=2017 group by states;

/* doanh thu theo loại sản phẩm*/
select category, sum(sales) as doanh_thu into dt_moi_loai from orders
where year(order_date)=2017 group by category;

select*from orders;

/* thời gian ship trung bình của từng loại*/
select ship_mode,avg(datediff(day,order_date,ship_date)) as ngay into ngay_ship_tb from orders group by ship_mode;


/* thời gian ship trung bình tới từng vùng*/
select Region,avg(datediff(day,order_date,ship_date)) as ngay into ngay_ship_tb_khuvuc from orders group by region;
select Region,avg(datediff(day,order_date,ship_date)) as ngay  from orders group by region;

/* đặt primary*/
alter table returns1 alter column order_id varchar(14) not null;
alter table returns1 add primary key(order_id);

alter table orders alter column row_id int not null;
alter table orders alter column order_id varchar(255) not null;

alter table orders add constraint pk_order primary key(row_id,order_id);

/* số sản phẩm được trả lại*/ 
select category,count(returns1.order_id) as dem into sp_tra_loai 
from returns1 inner join orders on returns1.order_id=orders.order_id group by category;

/* sp được tả lại theo bang*/
select states,count(returns1.order_id) so_luong into sp_tra_bang from returns1 inner join orders on returns1.order_id=orders.order_id group by States;

alter table orders alter column region varchar(255) not null;
alter table orders drop constraint pk_order;
alter table orders add constraint pk_new primary key (row_id,order_id,region);

/* số lượng các khu do nhân viên phụ trách*/
select people.person,count(orders.region) as so_luong_don into slg_kv from people right join orders on people.region=orders.region 
group by people.person;

/* số lượng sản phẩm nhân viên xử lý theo từng khu vực*/
select people.person,count(orders.region) as so_luong_sp into slg_spkv from people right join orders on people.region=orders.region 
group by people.person;

select distinct region,order_id from orders;
/* mỗi nhân viên làm việc với số khách hàng*/
select people.person ,count(kv.order_id) as so_kh into nv_kh from people inner join (select distinct region,order_id from orders) kv 
on kv.region=people.region group by people.person;