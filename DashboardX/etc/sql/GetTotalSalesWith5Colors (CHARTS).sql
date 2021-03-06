with T as (
	select (row_number() over (order by SubmitDate)) as RowNo,
		   sum(TransAmount) as TotalSales, SubmitDate, Color
	from dbx.dbo.SampleData
--	where LocationID=267529000001
	group by Color, SubmitDate
)
select * from (
  select SubmitDate, TotalSales, 
    case
     when RowNo=1 or RowNo=6 or RowNo=11 then 'Red' 
     when RowNo=2 or RowNo=7 or RowNo=12 then 'Orange'
     when RowNo=3 or RowNo=8 or RowNo=13 then 'Yellow'
     when RowNo=4 or RowNo=9 or RowNo=14 then 'Green'
     when RowNo=5 or RowNo=10 or RowNo=15 then 'Blue'
    end
  as Color 
  from T
) x
group by SubmitDate, Color, TotalSales