--C#

use SqlCLR;

sp_configure 'clr enabled', 1
go
RECONFIGURE
go
sp_configure 'clr enabled'
go

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;

CREATE ASSEMBLY SQLCLR from 'c:\_SQLDBS\SQLCLR.dll' WITH PERMISSION_SET = SAFE



CREATE PROCEDURE [dbo].[HelloCLR]
@text NVARCHAR (MAX) NULL OUTPUT
AS EXTERNAL NAME [SQLCLR].[StoredProcedures].[HelloCLR]

exec HelloCLR 'huhu' 


using System;  
using System.Data;  
using Microsoft.SqlServer.Server;  
using System.Data.SqlTypes;  
  
public class HelloWorldProc  
{  
    [Microsoft.SqlServer.Server.SqlProcedure]  
    public static void HelloWorld(out string text)  
    {  
        SqlContext.Pipe.Send("Hello world!" + Environment.NewLine);  
        text = "Hello world!";  
    }  
}

--Datei: Hello.cs

--Pfad .NET
-- C:\Windows\Microsoft.NET\Framework\

-- csc /target:library helloworld.cs



