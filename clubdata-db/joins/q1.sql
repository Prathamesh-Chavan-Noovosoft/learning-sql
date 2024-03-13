-- Answer 1
select b.starttime
    from
        bookings b
        inner join members m
            using(memid)
    where
        m.firstname = 'David'
      and
        m.surname = 'Farrell';

-- Answer 2
select b.starttime
from
    bookings b
where
    b.memid = (
        select m.memid
        from
            members m
        where
            m.firstname = 'David'
          and m.surname = 'Farrell'
    );
