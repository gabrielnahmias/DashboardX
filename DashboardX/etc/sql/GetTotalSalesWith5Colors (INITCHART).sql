with T as (
	select (row_number() over (order by LocationID)) as RowNo,
		   LocationID, sum(TransAmount) as TotalSales, DBAName
	from dbx.dbo.SampleData
	group by LocationID, DBAName
)
select * from (
  select LocationID, TotalSales, DBAName, 
    case
     when RowNo=1 then 'Red'
     when RowNo=2 then 'Orange'
     when RowNo=3 then 'Yellow'
     when RowNo=4 then 'Green'
     when RowNo=5 then 'Blue'
    end
  as Color 
  from T
) x
group by LocationID, TotalSales, DBAName, Color