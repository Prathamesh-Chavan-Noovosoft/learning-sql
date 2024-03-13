-- can't use using in the second join, since there are 3 tables.
select distinct mem.firstname || ' ' || mem.surname member, fac.name facility
		from members mem
			inner join bookings boo using (memid)
			inner join facilities fac on boo.facid = fac.facid
		where
			fac.name like 'Tennis Court%'
order by member, fac.name;
