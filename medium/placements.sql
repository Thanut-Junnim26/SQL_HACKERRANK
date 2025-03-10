select t1.my_name
from (
    select 
        friend.friend_name as friend_name
        , friend.friend_id as friend_id
        , friend.friend_salary as friend_salary 
        , my.name as my_name
        , my.id as my_id 
        , p.salary as my_salary
    from students my
        inner join (
            select 
                f.friend_id as friend_id
                , f.id as id
                , s.name as friend_name
                , p.salary as friend_salary
            from friends f
                inner join students s on s.id = f.id
                inner join packages p on p.id = f.friend_id
        ) friend on friend.id = my.id
        inner join packages p on p.id = my.id
    ) t1
where t1.friend_salary > t1.my_salary
order by t1.friend_salary
