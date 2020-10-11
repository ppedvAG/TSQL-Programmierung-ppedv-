CREATE TABLE #TMP1 (ID INT, Col1 CHAR(1), Col2 INT)
GO

INSERT INTO #TMP1 VALUES(1,'A', 1), (2, 'A', 2), (3, 'B', 3), (4, 'C', 4), (5, 'D', 5), (6,'D',6)
GO

SELECT *
  ,SUM(Col2) OVER(ORDER BY Col1 RANGE UNBOUNDED PRECEDING) "Range" 
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS UNBOUNDED PRECEDING) "Rows"   
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS Between CURRENT ROW and 2 Following )     
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS Between 2 FOLLOWING and 3 Following )    
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS Between 2 Preceding    and 2 Following ) 
FROM #TMP1

select * from #tmp1

select orderid, customerid, shipcity,sum(freight) over (partition by customerid order by shipcity )
from orders



select customerid, shipcity , 
		sum(freight) over ( partition by Shipcity order by customerid),
		rank() over  (order by customerid),--  order by sum(freight)),
		dense_rank() over  (order by customerid),--  order by sum(freight)),
		dense_rank() over  (partition by Employeeid 
from orders


--Orders


select * from orders

--Frachtkosten 

--Kunden, Shipcountry und Summe der Frachtkosten

select orderid,customerid, shipcountry , sum(freight) from orders
group by orderid,customerid, shipcountry
order by 1,2

select orderid,customerid, sum(freight) over (partition by Customerid)
from orders


select orderid, sum(freight) over (order by orderid Rows between current row and 2 following),
	
	 over (order by orderid Rows between 2 Following and 4 following),



	--NTILE RANK dense_rank



select * from orders

--unter 10 Freight: A
--      100 C Kunde
--rest B


select customerid, avg(freight), case 
									when freight < 10 then 'A'-- reihenfolge... auch like mit Wildcard
									when freight > 100 then 'C'
									else  'B'
								end Kat
from orders

--Alternative:
select .. where < 10
UNION all
select ....

--MIST

--NTILE (gleiche Teile)


select orderid, freight, NTILE(3) over (order by freight) from orders

--rank()
--dense_ranke()

select kdid, land, max(wert)

1 USA  5
1 GER  100
1 UK   5000  1

2 UK 3
2 IT  5
2 Swiss 100
									

from orders


--TOP !!


	select customerid, shipcity, freight, 
			dense_rank() over (partition by customerid order by freight desc),
			rank() over (partition by customerid order by freight desc)

	from orders
