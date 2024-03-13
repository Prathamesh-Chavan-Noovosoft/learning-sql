select b.facid, sum(b.slots) "Total Slots" from bookings b
group by b.facid
order by b.facid;


