--XPATH  XQ�ERY
--XML kann 2 GB gro� werden...
--XML Datentyp

--rel ungern..NoSQL

--value
--nodes  einen Knoten zur�ckgeben
--query  xquery
--exists ..pr�ft p, ob das Ding existiert
--modify


select * from customers for xml AUTO,ELEMENTS, ROOT('Kunden')


declare @xml as xml
set @xml = (select * from customers for xml AUTO,ELEMENTS, ROOT('Kunden'))
select @xml
--select @xml.nodes('Kunden/Customers[2]')

select @xml.query('Kunden/customers[1]/City')


set @xml.modify(
'
insert <customers><city>paris</city></customers>
as first
into (/Kunden[1])'
				)



--XMl Indizes
--prim�erer XML INdex zerlegt die Strukturen und Werte
--zu langsam
--zweiter IX Property, value oder Query


select @xml