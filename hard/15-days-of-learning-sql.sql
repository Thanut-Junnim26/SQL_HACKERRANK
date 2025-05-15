-- MS SQL SERVER
with t1 as (
  select 
    submission_date, 
    hacker_id,
    dense_rank() over(order by submission_date) as each_day,
    row_number() over(partition by hacker_id order by submission_date) as streak
  from Submissions
  group by submission_date, hacker_id
), temp_streak_nums_user as (
  select submission_date, count(*) as streak_hacker
  from t1
  where each_day = streak
  group by submission_date
), t2 as (
  select 
    submission_date, 
    hacker_id,
    count(*) as max_num_sub
  from Submissions
  group by submission_date, hacker_id
), temp_max_num_sup as (
  select 
    submission_date,
    hacker_id,
    max_num_sub,
    row_number() over(partition by submission_date order by max_num_sub desc, hacker_id) as rnk
  from t2
), temp_max_num_sup_final as (
  select 
    submission_date, 
    hacker_id
  from temp_max_num_sup
  where rnk = 1
)
select 
  t1.submission_date,
  t2.streak_hacker,
  t1.hacker_id,
  t3.name
from temp_max_num_sup_final t1
  inner join temp_streak_nums_user t2 on t1.submission_date = t2.submission_date
  inner join Hackers t3 on t3.hacker_id = t1.hacker_id 
order by t1.submission_date