select starttime start, f.name
	from bookings b
		inner join facilities f
			using(facid)
	where
		f.name like 'Tennis Court%'
		and starttime::date = '2012-09-21'
order by
	starttime::time
