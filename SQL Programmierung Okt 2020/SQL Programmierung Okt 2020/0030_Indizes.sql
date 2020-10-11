/*
Gruppierter IX (Clustered)   x
Nicht gr IX (non Cl)  x
-------------------------------
eindeutiger IX  x
zusammengesetzter IX  x
gefilterter IX  x
IX mit eingeschls Spalten  x
part. IX
ind. Sicht
abdeckender IX   x
realer hypothetischer IX
--------------------------------
Columnstore IX (gr und nicht gr)


IX haben Auswirkung auf: Performance + oder - (I U D)
						 Locks (Sperren).. Niveau wird niedriger (Zeile, Page, Extent..)
						 IO weniger-->weniger RAM-->weniger CPU


*/


--Gr IX gut bei Bereichsabfragen ..nur einmal pro Tabelle .. = Tabelle
--N GR IX: ca 1000 mal pro Tabelle, gut bei rel wenigen Ergebniszeilen


--Tipp: mach dir zuerst einen Kopf auf welche Spalten du den GR IX setzen willst

select shipcountry, sum(freight) from orders where shipcity = 'London' and Employeeid in (1,3,5) 


SELECT        Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.ContactTitle, Customers.City, Customers.Country, Orders.EmployeeID, Orders.OrderDate, Orders.Freight, Orders.ShipCity, 
                         Orders.ShipCountry, Employees.LastName, Employees.FirstName, [Order Details].Quantity, [Order Details].UnitPrice, [Order Details].ProductID, [Order Details].OrderID, Products.ProductName, Products.UnitsInStock
INTO KDU
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID INNER JOIN
                         Products ON [Order Details].ProductID = Products.ProductID


insert into kdu
select * from kdu


select * into kdu2 from kdu


alter table kdu2 add id int identity


set statistics io, time on

select id from kdu2 where id = 100 --HEAP.. TABLE SCAN

--113683 Seiten und 280ms 147ms

--besser mit IX
--welche Spalte soll den gr IX haben: OrderDate..weil oft Frage nach Jahr oder Quartal oder Monat kommt

select top 3 * from kdu2

--NIX_ID
select id from kdu2 where id = 100 --reiner IX Seek.. perfekt
--3 Seiten--> Baum hat 3 Ebenen


select id, lastname from kdu2 where id = 1 ----IX Seek + Lookup 50% --4 Seiten..geht doch


select id, lastname from kdu2 where id < 22500 ----IX Seek + Lookup 99% --1044 Seiten..geht doch
--je mehr hier rauskommt, desto eher der Table Scan, weil zu teuer.. Grenzwert bei ca 1 %

--kann man besser machen

---zusammengesetzter IX.. alle beteiligte Spalten in IX rein
--NIX_ID_LName


select id, lastname from kdu2 where id < 22500-- IX Seek auf neuen IX
--105 Seiten

--Problem Nr 1: zusammengesetzter IX kann nur 16 Spalten haben, aber Spalten bräuchten
--eigtl ist das eh ineffizient

--NIX mit eingeschlossenen Spalten.. hier sind 1000 Spalten möglich

--NIX_ID_i_lname_fname

select id, lastname, firstname, freight from kdu2 where id < 122500


--Sinn einen zusammengesetzter IX zu verwenden
--NIX_CY_CI_i_SCI_SCY_FR
select Shipcity, shipcountry, freight from kdu2 where country = 'UK' and city = 'Cowes'

--reiner Seek..kein Lookup, kein Scan--> abdeckender IX.. der ideale IX für diese Abfrage

--eitl 2 Indizes--kein Vorschlag mehr
--aber wir sagen 2 IX: einer auf Country und einer weiterer auf Freight
select Shipcity, Unitprice, freight from kdu2 where country = 'UK' or freight < 0.1


--Klammern setzen 
select Shipcity, Unitprice, freight from kdu2 
	where 
		(country = 'UK' 
		or 
		freight < 0.1)
		and 
		Quantity < 2


--gefilterter Index: N gr IX , in dem nicht mehr alle DS enthalten sind

select freight, city from kdu2 where country = 'USA'

--NIX_CY_filter_USA

--Was wenn IX auf Country ungefiltert-- warum ist der ungefilterte eigtl gleich gut..?

