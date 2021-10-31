-- Keep a log of any SQL queries you execute as you solve the mystery.

------------------------
-- RELATIONSHIPS BETWEEN TABLES
-- bank_accounts (person_id is foreign key) -> people
-- flights (origin_airport_id is foreign key & destination_airport_id is foreign key) -> airports, airports
-- passengers (flight_id is foreign key) -> flights
------------------------


-- Initial starting point!
SELECT description
FROM   crime_scene_reports
WHERE  street = 'Chamberlin Street'
       AND month = 7
       AND day = 28
       AND year = 2020 ;
------------------------
-- RESULTS
-- Theft of the CS50 duck took place at 10:15am at the Chamberlin Street courthouse.
-- Interviews were conducted today with three witnesses who were present at the time — each of their interview transcripts mentions the courthouse.
-------------------------

-- REASONING: this is a listing of all those who entered the courthouse prior to 10:15am on July 28th
-- NOTE: Query has also been sanitized of those who have exited before that time to reduce scope

SELECT *
FROM   courthouse_security_logs
WHERE  month = 7
       AND day = 28
       AND hour <= 10
       AND activity = 'entrance'
       AND license_plate NOT IN (SELECT license_plate
                                 FROM   courthouse_security_logs
                                 WHERE  month = 7
                                        AND day = 28
                                        AND hour <= 10
                                        AND activity = 'exit'
                                 EXCEPT
                                 SELECT license_plate
                                 FROM   courthouse_security_logs
                                 WHERE  month = 7
                                        AND day = 28
                                        AND hour >= 10
                                        AND minute > 14
                                        AND activity = 'exit')
EXCEPT
SELECT *
FROM   courthouse_security_logs
WHERE  month = 7
       AND day = 28
       AND hour >= 10
       AND minute > 14
       AND activity = 'entrance';
