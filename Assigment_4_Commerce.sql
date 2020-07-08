Create database Assigment_4_Commerce
use Assigment_4_Commerce

Create table Products(
ID_Product int primary key not null,
Description nvarchar(60),
Price int,
Stock int
)

Create table Localities(
Zip_Code int primary key not null,
Locality nvarchar(60)
)
 
Create table Sellers(
ID_Seller int primary key not null,
Name_Seller nvarchar(60),
Acum_Sale int
)
 
Create table Clients (
ID_Client int primary key not null,
Name_Client nvarchar(60),
Address_S_Client nvarchar(60),
Address_N_Client int,
Zip_Code int foreign key (Zip_Code) references Localities(Zip_Code),
Acum_Sale int
)
 
Create table Purchase_Orders(
ID_Order int primary key not null,
ID_Client int foreign key (ID_Client) references Clients (ID_Client),
ID_Seller int foreign key (ID_Seller) references Sellers (ID_Seller),
Date datetime,
Cost int
)
 
Create table Purchase_Orders_Details(
ID_Order int foreign key (ID_Order) references Purchase_Orders(ID_Order),
ID_Product int foreign key (ID_Product) references Products (ID_Product),
Quantity int
)
 
insert into Products (ID_Product, Description, Price, stock) values (1, 'Table', 400, 2)
insert into Products (ID_Product, Description, Price, stock) values (2, 'Closet', 5, 0)
insert into Products (ID_Product, Description, Price, stock) values (3, 'Shelf', 150, 0)
insert into Products (ID_Product, Description, Price, stock) values (4, 'Desk', 270, 6)
insert into Localities (Zip_Code , Locality) values (3080, 'Buenos Aires')
insert into Localities (Zip_Code , Locality) values (2000, 'Rosario')
insert into Clients (ID_Client,Name_Client, Address_S_Client, Address_N_Client, Zip_Code , Acum_Sale) values (1,'Jack', 'Zeballos', 1522, 3080, 123)
insert into Clients (ID_Client,Name_Client, Address_S_Client, Address_N_Client, Zip_Code , Acum_Sale) values (2,'Emma', 'Lagos', 1426, 2000, 123)
insert into Clients (ID_Client,Name_Client, Address_S_Client, Address_N_Client, Zip_Code , Acum_Sale) values (3,'David','9 de julio', 323, 3080, 123)
insert into Clients (ID_Client,Name_Client, Address_S_Client, Address_N_Client, Zip_Code , Acum_Sale) values (4,'Lorenzo','Santa fe', 635, 3080, 123)
insert into Clients (ID_Client,Name_Client, Address_S_Client, Address_N_Client, Zip_Code , Acum_Sale) values (5,'Javier','Santiago', 2435, 2000, 123)
insert into Sellers (ID_Seller, Name_Seller, Acum_Sale) values (1, 'Ulises', 615)
insert into Purchase_Orders(ID_Order, ID_Client, ID_Seller, Date, Cost) values (1, 1, 1, '03/06/2020', 150)
insert into Purchase_Orders(ID_Order, ID_Client, ID_Seller, Date, Cost) values (2, 2, 1, '01/05/2020', 420)
insert into Purchase_Orders(ID_Order, ID_Client, ID_Seller, Date, Cost) values (3, 3, 1, '02/04/2020', 500)
 

 
-- Stored Procedures --
Create procedure spu_Delete_Client
@ID_Client int
as
delete from Clients where ID_Client= @ID_Client

exec spu_Delete_Client @ID_Client=2 
--Other
Create procedure spu_purchases_consult
@Date1 datetime,
@Date2 datetime
select * from Purchase_Orders where Date between @Date1 and @Date2

exec spu_purchases_consult @Date1 = '02/04/2020', @Date2= '03/06/2020' 

-- Functions --
select avg(Cost) as Cost_Average from Purchase_Orders
--Other
Create function Show_High_Average(@Average int) returns table
as
return (select ID_Order, Name_Client, Cost from Purchase_Orders
inner join Clients on Clients.ID_Client = Purchase_Orders.ID_Client where Cost > @Average)
select *from dbo.Show_High_Average(avg(Cost))
--Other
Create function stockCero (@stock int) returns table
as
return (select *from Products where stock = @stock)
 
select *from dbo.stockCero(0)
 
-- Trigger --
Create trigger mod_stock_Products on Purchase_Orders_Details
for insert, update
as
begin
declare @Product int;
declare @Number int;
set @Product = (select inserted.ID_Product from inserted);
set @Number = (select inserted.Quantity from inserted);
update Products set stock=stock-@Number where
ID_Product=@Product;
end;
