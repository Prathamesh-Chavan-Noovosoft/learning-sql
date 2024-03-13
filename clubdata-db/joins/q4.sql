select mem.firstname memfname, mem.surname memsname, rec.firstname recfname, rec.surname recsname
	from members mem
		left join members rec
			on mem.recommendedby = rec.memid
order by memsname, memfname;
