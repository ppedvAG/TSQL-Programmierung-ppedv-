--F()

/*
super praktisch

select f() from f() where f() > f()

meist , fast immer langsam --> IX


*/

create function frechner (@par1 int,@par2 int) returns int
as
	BEGIN
		return (select @par1*@par2)
	END

select frechner(100,30)

--weil benutzdef F() müssen immer mit schema aufgerufen werden

select dbo.frechner(100,30)


--
select dbo.fRngSumme(10248) --> RngSumme

create function fRngSumme(@id int) returns money
as
Begin
	return (select sum(unitprice*quantity) from [Order Details] where
		orderid = @id)
end


select dbo.fRngSumme(10248)


select dbo.fRngSumme(orderid) , orderid, freight from orders
where dbo.fRngSumme(orderid) < 500


alter table orders add GesamtSumme as dbo.fRngSumme(orderid)

select * from orders-- where Gesamtsumme < 500

--aber langsam: orders hat 830 Zeilen, order details hat 2155

--* er muss immer in order details
--Im Plan wird gelogen
--im tatsl. Plan steht f() gar nicht mehr drin
--im geschätzten allerdings falsch

select * from orders


--Wie kann man besser messen..








