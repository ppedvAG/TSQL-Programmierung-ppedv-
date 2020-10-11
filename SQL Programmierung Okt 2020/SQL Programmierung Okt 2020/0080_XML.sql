--XPATH  XQÚERY
--XML kann 2 GB groß werden...
--XML Datentyp

--rel ungern..NoSQL

--value
--nodes  einen Knoten zurückgeben
--query  xquery
--exists ..prüft p, ob das Ding existiert
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
--primäerer XML INdex zerlegt die Strukturen und Werte
--zu langsam
--zweiter IX Property, value oder Query


select @xml