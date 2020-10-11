--TabA    TabB
--einziger Unterschied: A hat 10000 Zeilen und B hat 10000 Mio Zeilen

--Abfrage liefert 10 Zeilen von a oder b

--welche tabelle ist schneller?  A


--Salamitaktik

--Wir machen aus Umsatztabelle viele kleine Umsatztabellen



create database dbdemo; --Tipp an Admin: Anfangsgrößen und Wachstumsraten..
GO

use dbdemo

--statt sehr großer Umsatztabelle viele kleine..
--

create table u2020 (id int identity, jahr int, spx int)

create table u2019 (id int identity, jahr int, spx int)

create table u2018 (id int identity, jahr int, spx int)

create table u2017 (id int identity, jahr int, spx int)


--Anwendung braucht aber "Umsatz"

select * from umsatz --muss wieder funktionieren

--> Idee: Proc oder Sicht

create view Umsatz
as
select * from u2020
UNION ALL --keine Suche nach doppelten Zeilen
select * from u2019
UNION ALL
select * from u2018
UNION ALL
select * from u2017
GO

--besser:
--Messen mit: Plan.. Messen kostet--> Schleifen!!
--bisher nichts gewonnen

select * from umsatz where jahr = 2018

--Garantie dafür, dass nur das korrekte Jahr pro Tabelle enthalten ist..
ALTER TABLE dbo.u2017 ADD CONSTRAINT
	CK_u2017 CHECK (jahr=2017)

select * from umsatz where jahr = 2018
--Tab 2017 fehlt

ALTER TABLE dbo.u2018 ADD CONSTRAINT
	CK_u2018 CHECK (jahr=2018)


ALTER TABLE dbo.u2020 ADD CONSTRAINT
	CK_u2020 CHECK (jahr=2020)


ALTER TABLE dbo.u2019 ADD CONSTRAINT
	CK_u2019 CHECK (jahr=2019)



select * from umsatz where jahr = 2018


--SCAN vs SEEK
--SCAN von A bis Z durchsuchen.. SCAN wirft alles in den RAM... jetz nur noch die entspr. Tabellen


--Frage: Kann man auf eine Sicht I U D anwenden?

--Geht unter Abstrichen (JOINS, Pflichtfelder,..)


insert into Umsatz(jahr, spx) values (2018, 115)--> PK Error
--jeder DS muss über die Sicht eindeutig sein
--kein Identity

insert into Umsatz(id,jahr, spx) values (1,2018, 115)--> das ist doch Mist!!


--Ersatz für Idenity
--der nächste Wert max(id) +1 ist falsch

--Sequenzen


CREATE SEQUENCE [dbo].[USeq] 
 START WITH 2
 INCREMENT BY 1
GO

select next value for Useq


insert into Umsatz(id,jahr, spx) values (next value for Useq,2017, 115)

select * from umsatz

--am Ende oft unbrauchbar..aber gut bei reinen Lesetabellen

--daher gibts auch was besseres ;-)


--Partitionierung (Dateigruppen und f() und schemas)
--Dateigruppen

create table test (id int) on HOT


--Super ist: Partitionen verhalten sich wie tabellen
--IX pro Part, Kompression pro Part, Locks pro Part

--und es ist flexibel in der Anwendung

--Grenzen dazunehmen, grenzen wegnehmen, und Archivieren




--PartF()

create partition function fzahl(int)
as
RANGE LEFT FOR VALUES(100,200)  ---RIGHT

---------------100]-------------------200]--------------------------------
--    1					2						3

select $partition.fzahl(117) --2 


create partition scheme schZahl
as
Partition fzahl to (bis100,bis200,rest)

---                   1      2     3

drop table ptab

create table ptab (id int identity, nummer int, spx char(4100)) ON schZahl(nummer)


declare @i as int = 1
begin tran
while @i <= 20000
	begin
		insert into ptab (nummer, spx) values (@i,'XY')
		set @i+=1
	end
