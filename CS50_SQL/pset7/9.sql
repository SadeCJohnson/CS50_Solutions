--In 9.sql, write a SQL query to list the names of all people who starred in a movie released in 2004, ordered by birth year.
-- Your query should output a table with a single column for the name of each person.
-- People with the same birth year may be listed in any order.
-- No need to worry about people who have no birth year listed, so long as those who do have a birth year are listed in order.
-- If a person appeared in more than one movie in 2004, they should only appear in your results once.
SELECT people.NAME
FROM   people
       JOIN stars
         ON people.id = stars.person_id
       JOIN movies
         ON movies.id = stars.movie_id
WHERE  movies.year IN ( 2004 )
GROUP  BY people.id
ORDER  BY people.birth,
          people.NAME;


-- ASIDE: write a query to show duplicate people.id that were getting collapsed by "group by" clause above
-- TECHNIQUE: {5,5,6,8} - {5,6,8} = {5}
SELECT people.id,
count(*)
FROM   people
       JOIN stars
         ON people.id = stars.person_id
       JOIN movies
         ON movies.id = stars.movie_id
WHERE  movies.year IN ( 2004 )
GROUP BY people.id
ORDER  BY count(*) DESC
