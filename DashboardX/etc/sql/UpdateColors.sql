--declare @color varchar(50), @date varchar(50);
--set @color = 'Gold', @date = '05/27/2013';

update dbx.dbo.SampleData set Color=(
	case
		when cast(SubmitDate as date) = '05/27/2013' or
			 cast(SubmitDate as date) = '06/03/2013' or
			 cast(SubmitDate as date) = '06/10/2013' or
			 cast(SubmitDate as date) = '06/17/2013'
			 then 'Red'
		when cast(SubmitDate as date) = '05/28/2013' or
			 cast(SubmitDate as date) = '06/04/2013' or
			 cast(SubmitDate as date) = '06/11/2013' or
			 cast(SubmitDate as date) = '06/18/2013'
			 then 'Yellow'
		when cast(SubmitDate as date) = '05/29/2013' or
			 cast(SubmitDate as date) = '06/05/2013' or
			 cast(SubmitDate as date) = '06/12/2013' or
			 cast(SubmitDate as date) = '06/19/2013'
			 then 'Green'
		when cast(SubmitDate as date) = '05/30/2013' or
			 cast(SubmitDate as date) = '06/01/2013' or
			 cast(SubmitDate as date) = '06/06/2013' or
			 cast(SubmitDate as date) = '06/08/2013' or
			 cast(SubmitDate as date) = '06/13/2013' or
			 cast(SubmitDate as date) = '06/15/2013' or
			 cast(SubmitDate as date) = '06/20/2013'
			 then 'Blue'
		when cast(SubmitDate as date) = '05/31/2013' or
			 cast(SubmitDate as date) = '06/02/2013' or
			 cast(SubmitDate as date) = '06/07/2013' or
			 cast(SubmitDate as date) = '06/09/2013' or
			 cast(SubmitDate as date) = '06/14/2013' or
			 cast(SubmitDate as date) = '06/16/2013' or
			 cast(SubmitDate as date) = '06/21/2013'
			 then 'Violet'
	end
);