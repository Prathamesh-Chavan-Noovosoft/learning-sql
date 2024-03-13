select b.facid, sum(b.slots) "Total Slots" from bookings b
group by b.facid
having sum(b.slots) > 1000
order by b.facid;
