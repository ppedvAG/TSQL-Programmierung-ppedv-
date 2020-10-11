--Trigger

--DML und DDL
--DML I U D
--DDL CREATE ALTER DROP

--DML Triger reagiert auf IUD und macht w�hrend dessen:
--I -> Tabelle inserted
--D -> Tabelle deleted
--U -> Tabelle inserted und deleted

--Umstand ja--> performance

--Trigger reagiert unabh�ngig von Software
-- Idee: RngSumme redundant in Orders wird durch trigger auf Order details aktualisiert

select customerid, city, country, companyname into kunden from customers

--DDL
create trigger trgdemo on dbo.Kunden
FOR INSERT, DELETE, UPDATE
as
select * from inserted --deleted


select * from kunden
update  kunden set country = 'Italy' where customerid = 'ALFKI'

--trigger.. um zb RngSumme zu aktualisieren
--der DS, die gel�scht werden in andere Tabellen wegschreibt

--TX: 
--wir wollen RngSumme in Orders haben
alter table orders add RngSumme money

--Jede �nderung an order details soll die RngSumme aktualisieren
--Trigger f�r order details I U D

create trigger trgrngSumme on [order details]
for insert , update, delete --instead of
as
declare @oid as int
select @oid = orderid from inserted --nur ein Wert
--was aber wenn 2 oder meher Bestellungen ge�ndert wurden
...

--Das sch�ne ist, dass ein Update bereits die DAten ge�ndert hat und der Trigger erst danach reagiert
--bedeutet, dass man im Trigger bereits auf die Origtballe zugreifen kann --und die RngSummer 
--errechnen kann
--


update orders set RngSumme =   where orderid = @oid
--problem L�schen = deleted bzw inserted
select sum(unitprice*quantity) from [order details] where orderid = @oid

update orders set RngSumme = 

begin tran
update orders set freight = 100 where orderid < 10250
--jetzt startet trigger
select * from orders

rollback





--DDL Trigger
--ein Admin darf Tabelle �ndern: Spalten dazu, Spalten L�schen



create trigger ddltrigger 
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
as
--Nachricht
select eventdata()


create table test5 (id int)




create trigger ddlDrop 
ON DATABASE
FOR DROP_TABLE
as
--Nachricht
insert into logging select eventdata(), getdate()
rollback

drop table test5


exec msdb..sp_send_dbmail

--Alternativ in eine Logging tabellen schreiben

create table logging (id int identity, Nachricht xml, Datum datetime)

