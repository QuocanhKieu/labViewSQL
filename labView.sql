create database LabView
use labView


create table Books (
	BookCode int primary key,
	Category varchar(50),
	Author varchar(50),
	Publisher varchar(50),
	Title varchar(50),
	Price int,
	InStore int
)

insert into Books values (1, 'Tieu Thuyet', 'Vu Trong Phung', 'Nxb Tre', 'Ky Nghe Lay Tay',  100, 100),
					     (2, 'Truyen Ngan', 'Nguyen Hong', 'Nxb Viet Nam', 'Chu Cho Con',  150, 140),
						 (3, 'Truyen Dai', 'Cao Ba Quat', 'Nxb Phu Nu', 'So Do',  170, 10),
						 (4, 'Tho', 'Son Tung', 'Nxb Giao Duc', 'Tho Tinh',  70, 180),
						 (5, 'Ve', 'Thai Son', 'Nxb Ha Noi', 'Vi Anh',  70, 180)

select * from Books


create table Customers (
	CustomerID int primary key,
	CustomerName varchar(50),
	Address varchar(100),
	Phone varchar(12)

)

insert into Customers values(1, 'Kieu Quoc Anh', 'Ha Dong, Ha Noi', '0961056732'),
							(2, 'Nguyen Minh Anh', 'Ha Dong, Ha Noi', '0123456789'),
							(3, 'Quoc Thai', 'Ha Dong, Ha Noi', '0123456649'),
							(4, 'Do Bao', 'Ha Dong, Ha Noi', '0123456389'),
							(5, 'Lan Anh', 'Ha Dong, Ha Noi', '01234566789')

select * from Customers

drop table BookSold
create table BookSold (
	BookSoldID int primary key ,
	CustomerID int references Customers(customerID),
	BookCode int references Books(BookCode),
	saleDate datetime,
	Price int,
	Amount int
)

select * from Customers
select * from Books

insert into BookSold values (1, 3, 1, '2023-08-01 14:30:00', 130,2),
							(2, 4, 1, '2023-09-07 14:34:00', 110,3),
							(3, 3, 1, '2023-09-04 17:34:00', 160,7),
							(4, 2, 3, '2023-07-06 14:30:00', 130,4),
							(5, 5, 4, '2023-09-07 17:30:00', 120,9),
							(6, 1, 2, '2023-08-03 18:30:00', 70,4),
							(7, 1, 3, '2023-08-03 7:30:00', 100,1),
							(8, 2, 1, '2023-09-01 8:30:00', 130,1),
							(9, 4, 1, '2023-09-01 14:30:00', 130,1),
							(10, 4, 3, '2023-09-01 15:30:00', 130,1)

							
select * from Customers
select * from Books
select * from BookSold
--khung nhìn chứa danh sách các cuốn sách (BookCode, Title, Price) kèm theo số lượng đã
--bán được của mỗi cuốn sách.
CREATE VIEW V_BookSoldAmount AS
SELECT b.BookCode, b.Title, b.price ,  SUM(bs.Amount) as BookTotalSold
FROM BookSold bs
Join Books b on bs.BookCode = b.BookCode
GROUP BY b.BookCode,  b.BookCode, b.Title, b.price;

select * from V_BookSoldAmount

--khung nhìn chứa danh sách các khách hàng (CustomerID, CustomerName, Address) kèm
--theo số lượng các cuốn sách mà khách hàng đó đã mua.

drop view V_CustomersBooks
CREATE VIEW V_CustomersBooks AS
SELECT c.CustomerID , c.CustomerName, c.Address ,b.BookCode,  b.Title, SUM(bs.Amount) as BookTotalSold
FROM Customers c
Join BookSold bs on c.CustomerID = bs.CustomerID
join Books b on b.BookCode = bs.BookCode
GROUP BY  c.CustomerID , c.CustomerName, c.Address , b.BookCode, b.Title;

select * from BookSold ORDER BY CustomerID;

