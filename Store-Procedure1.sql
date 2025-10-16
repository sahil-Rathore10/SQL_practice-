USE [SQLBATCH2]
GO

/****** Object:  StoredProcedure [dbo].[SP_SAMPLE3]    Script Date: 22-09-2025 15:40:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[SP_SAMPLE3]

@dept_name varchar(20)
as
begin

select * from Employee$
where DEPT_NAME = @dept_name

end
GO


