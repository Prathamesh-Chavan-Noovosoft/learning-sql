select b.facid, sum(b.slots) "Total Slots" from cd.bookings b
		where b.starttime::date >= '2012-09-01'
		and b.starttime::date <= '2012-09-30'
		group by b.facid
order by sum(b.slots);
