
create table student(
	id int primary key,
	name varchar(50),
	age int not null
);


insert into student values(1, 'Umer', 17);
insert into student values(2, 'Hasan', 18);
-- OR
insert into student values
(3, 'Sharjeel', 21);
update student 
set name = "Muhammad Hasan Alam" where name = "Hasan";

select * from student;
drop table payment;
create table payment(
	customer_id int primary key,
    customer varchar(50),
    mode varchar(50),
    city varchar(50)
);
insert into payment values
(101, "Olivia Barrete", "Netbanking", "Portland"),
(102, "Ethan Sinclair", "Credit card", "Miami"),
(103, "Maya  Harnandaz", "Credit card", "Seattle"),
(104, "Liam Donovan", "Netbanking", "Denver"),
(105, "Sophia Nguyen", "Credit Card", "New Orleans"),
(106, "Caleb Foster", "Debit Card", "Minneapolis"),
(107, "Ava Patel", "Debit Card", "Pheonix"),
(108, "Lucas Carter", "Netbanking", "Boston"),
(109, "Isabella Martinez", "Netbanking", "Nashvile"),
(110, "Jackson Brooks", "Credit card", "Boston");
select * from payment;
-- find the total payment according to each payment method
select mode,  count(customer)
from payment
group by mode;
-- For turning off safe mode/ for on set "1" 
SET SQL_SAFE_UPDATES = 0;

create table dept(
	id int primary key,
    name varchar(50)
);
insert into dept values(101, "English"), (102, "Information Technology");

create table teacher(
	id int primary key,
    name varchar(50),
    dep_id int,
    foreign key (dep_id) references dept(id)
    on delete cascade 
    on update cascade
);
insert into teacher values(101, "Adam", 101), (102, "Eve", 102);
select * from dept;
select * from teacher;


create table student(
	id int primary key,
    name varchar(10),
    marks int not null,
    grade varchar(2),
    city varchar(10)
);
insert into student values
(101, "Anil", 78, "C", "Pune"),
(102, "Bhumika", 93, "A", "Mumbai"),
(103, "Chetan", 85, "A", "Mumbai"),
(104, "Dhruv", 96, "A", "Dehli"),
(105, "Emanuel", 12, "F", "Dehli"),
(106, "Anil", 78, "C", "Dehli"); 
select * from student;
drop table student;
alter table student
change name full_name varchar(50);

delete from student where marks < 80;
alter table student drop grade;
select * from student;


-- Join
create table students(
	student_id int primary key,
    name varchar(10)
);
insert into students values
(101, "Adam"),
(102, "Bob"),
(103, "Casey");
create table course(
	student_id int primary key,
    course varchar(50)
);
insert into course values
(102, "English"),
(105, "Maths"),
(103, "Science"),
(104, "Computer Science");

-- Inner join is used to join two table and return common values from both table
select * from students as s inner join course as b on s.student_id = b.student_id;
-- left join is use to join two table and it returns all record from left table and the matched records from the right table
select * from students as s left join course as b on s.student_id = b.student_id; 
-- right join is use to join two table and it returns all record from right table and the matched records from the left table
select * from students as s right join course as b on s.student_id = b.student_id; 
-- Full join returns all records when there is a match in either  left or right table / using union
select * from students as s left join course as b on s.student_id = b.student_id
union
select * from students as s right join course as b on s.student_id = b.student_id;
-- left exclusive join
select * from students as s left join course as b on s.student_id = b.student_id where b.student_id is null;
-- right exclusive join
select * from students as s right join course as b on s.student_id = b.student_id where s.student_id is null;

-- Sub Queries
select * from student;
-- (select avg(marks) from student) = 87.667
select full_name from student where marks > (select avg(marks) from student);
-- 
select full_name, id from student where id in (select id from student where id % 2 = 0);
-- 
select  max(marks) from (select * from student where city = 'Dehli') as temp;

-- views -> virtual table
create view view1 as select name, city from student;
select * from view1 where city = "Dehli";