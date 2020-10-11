/*
ISJSON
JSON_VALUE
JSON_QUERY
JSON_MODIFY


*/

declare @jsonCust as nvarchar(max) -- bis 2 GB
set @jsonCust = (select top 5 * from customers for json auto, root('CUSTS'))


set @jsonCust = (select top 5 Customerid, companyname, country, city
					from 
				customers for json auto, root('CUSTS'))

select @jsonCust

select JSON_VALUE(@jsonCust,'$.CUSTS[1].Customerid')

select JSON_VALUE(@jsonCust, '$.CUSTS[2].companyname')

select JSON_QUERY(@jsonCust,'$.CUSTS[1]') --holt ein Array 



--geht auch der weg von JSOn in Tabelle

declare @jsonCust as nvarchar(max) -- bis 2 GB

set @jsonCust = (select top 5 Customerid, companyname, country, city
					from 
				customers for json auto, root('CUSTS'))


set @jsonCust= (select JSON_QUERY(@jsonCust,'$.CUSTS[1]'))
select @jsonCust

select * from openjson(@jsonCust)
 WITH
	(
		ID nchar(5) '$.Customerid',
		Firma nvarchar(50) '$.companyname',
		Land nvarchar(50) '$.country',
		Stadt nvarchar(50) '$.city'
	)


--Indizierung

--Spalte mit Json + Spalte als berechneter wert json.value(stadt)

jsonsspalte.value.. = Paris
--case Sensitive!!!!