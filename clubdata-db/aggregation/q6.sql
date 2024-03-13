select b.facid, extract(month from b.starttime) as month, sum(b.slots) as "Total Slots" from cd.bookings b
		where b.starttime::date >= '2012-01-01'
		and b.starttime::date <= '2012-12-31'
		group by b.facid, month
order by b.facid, month;
