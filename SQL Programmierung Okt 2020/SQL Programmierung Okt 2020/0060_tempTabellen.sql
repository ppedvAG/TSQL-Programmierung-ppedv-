/*

schneller: da tempdb optimiert wurde!!

Block: kleine tabelle teile sich einen Block..gleichzeitiger Zugriff
  größere Tabellen einen Block für sich alleine

--seit 2016 : Uniform Extents.. alle Tabellen bekommen isoliert Blöcke (T 1118)

#t:lokale temp:
	nur die Session des Ersteller
	Lebensdauer: bis Session weg
				drop table #t1

	Soll ich drop machen oder nicht? kann man sich sparen , wenn Sitzung eh geschlossen wird

##t
	globale temp Tabelle:
	Lebensdauer: bis Session des Ersteler geschlossen wird
					drop table
					Zugriff geht solange weiter bis Abfrage fertig
	Zugriff: auch andere Sessions können Zugriff haben



*/


select * into ##t1 from sysprocesses

select * from #t1

--variable: Gilt nur während der Batch läuft.. ein Go vernichtet die Proz
declare @Kunden Table
	(
		kdId nchar(5),
		Firma varchar(50)
	)
GO


--Warum @Table: bis zu 1000 Datensätze ist ein @Tabelle schnell.. ab dann vergoss es... 
--eingeschränkt



declare @i as int = 0

select @i
go

select @i



--temporäre Prozedur: wg Security, darf man in tempdb aber in der OrigDB nicht
create proc #test
as
select getdate()