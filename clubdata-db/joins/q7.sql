select distinct m.firstname || ' ' ||  m.surname member,
		(select r.firstname || ' ' || r.surname recommender
		 	from members r
		 	where
		 		m.recommendedby = r.memid
		)
	from members m
order by member;
