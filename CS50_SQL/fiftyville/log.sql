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
------------------------------------------------------------------------
-- RESULTS
-- Theft of the CS50 duck took place at 10:15am at the Chamberlin Street courthouse.
-- Interviews were conducted today with three witnesses who were present at the time — each of their interview transcripts mentions the courthouse.
-------------------------------------------------------------------------

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

------------------------------------------------------------------------
-- RESULTS
--id    year  mo.   day hr. min. activity   lic. plate
--231	2020	7	28	8	18	entrance	L93JTIZ
--232	2020	7	28	8	23	entrance	94KL13X
--237	2020	7	28	8	34	entrance	1106N58
--240	2020	7	28	8	36	entrance	322W7JE
--243	2020	7	28	8	42	entrance	0NTHK55
--254	2020	7	28	9	14	entrance	4328GD8
--255	2020	7	28	9	15	entrance	5P2BI95
--256	2020	7	28	9	20	entrance	6P58WS2
--257	2020	7	28	9	28	entrance	G412CB7
--258	2020	7	28	10	8	entrance	R3G7486
--259	2020	7	28	10	14	entrance	13FNH73
-------------------------------------------------------------------------