commit
--Das geht in 12 Sekunden.. vorher GO 20000  in 26 Sekunden
--vorher 20000 Batches mit 20000 TX

--jetzt 1 Batch mit 20000 TX

--wie erkennen wir den Vorteil
--im Plan und durch Messung


set statistics io, time on -- CPU und ges DAuer in ms und Seiten (Datenträgerzugriffe)

select * from ptab where id = 117 --20000 Seiten
select * from ptab where nummer = 117---100 Seiten


--Flexibel: neue Grenze  bei 5000

--F(), Scheme, Tab

--F()--> 4  scheme neue Dgruppe

--scheme --> f()

alter partition scheme schZahl next used bis5000

--bisher noch keine Änderung--3 Gruppen

select $partition.fzahl(nummer), min(nummer), max(nummer), count(*) 
from ptab group by $partition.fzahl(nummer)

alter partition function fzahl() split range (5000)

--100-----200---------------5000------

select * from ptab where nummer = 1117
--Daten sind immer dort wo sie sein müssen ..physikalisch


--Grenze 100 entfernen

--mache Dgruppe frei

--------X100X------------200--------5000----------
--        1                    2          3

--Scheme, f()

--nur die F()
alter partition function fzahl() merge range(100)

select $partition.fzahl(nummer), min(nummer), max(nummer), count(*) 
from ptab group by $partition.fzahl(nummer)


--Cool... ;-) 

--Archivieren---> eine partition in eine Archivtabelle schieben
--Vorteil.. jeder Komplettscan braucht nie wieder alle 20000 Seiten....

--Befehl, der Datensätze verschiebt?

--erst mal eine Übersicht, wie die akt. Situation
----verscripten


/****** Object:  PartitionFunction [fzahl]    Script Date: 05.10.2020 13:23:46 ******/
CREATE PARTITION FUNCTION [fzahl](int) AS RANGE LEFT FOR VALUES (200, 5000)
GO


/****** Object:  PartitionScheme [schZahl]    Script Date: 05.10.2020 13:24:15 ******/
CREATE PARTITION SCHEME [schZahl] AS PARTITION [fzahl] TO ([bis200], [bis5000], [rest])
GO

create table archiv (id int not null, nummer int, spx char(4100)) on rest

--Archiv tabelle muss das gleiche Schema wie orgtabelle besitzten.. (kein Identity, aber not null)

alter table ptab switch partition 3 to archiv-- Datensätze sind aus patb weg und in Archiv drin

select * from archiv

select * from ptab where id = 117

--komische Frage: 100MB/sek .. Annahme: wir switchen 1000MB  ins Archiv...    ein paar ms Sekunden
--Archivtabelle muss immer auf der zu switchenden Partition liegen..





--geht dsa auch bei:
--Jahresweise
create partition function fzahl(datetime)
as
RANGE LEFT FOR VALUES('31.12.2019 23.59:59.997','',''....)  

--AbisM  NbisR  SbisZ --knallharte Grenzen
create partition function fzahl(varchar(50))
as
RANGE LEFT FOR VALUES('N','S')  

--machbar und Sinn?.. macht Unsinn ;-) ?---> macht SInn
create partition scheme schZahl
as
Partition fzahl to ([PRIMARY],[PRIMARY],[PRIMARY])

--lohnt sich..weniger Seiten,...weniger RAM... weniger CPU

--part läßt sich kombinieren mit: IX, Kompression, Locks, ....
--eigtl Ent Features, aber seit SQL 2016 SP1 auch in Std und Express....

;-)


--letzte Frage.. Kann man best Tabellen von einer Dgruppe auf eine PartSchema legen?
-- Kann man denn auch Tabellen von einer Dgruppe auf eine andere Dgruppe schieben?

--Eigtl nicht?
--braucht immer ein Löschen der Original Tabelle
--ein Trick, der schafft das ohne: Indizes

--Daher plane immer Dategruppen und partionierung evtl vorher






