-- CL IX

-- NCL IX


-- COlStore

--Gift für jeden IX:  I UP D  --> Fragmentiert
--ab 30% Rebuild
--ab 10% Reorg

--ab SQL 2016 Wartungsplan: % Frag, nur IX die in letzten 7 Tagen verwendet sind
-- vorher never

--Woher weiss der SQL Server, wie oft und wann ein IX wie verwendet und woher weiss er die Fragmentierung

select * from sys.dm_db_index_physical_stats(db_id(), object_id('kdu2'), NULL, NULL, 'detailed')

select * from sys.dm_db_index_usage_stats --Verwendung der IX .. Suche vielen  Scan oder weder Scan noch Seek


--Wie finde ich alle relev Indizes für einen typischen Load (100000 Abfragen am Tag): DTA
--Workload von 

delete from customers where customerid = 'ALFKI'

--DTA vergisst FK Werte, die immer indiziert sein sollten

-- AND zusammengesetzte IX     bei  OR 2 Indizes


--CL IX nur 1x gut für Bereichsabfragen


---Locks

---Niveau: Tab ---> Zeile (aber nur wenn IX vorhanden)
				--Block (8 Seiten am Stück)
				--Seiten


--Sperren beeinflussen: 
	--TX kurz und bündig
	--Indizes .. 
	--trotzdem lesen: READ UNCOMMITED (Leser)--> aktuellen noch nicht best Datensatz
				--    Zeilenversionierung (auf DB einschalten) 
				-- + READ COMMITTED SNAPSHOT bei jeder Session: Leser bekommt den noch gültigen
					--zuletzt commmitted Datensatz 
					--Zeilenversionierung kostet tempdb


--in memory tabellenoutlo
--Abfragen werden schneller... nö

--CLR 