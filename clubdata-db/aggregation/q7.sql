select count(*) from
	(select distinct memid from cd.bookings) as count
