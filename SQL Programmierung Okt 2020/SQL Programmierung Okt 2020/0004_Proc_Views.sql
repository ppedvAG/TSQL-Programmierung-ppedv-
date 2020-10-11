--Prozeduren: oft komplette BI Logik


create proc gpdemo @par1 int, @par2 int 
as
--Code

select * from customers

exec gpkdSuche 'ALFKI' --1 Treffer

exec gpkdSuche 'A' -- 4  Treffer

exec gpkdSuche  --alle Kunden 91 

--schreibe eine Proz, die das liefert...


create proc gpkdSuche @kdID nchar(5)='%'
as
select * from customers where customerid like @kdID +'%'

exec gpkdSuche 'ALFKI'--Treffer

exec gpkdSuche 'A'--kein Treffer  char(5) .. 'A    ' +'%' ..ach ..Mist

declare @kdid as char(5).. ok

declare @Land as varchar(30) --weil in Tab varchar(30).. schätzt auf 50%--RAM
--das verschätzen wird umso schlimmer, wenn ein oerder by dabei ist..


alter proc gpkdSuche @kdID varchar(15)='%'
as
select * from customers where customerid like @kdID +'%'


exec gpKdSuche 

--ok.. Problem des char / varchar gelöst, aber super schlecht geschrieben
--nie benutzerfreundlich

--der Vorteil der Prozedur ist, dass die Pläne immer so belieben wie sie sind..
--erstellt bei ersten Aufruf der Proz
--wg indizes

--auch das ist schlecht

create proc gpoxy @par1 int,@par2 int
as
If @par1 < 100 
select * from tab orders.....
else
select * from customers where...


---Lösung wäre 
--in der Prozedur einfach weitere Proz aufrufen

gpKundenSuche
	--> gpKundenviel
	--> gpKundenwenige



--Sichten
create table slf (id int identity, stadt int, land int)

insert into slf
select 10,100
UNION ALL
select 20,200
UNION ALL
select 30,300

select * from slf



--Sind Sichten gleich schnell

create view vslf
as
select * from slf
GO

select * from slf

select * from vslf --selbe Plan

--lustig: neue Spalte Fluss

alter table slf add Fluss int
update slf set fluss = id *1000

--hier sollte die gesamte Tabelle herauskommen
select * from vslf --Fluss fehlt

----Sicht scheint das Schema der Ausgabe beim Erstellen festzulegen

--und nun ?

alter table slf drop column Land

--hmm entweder Fehler oder ....ohne Land


--Die Spalte Land hat die Werte von Fluss...
select * from vslf


--So was darf nicht passieren..?
--with schemabinding
--man muss sehr genau arbeiten: schema
--kein * 

create table slf2 (id int identity, stadt int, land int)

insert into slf2
select 10,100
UNION ALL
select 20,200
UNION ALL
select 30,300

create view vslf2 with schemabinding
as
select id, stadt, land from dbo.slf2

select * from vslf2

alter table slf2 add Fluss int
update slf2 set fluss = id *1000


alter table slf2 drop column land

alter table slf2 drop column fluss

--with schemabindung kann die Sicht immer funktionieren und richtgi sein

--  * versaut jede Performance

--bei Sicht aufpassen

--Alle Kunden mit Frachtkosten kleiner 10
select companyname   from vUmsatzKunde where freight < 10

set statistics io, time on
--Alle Kunden aus Berlin
select distinct companyname from vUmsatzKunde where city = 'Berlin'

select companyname from customers where city = 'Berlin'

--Sicht immer nur für das verwenden , für das sie gemacht wurde...


set statistics io, time on
select * from kdu2 where id < 2

--in Proc

create proc gpSuchID @par1 int
as
select * from kdu2 where id < @par1


--NIX_ID
--QueryStore  ..der läuft

--IX seek mit 4 Seiten 0 ms

exec gpSuchID 2

--IX seek.. 4 Seiten .,..
--der Plan wird beim ersten Aufruf kompiliert

select * from kdu2 where id < 2
select * from kdu2 where id < 500000
--T SCAN 113000 Seiten 1,5 Sek 9,1 Sek


exec gpSuchID 500000 ---508125 Seiten .. wtf!!!????--- 2,5 Sek   11 Sek
exec gpSuchID 2

--Prozedur läuft mal gut mal schlecht...
--wie aber besser
--Idee Kompromiss: T SCAN nie mehr als 113000 Seiten, wenn wir nicht wisse wie oft was gefragt wie

--Idee: wir wissen oft Werte unter 12500 und wie oft darüber

--zuerst mal Kompromiss:


dbcc freeproccache --alle Pläne futsch... CPU stiegt weil neue Pläne

exec gpSuchID 500000 --T SCAN

exec gpSuchID 2 --T SCAN


select * from kdu2 where customerid like 'AL%'

select * from kdu2 where left(customerid, 2) = 'AL'  --immer in SCAN

--nie in where um eine Spalte eine F()

--alle aus dem jahr 1996

select * from kdu2 where year(orderdate) = 1996

select * from kdu2 where orderdate between '1.1.1996' and '31.12.1996 23:59:59.997'

select * from kdu2 where orderdate like '%1996%' -- !=   <> immer SCAN

--Alle Bestellungen aus dem Q1 
select * from kdu2 where month(orderdate) in (1,2,3)

select * from kdu2 where datepart(qq, orderdate) in (1)

alter table kdu2 add Jahr int
alter table kdu2 add QU int


update kdu2 set QU = datepart(qq,orderdate)

select * from kdu2 where Qu = 1

--email wird --> präfix andreasr  | maildom ppedv.de

--alle Ang die im rentenalter sind.. 65 Jahre
select * from employees dateadd(yy,65, Birthdate) <= Getdate()-- nix gut

select * from employees where Birthdate < dateadd(yy, -65, getdate())



--auch Variablen sind nicht optimal.. müssen grob geschätzt werden
declare @Datum as datetime
set @Datum = dateadd(yy, -65, getdate()) ---select @Datum = orderdate where orderid = 10248)
select * from employees where Birthdate <= @Datum --glaube 1 Zeile, oder 100 oder 30%


--Suche nach allen Bestellungen, deren Frachtkosten brutto unter 10 liegen

select * from orders where freight*1.19 < 10

create function fbrutto (@netto money) returns money
as
begin 
	return (select @netto *1.19)
end


select orderid, freight, customerid from orders where dbo.fbrutto(freight) < 2

--SQL 2019 ist in der Lage einfache Sklare Funktionen aufzulösen

select * into kdu3 from kdu2



select * from kdu3 where id = 100 --eine

select * from kdu3 where city = 'berlin' --

select * from kdu3 where freight = 29.46 and Quantity = 2

--woher weiss eer wiviel ca rauskommt?
--Statistiken..aber warum.. weil NGR nur gut bei weniger Ergebnissen

--Statistik kann auch veraltet und somit falsch
--nicht bei jedem I U D , sondern erst nach 20% Änderungen + 500 + Abfrage auf die Spalte

sp_updateStats

--Leistung wird beim Upgrade plötzlich schlechter



