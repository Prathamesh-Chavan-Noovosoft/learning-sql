select recommendedby, count(*) from members
		where recommendedby is not null
		group by recommendedby
order by recommendedby;
