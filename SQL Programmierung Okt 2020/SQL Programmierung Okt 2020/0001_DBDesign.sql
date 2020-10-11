--DB Design
--Normalisierung, PK-- Beziehung   -->FK
--Redundanz
--Generalisierung


--Datentypen

/*  Otto
nvarchar(50)  'otto'    4 
char(50)     'otto                                  '   50
text()   nicht mehr verwenden.. seit SQL 2005 depricated  auch image ..kann 2 GB daten besítzen
nvarchar(50)  'otto'   4   *2   --> 8 
nchar(50)   'otto                         ' 50 * 2 --> 100

n = Unicode 


Regel: bei fixen Längen immer char!



*/



use northwind

--alle Bestellungen aus dem Jahr 1997

select * from orders where year(orderdate) = 1997 --richtig aber langsam

select * from orders where orderdate like '%1997%'  --richtig aber langsam


select * from orders where orderdate between '1.1.1997' and '31.12.1997' --between grenzen sind immer inklusive
																		--schnell aber falsch
																		--orderdate = datetime auf ms
																		--31.12.1997 00:00:00.000
select * from orders where orderdate between '1.1.1997' and '31.12.1997 23:59:59.997'

--datetime ist nicht auf ms genau! sondern nur auf 2ms genau
--besser für GebTag oder Kaufdatum date

--Ziel : such immer den passenden Datentyp: nicht zu groß nicht zu klein...

create table t1 (id int, sp1 char(4100), sp2 char(4100)) --geht nicht!

create table t1 (id int, sp1 char(4100)) --geht, aber Verlust pro Seite bei kanpp 50%

--kann man das messen!

create table t1 (id int identity, sp1 char(4100)) 

insert into t1
select 'XY'
GO 20000


--26 Sekunden: 160MB in 26 Sek ?????

--Verlust feststellen

dbcc showcontig('t1')
-- Gescannte Seiten.............................: 20000
-- Mittlere Seitendichte (voll).....................: 50.79%

--Normalisierung ist ok.. gezelt Redundanz um Joins zu vermeiden
--beachte die Seitendichte.. hoher Verlust vermeiden... bessere Datentypen, Tabellenspalten auslagern



--Wo kann man das Datenbankdesign sehr schnell sehen?

--IDs: int -21, Mrd bis 2,1 Mrd
--     char..muss man erklären.. Textilbranche
--     GUID.. uniqueidentifier..gut bei: offline generierbar
--                         Replikation



select newid()




