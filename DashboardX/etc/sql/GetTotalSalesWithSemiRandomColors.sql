declare @colors table (SubmitDate varchar(50), Color varchar(50));
declare @data table(SubmitDate varchar(50), TotalSales money, Color varchar(50));
--declare @rows bigint;
--set @rows = (select count(*) from dbx.dbo.SampleData);

insert into @colors
--select top(@rows) SubmitDate, Color from dbx.dbo.SampleData order by newid()
values ('5/27/2013', 'Red'),
	   ('5/28/2013', 'Orange'),
	   ('5/29/2013', 'Yellow'),
	   ('5/30/2013', 'Green'),
	   ('5/31/2013', 'Blue'),
	   ('6/1/2013', 'Blue'),
	   ('6/2/2013', 'Green'),
	   ('6/3/2013', 'Yellow'),
	   ('6/4/2013', 'Orange'),
	   ('6/5/2013', 'Red'),
	   ('6/6/2013', 'Red'),
	   ('6/7/2013', 'Orange'),
	   ('6/8/2013', 'Yellow'),
	   ('6/9/2013', 'Green'),
	   ('6/10/2013', 'Blue'),
	   ('6/11/2013', 'Blue'),
	   ('6/12/2013', 'Green'),
	   ('6/13/2013', 'Yellow'),
	   ('6/14/2013', 'Orange'),
	   ('6/15/2013', 'Red'),
	   ('6/16/2013', 'Red'),
	   ('6/17/2013', 'Orange'),
	   ('6/18/2013', 'Yellow'),
	   ('6/19/2013', 'Green'),
	   ('6/20/2013', 'Blue'),
	   ('6/21/2013', 'Blue');

insert into @data
select SubmitDate, sum(TransAmount) as TotalSales, Color
from dbx.dbo.SampleData
where LocationID = 267529000000 --{0}
group by SubmitDate, Color;

select D.SubmitDate, D.TotalSales, C.Color
from @data D--, @colors C
join @colors C on D.SubmitDate = C.SubmitDate;