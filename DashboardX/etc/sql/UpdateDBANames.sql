update dbx.dbo.SampleData set DBAName=(
	case
		when LocationID=267529000000
		then 'FASTWAY #1 TACO BELL'
		when LocationID=267529000001
		then 'FASTWAY #2 TACO BELL'
		when LocationID=267529000002
		then 'FASTWAY #3 TACO BELL'
		when LocationID=267529000003
		then 'FASTWAY #4 TACO BELL'
		when LocationID=267529000004
		then 'FASTWAY #5 TACO BELL'
	end
);