select * from V_CustomersBooks ORDER BY CustomerName;

-- khung nhìn chứa danh sách các khách hàng (CustomerID, CustomerName, Address) đã
--mua sách vào tháng trước, kèm theo tên các cuốn sách mà khách hàng đã mua.

drop view V_PreMonthCustomersBooks
CREATE VIEW V_PreMonthCustomersBooks AS
SELECT c.CustomerID , c.CustomerName, c.Address ,b.BookCode,  b.Title
FROM Customers c

Join BookSold bs on c.CustomerID = bs.CustomerID
join Books b on b.BookCode = bs.BookCode
where DATEPART(YEAR, bs.saleDate) = DATEPART(YEAR, GETDATE()) AND
      DATEPART(MONTH, bs.saleDate) = DATEPART(MONTH, GETDATE()) - 1
GROUP BY  c.CustomerID , c.CustomerName, c.Address , b.BookCode, b.Title;


select * from V_PreMonthCustomersBooks

select * from BookSold ORDER BY saleDate;

--5. Tạo một khung nhìn chứa danh sách các khách hàng kèm theo tổng tiền mà mỗi khách hàng đã chi
--cho việc mua sách.
drop view V_CustomersTotalPayment
CREATE VIEW V_CustomersTotalPayment AS
SELECT c.CustomerID, c.CustomerName, sum(bs.Price*bs.Amount) as Total_Payment
FROM Customers c
Join BookSold bs on c.CustomerID = bs.CustomerID
join Books b on b.BookCode = bs.BookCode

GROUP BY  c.CustomerID, c.CustomerName ;

select * from V_CustomersTotalPayment 

select * from BookSold ORDER BY saleDate;


--Phần 3

create table Class (
	ClassCode varchar(10) primary key,
	HeadTeacher varchar(10),
	Room varchar(10),
	Timeslot char,
	CloseDate datetime
)

insert into Class values('C1007L', 'Hong Anh', 'Class 1', 'G', '2025-09-01 14:30:00.000'),
						('C1008H', 'Hong Duy', 'Class 2', 'I', '2025-07-05 15:30:00.000'),
						( 'C100KO', 'Hong Van', 'Class 3', 'L', '2024-07-01 15:30:00.000'),
						( 'C1007E', 'Lan Anh', 'Class 4', 'G', '2024-07-01 15:30:00.000'),
						( 'C100RL', 'Quoc Anh', 'Class 5', 'M', '2026-08-01 15:30:00.000')

create table Subject (
	SubjectCode varchar(10) primary key,
	SubjectName varchar(40),
	WTest bit,
	PTest bit,
	WTest_per int,
	PTest_per int
)

insert into Subject values ('EPC', 'Elementary Programing with C', 1, 1, 1, 1),
						 ('CF', 'Center Forward', 1, 1, 2,1),
						( 'Java', 'Java Basic', 1, 1, 2,1),
						( 'DM', 'Data Management', 0,1, 1,1),
						( 'Lara', 'Laravel Basic', 0,1, 1,1)


drop table Student
create table Student (
	RollNo varchar(10) primary key,
	ClassCode varchar(10) references Class(ClassCode),
	FullName varchar(30),
	Male bit,
	BirthDate datetime,
	Address varchar(30),
	Province char(2),
	Email varchar(30)
)

insert into Student values ('A00261', 'C1008H', 'Tuan Anh', 1, '2002-08-01', 'Ha Nam', 'ND', 'TA@gmail.com'),
						 ('A00262', 'C1008H', 'Duy Anh', 1, '2000-09-01','Bac Ninh', 'ND', 'DA@gmail.com'),
						( 'A00274', 'C1007E', 'Hoang Long', 1, '2004-07-08','Bac Ninh','HP', 'HL@gmail.com' ),
						( 'A00269', 'C1007L', 'Minh Nguyet',0, '2001-08-01','Bac Ninh','HN', 'MN@gmail.com'),
						( 'A00267', 'C1008H', 'Xuan Tan',1, '2003-03-07','Bac Ninh', 'HN', 'XT@gmail.com')
