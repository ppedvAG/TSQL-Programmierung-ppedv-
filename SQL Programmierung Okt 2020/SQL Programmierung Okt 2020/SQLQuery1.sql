select * into kx from customers

select * into ky from customers where country in ('Italy', 'germany', 'Austria')


update kx set city = 'Limburg' where customerid = 'ALFKI'


select * from ky
delete from ky where customerid = 'BLAUS'
update kx set city = 'ROM' where customerid = 'FRANK'


--Ziel: vergleich: was ist in beiden identisch.. die CustID reicht nicht mehr

select * from kx inner join ky on id = id and city 0 city and.. jede Spalten


select * from kx
intersect
select * from ky


select customerid, city from kx
intersect
select customerid, city from ky

--Reihenfolge spielt keine Rolle

--Wer sind die Unterschiedlich

select * from kx --Basismenge
except
select * from ky


select * from ky
except
select * from kx

--Ergebnismengen orientiert


--TOP


Select orderid, freight from orders

--Liste mit den bestellNr und deren Frachtkosten
--die Liste soll nur die orderid mit den höchsten Frachtkosten haben 
--und die mit den niedrigsten


select orderid, freight from orders where orderid = (
		select top 1 orderid from orders order by freight desc)
				or
					orderid = (select top 1 orderid from orders order by freight asc)

--Unterabfragen..sind langsam

--das ist eigtl eine Abfrage mit einem UNION 
--wieviele order by darf eine Abfrage haben..?

select top 1 orderid, freight from orders --order by freight asc
UNION ALL
select top 1 orderid, freight from orders 
order by freight desc
--blöd

--schaut auch nicht intell aus..
select * from 
		(select top 1 orderid, freight from orders order by freight asc) t1
UNION ALL
select * from 
( select top 1 orderid, freight from orders order by freight desc) t2


--bevor kompliziertes zeug kommt..
--> #tabellen


--temp führen zu schrittweisen vorgenehsweisen..

--Wilde 13.. top 13 Kunden gemssen an Frachtkosten .. billigsten zuerst
select customerid, freight  from orders order by freight 

select top 13 with ties customerid, freight  from orders order by freight asc

--der letzte Zipfel 











