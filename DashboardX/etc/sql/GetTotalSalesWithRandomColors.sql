declare @colors table (LocationID bigint, Color varchar(50));
declare @T table(LocationID bigint, SubmitDate varchar(50), TotalSales money, Color varchar(50));

insert into @colors
select distinct LocationID, Color
from dbx.dbo.SampleData;

insert into @T
select LocationID, SubmitDate, sum(TransAmount) as TotalSales, Color
from dbx.dbo.SampleData
--where LocationID = {0}
group by LocationID, SubmitDate, Color;

select T.LocationID, T.SubmitDate, T.TotalSales, C.Color
from @T T
join @colors C on T.LocationID = C.LocationID;