update dbx.dbo.SampleData set Color=(
	case
		when DBAName='FASTWAY #1 TACO BELL'
		then 'Red'
		when DBAName='FASTWAY #2 TACO BELL'
		then 'Orange'
		when DBAName='FASTWAY #3 TACO BELL'
		then 'Yellow'
		when DBAName='FASTWAY #4 TACO BELL'
		then 'Blue'
		when DBAName='FASTWAY #5 TACO BELL'
		then 'Green'
	end
);