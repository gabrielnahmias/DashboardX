declare @oldchartname varchar(50), @movedchartoldpos varchar(50);
set @oldchartname = (select Type from dbx.dbo.ChartPosition where Position=2);
set @movedchartoldpos = (select Position from dbx.dbo.ChartPosition where Type='column');

--print @movedchartoldpos;

-- Set position for the moved chart.
update dbx.dbo.ChartPosition set Position=2 where Type='column';
-- Set position for the old chart.
update dbx.dbo.ChartPosition set Position=@movedchartoldpos where Type=@oldchartname;