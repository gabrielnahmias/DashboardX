update dbx.dbo.SampleData set LocationID=(
	case
		when DBAName='FASTWAY #1 TACO BELL'
		then 267529000000
		when DBAName='FASTWAY #2 TACO BELL'
		then 267529000001
		when DBAName='FASTWAY #3 TACO BELL'
		then 267529000002
		when DBAName='FASTWAY #4 TACO BELL'
		then 267529000003
		when DBAName='FASTWAY #5 TACO BELL'
		then 267529000004
		else 267529000000
	end
);