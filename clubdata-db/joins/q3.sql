select distinct mems.memid,recs.firstname || ' ' || recs.surname reccomended, mems.firstname firstname, mems.surname surname
	from members mems
			inner join members recs on
					mems.memid = recs.recommendedby
	order by surname, firstname;