--gefilterte machen nur dann Sinn, wenn es zu weniger Ebenen kommt...



--Indizierte Sicht:
select country, count(*) from kdu2 
group by country

--Sicht schneller langsamer oder gleich

create view v1
as
select country, count(*)as Anzahl from kdu2 
group by country


select * from v1 --identisch


alter view v1 with schemabinding
as
select country, count_big(*)as Anzahl from dbo.kdu2 
group by country


--gleich schnell

--nach CLIX auf Sicht(Country)
--Dauer von 0ms und 2 Seiten
--Das Ergebnis der Sicht wird immer korrekt sein

--Das Ergebnis der Sicht wird indiziert

--Amazon: 2 Trd --> Umsatz pro Land weltweit
--nicht mehr als 2 Seiten...0 ms

--geht leider nur mit count_big-- im großen und ganzen in vielen Fällen nicht verwendbar
-- Columnstore


select * into k1 from kdu2
select * into k2 from kdu2

select top 3 * from k1

--Abfrage: Agg where

--Alles aus 1996, pro Kunde Summe aller Rngsumme


select customerid, sum(unitprice*quantity) from k1
	where orderdate between '1.1.1996' and '31.12.1996 23:59:59.997'
	group by customerid

--ohne IX: 82000 Seiten  660ms 280ms Dauer .. Table Scan
--bester IX: CLIX_Odate

select top 100 * from k1

--mit CLIX auf Odate  
---15800  ca 150ms 170ms

--neuer IX: NIX_FR_i_cID_UP_QU
--3 Seiten 0ms
select customerid, sum(unitprice*quantity) from k1
	where freight < 1
	group by customerid

	--15ms--- 137

	--bei jeder neuen Abfrage neuer IX fällig


	--Gr COl Store IX auf k2


select customerid, sum(unitprice*quantity) from k2
	where orderdate between '1.1.1996' and '31.12.1996 23:59:59.997'
	group by customerid

--ca gleich schnell ab kein Hinweis auf 15800 Seiten


select customerid, sum(unitprice*quantity) from k2
	where freight < 1
	group by customerid

--komprimierte Tabelle ist 1:1 im RAM.. also statt 700MB nun 6,5MB
--ist aber genausoschnell wie die unkomprimierte rowstore tabelle mit passenden Indizes

--Irre!
--Nachteile
--I UP DEL

--Archivtabellen, alte große Datenmengen

--Power Pivot in Excel = Columnstore

--Tipp: je mehr Daten desto besser
--kompression kostet CPU. ... CPU schonend 

Row und Page Kompression: ca 40 bis 60%
Columnstore : 1/10 oder mehr



---A B C
--ca 1000

--ABC


--Scripte für die Wartung: Brent Ozar  Sp_BlitzIndex



--DDL Trigger: CREATE ALTER DROP


--Tab kdu

dbcc showcontig ('kdu') --80916 Seiten ..98% Füllgrad

select * from kdu where freight < 0.01 --alle Seiten lesen

alter table kdu add id int identity
--DDL Trigger **blitzblitz** Mail bzgl Änderung an tabellen

select * from kdu where id = 100 --113675
dbcc showcontig('kdu') --zeigt 82000 Seiten , man liest aber 113 000 krank!!!

--wie finde ich solche Mist Tabellen
select * from sys.dm_db_index_physical_stats(db_id(), object_id('kdu'), NULL, NULL, 'detailed')
--forward record count muss 0 sein


--Wieso hast du einen Heap


---Fragen:

/*
HEAP Table Scan vs CL IX SCAN  egal

NCL IX SCAN  vs CL IX SCAN  IX SCAN ist weniger

NCL IX SCAN vs IX SEEK   IX SEEK

NCL IX SEEK > Lookup --> HEAP     besser
NCL IX SEEK > Lookup --> CL IX


Was ist besser... viele Inserts auf HEAP oder CL IX
select newid()

Select top.. beim HEAP besser

*/

--44% für Sortieren
select * from customers c inner merge join orders o 
	on c.customerid = o.customerid


select * from customers c inner loop join orders o 
	on c.customerid = o.customerid

--wenn kein IX vorhanden ist der tab sehr groß
select * from customers c inner hash join orders o 
	on c.customerid = o.customerid