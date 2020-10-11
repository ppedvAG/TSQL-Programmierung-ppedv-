--Warum....ist der SQL inkonsequent
use northwind

select shipcountry as Land,
		sum(freight) as Frachtkosten
from orders o
	--where Land = 'Brazil' --hier geht Land nicht
group by  o.ShipCountry having Land = 'Brazil' --auch hier geht Land nicht
order by  Land asc --hier schon


---Logischer Fluss: Reihenfolge

--> FROM (Tabellen und deren Alias)--> Der Reihe nach JOIN (und Alias)
--> WHERE (nur nach Spalten filterbar , aber nich nicht nach deren Alias)
--> GROUP BY --> HAVING --> SELECT (nicht Ausgabe, sondern ALIAS, Berechnung)
--> order by (nach Alias machbar) --> TOP|DISTINCT --> Ausgabe

select shipcountry, sum(freight)
from orders
	group by shipcountry having shipcountry='Brazil'
	order by shipcountry

--besser
select shipcountry, sum(freight)
from orders
where shipcountry = 'Brazil'
	group by shipcountry -- having shipcountry='Brazil'
	order by shipcountry

--im Having sollte nie was anderes als ein AGG stehen


-with cube rollup




--Ingesamt, pro Land, pro Stadt, pro Land und Stadt
select country, city, count(*) from customers 
group by country, city


--mehrere Abfragen...
--Jedes Ergbnis sofort haben

select country, city, count(*) AS anzahl into #t1 from customers 
group by country, city
--with rollup
order by 1,2,3

select * from #1


select country, city, count(*) from customers 
group by country, city
with cube order by 1,2,3

--> Cube -- Datawarehouse: Cubes

