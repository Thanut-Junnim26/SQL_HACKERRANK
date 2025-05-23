SELECT h.hacker_id, h.name, t1.total_score
  FROM (
        SELECT hacker_id
            , SUM(max_score) AS total_score
          FROM (
                SELECT hacker_id
                        , challenge_id
                        , MAX(score) AS max_score
                  FROM Submissions
                GROUP BY hacker_id, challenge_id
               ) t
        GROUP BY hacker_id
        having SUM(max_score) != 0
       ) t1
  JOIN Hackers h
    ON h.hacker_id = t1.hacker_id
 ORDER BY total_score DESC, hacker_id;