select mem.firstname || ' ' || mem.surname member, fac.name facility,
		case
			when mem.memid = 0
				then fac.guestcost * boo.slots
			else
				fac.membercost * boo.slots
			end as cost
		from members mem
			inner join bookings boo using (memid)
			inner join facilities fac on boo.facid = fac.facid
		where
			boo.starttime::date = '2012-09-14' and
			((mem.memid = 0 and fac.guestcost * boo.slots > 30) or
			 (mem.memid != 0 and fac.membercost * boo.slots > 30))
order by fac.membercost desc;