go
drop table Mark 
create table Mark (
	RollNo varchar(10) references Student(RollNo),
	SubjectCode varchar(10) references Subject(SubjectCode),
	WMark float,
	PMark float,
	Mark float
	constraint Mark_pk primary key(RollNo, SubjectCode)
)

insert into Mark values ('A00261', 'Lara', 5, 1, 3 ),
						 ('A00262', 'Java', 8, 2, 5 ),
						( 'A00274', 'DM', 9, 5,  7 ),
						( 'A00269', 'CF',7, 2, 4.5),
						( 'A00267', 'EPC',2, 7 ,4.5 ),
						( 'A00267', 'CF',0, 7 ,3.5 ),
						( 'A00262', 'EPC',8, 1 ,4.5 ),
						( 'A00269', 'EPC',7, 2 ,4.5 )
go
--2. Tạo một khung nhìn chứa danh sách các sinh viên đã có ít nhất 2 bài thi (2 môn học khác nhau)

drop view V_StudentsTakingMoreThanOneExam
create view V_StudentsTakingMoreThanOneExam as
select s.RollNo, s.FullName
from Student s
join Mark m on s.RollNo = m.RollNo
group by s.RollNo, s.FullName
having count(s.RollNo) > 2 or count(s.RollNo) = 2

select * from V_StudentsTakingMoreThanOneExam
select * from Mark

--3. Tạo một khung nhìn chứa danh sách tất cả các sinh viên đã bị trượt ít nhất là một môn.
drop view V_failedStudents
create view V_failedStudents as
select s.RollNo, s.FullName

from Student s
join Mark m on s.RollNo = m.RollNo
where m.PMark <= 2 or m.WMark <=2 or m.Mark <= 4
group by s.RollNo, s.FullName

select * from V_failedStudents

select * from Mark

--4. Tạo một khung nhìn chứa danh sách các sinh viên đang học ở TimeSlot G.
drop view V_G_SlotStudents
create view V_G_SlotStudents as
select s.RollNo, s.FullName

from Student s
join Class c on s.ClassCode = c.ClassCode
where c.Timeslot = 'G'


select * from V_G_SlotStudents

select * from Student
select * from Class

--5. Tạo một khung nhìn chứa danh sách các giáo viên có ít nhất 3 học sinh thi trượt ở bất cứ môn nào
drop view V_TeacherHas3
create view V_TeacherHas3 as
--select c.ClassCode, c.HeadTeacher, COUNT(DISTINCT s.RollNo) AS FailingStudentCount
select c.ClassCode, c.HeadTeacher
from 
Class c
join Student s on s.ClassCode = c.ClassCode
join Mark m on s.RollNo = m.RollNo
where m.PMark <= 2 or m.WMark <=2 or m.Mark <= 4
group by  c.ClassCode, c.HeadTeacher
having COUNT(distinct s.RollNo) >= 3

select * from V_TeacherHas3

select * from Student
select * from Class
select * from Mark
-- 6.Tạo một khung nhìn chứa danh sách các sinh viên thi trượt môn EPC của từng lớp. Khung nhìn
--này phải chứa các cột: Tên sinh viên, Tên lớp, Tên Giáo viên, Điểm thi môn EPC.

select * from Mark
select * from Subject
select * from V_EPC_Failed

drop view V_EPC_Failed
create view V_EPC_Failed as
select s.FullName, s.ClassCode, c.HeadTeacher, m.SubjectCode, m.WMark, m.PMark, m.Mark
from Mark m
join Student s on s.RollNo = m.RollNo
join Class c on c.ClassCode = s.ClassCode
where( m.PMark <= 2 or m.WMark <=2 or m.Mark <= 4) and m.SubjectCode = 'EPC'
