Begin try
--code
End try
Begin Catch
--code
End catch


Begin try
select 1/0
End try
Begin Catch
select ERROR_MESSAGE(), ERROR_SEVERITY(), ERROR_NUMBER()
select 'error'
End catch

select * from  sysmessages where msglangid =1031


--Entscheidend Ebene:
--Ebene 15: DAU
--Ebene 16:
--Ebene 14: Zugriffsrechte
--Ebene 17: --> Ebene 25
--Ebene 23-->24

select * from customersxy



--Proz die offensichtlich nicht gehen kann--falsches Objekt
create proc gperror
as
select * from test123


--Errohandling mit OrigCode-- Err_number oder Err_Severity


Begin try
exec gpError
commit
end try
Begin catch
select ERROR_NUMBER(), ERROR_PROCEDURE(), ERROR_MESSAGE()
rollback
end catch


--Sprungaddresse


Sprungmarke:


GOTO Sprungmarke




Erster:
print 'hallo'

GOTO HELL

hell:
Goto Erster

; am Ende


alter proc gpui
as
select getdate();
GO

exec gpui --32mal




