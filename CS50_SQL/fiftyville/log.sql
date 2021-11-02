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
-- RESULTS:
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
       AND activity = 'entrance'
ORDER  BY hour;

------------------------------------------------------------------------
-- RESULTS:
--[id, year, month, day, hour, minute, activity, license plate]
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


-- CONFIRMATION: Confirming all those people left after 10:15am on July 28, 2020

 SELECT *
FROM   courthouse_security_logs
WHERE  license_plate IN (SELECT license_plate
                         FROM   courthouse_security_logs
                         WHERE  month = 7
                                AND day = 28
                                AND hour <= 10
                                AND activity = 'entrance'
                                AND license_plate NOT IN (SELECT license_plate
                                                          FROM
                                    courthouse_security_logs
                                                          WHERE  month = 7
                                                                 AND day = 28
                                                                 AND hour <= 10
                                                                 AND activity =
                                                                     'exit'
                                                          EXCEPT
                                                          SELECT license_plate
                                                          FROM
                                    courthouse_security_logs
                                                          WHERE  month = 7
                                                                 AND day = 28
                                                                 AND hour >= 10
                                                                 AND minute > 14
                                                                 AND activity =
                                                                     'exit')
                         EXCEPT
                         SELECT license_plate
                         FROM   courthouse_security_logs
                         WHERE  month = 7
                                AND day = 28
                                AND hour >= 10
                                AND minute > 14
                                AND activity = 'entrance')
       AND month = 7
       AND day = 28
       AND activity = 'exit'
ORDER  BY hour;

------------------------------------------------------------------------
-- CONFIRMATION RESULTS:
--[id, year, month, day, hour, minute, activity, license plate]
--260	2020	7	28	10	16	exit	5P2BI95
--261	2020	7	28	10	18	exit	94KL13X
--262	2020	7	28	10	18	exit	6P58WS2
--263	2020	7	28	10	19	exit	4328GD8
--264	2020	7	28	10	20	exit	G412CB7
--265	2020	7	28	10	21	exit	L93JTIZ
--266	2020	7	28	10	23	exit	322W7JE
--267	2020	7	28	10	23	exit	0NTHK55
--268	2020	7	28	10	35	exit	1106N58
--288	2020	7	28	17	15	exit	13FNH73
--290	2020	7	28	17	18	exit	R3G7486
-------------------------------------------------------------------------

 SELECT *
FROM   people
WHERE  license_plate IN (SELECT license_plate
                         FROM   courthouse_security_logs
                         WHERE  month = 7
                                AND day = 28
                                AND hour <= 10
                                AND activity = 'entrance'
                                AND license_plate NOT IN (SELECT license_plate
                                                          FROM
                                    courthouse_security_logs
                                                          WHERE  month = 7
                                                                 AND day = 28
                                                                 AND hour <= 10
                                                                 AND activity =
                                                                     'exit'
                                                          EXCEPT
                                                          SELECT license_plate
                                                          FROM
                                    courthouse_security_logs
                                                          WHERE  month = 7
                                                                 AND day = 28
                                                                 AND hour >= 10
                                                                 AND minute > 14
                                                                 AND activity =
                                                                     'exit')
                         EXCEPT
                         SELECT license_plate
                         FROM   courthouse_security_logs
                         WHERE  month = 7
                                AND day = 28
                                AND hour >= 10
                                AND minute > 14
                                AND activity = 'entrance'
                         ORDER  BY license_plate)
ORDER  BY license_plate;
------------------------------------------------------------------------
-- RESULTS:
--[id, name, phone_number, passport_number, license plate]
--560886	Evelyn	(499) 555-9472	8294398571	0NTHK55
--449774	Madison	(286) 555-6063	1988161715	1106N58
--745650	Sophia	(027) 555-1068	3642612721	13FNH73
--514354	Russell	(770) 555-1861	3592750733	322W7JE
--467400	Danielle(389) 555-5198	8496433585	4328GD8
--221103	Patrick	(725) 555-4692	2963008352	5P2BI95
--243696	Amber	(301) 555-4174	7526138472	6P58WS2
--686048	Ernest	(367) 555-5533	5773159633	94KL13X
--398010	Roger	(130) 555-0289	1695452385	G412CB7
--396669	Elizabeth(829) 555-5269	7049073643	L93JTIZ
--325548	Brandon	(771) 555-6667	7874488539	R3G7486
-------------------------------------------------------------------------
-- Reasoning: we have list of suspects but require more context.
-- Recall that 'crime_scene_reports' mentioned there exists 3 transcriptions from witnesses
SELECT *
FROM   interviews
WHERE  transcript LIKE '%thief%'
       AND month = 7
       AND day = 28
       AND year = 2020;

------------------------------------------------------------------------
-- RESULTS:
--[id, name, year, month, day, transcript]
-- 161	Ruth	2020	7	28	Sometime within ten minutes of the theft,
-- I saw the thief get into a car in the courthouse parking lot and drive away.
-- If you have security footage from the courthouse parking lot,
-- you might want to look for cars that left the parking lot in that time frame.

--[id, name, year, month, day, transcript]
-- 162	Eugene	2020	7	28	I don't know the thief's name, but it was someone I recognized.
-- Earlier this morning, before I arrived at the courthouse,
-- I was walking by the ATM on Fifer Street and saw the thief there withdrawing some money.

--[id, name, year, month, day, transcript]
-- 163	Raymond	2020	7	28	As the thief was leaving the courthouse,
-- they called someone who talked to them for less than a minute.
-- In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
-- The thief then asked the person on the other end of the phone to purchase the flight ticket.
-------------------------------------------------------------------------

SELECT courthouse_security_logs.year,
       courthouse_security_logs.month,
       courthouse_security_logs.day,
       courthouse_security_logs.hour,
       courthouse_security_logs.minute,
       activity,
       courthouse_security_logs.license_plate,
       people.NAME
FROM   courthouse_security_logs
       INNER JOIN people
               ON people.license_plate = courthouse_security_logs.license_plate
WHERE  people.license_plate IN (SELECT people.license_plate
                                FROM   people
                                WHERE  NAME = 'Raymond'
                                        OR NAME = 'Ruth'
                                        OR NAME = 'Eugene')
ORDER  BY month,
          day;
------------------------------------------------------------------------
-- RESULTS: Based on their license plates, how could any one of these folks be a witness if they never stepped
-- foot into the courthouse on July, 28th 2020?? One plausible reason if they took another means of transportation not
-- picked up by the courthouse_security_logs. This is surely negligible as their testimony has greater importance than
-- their date of appearance. Probably something that could be tweaked to give the story more validity.
--[year, month, day, hour, minute, activity, license plate, name]
--2020	7	26	13	22	entrance	47592FJ	Eugene
--2020	7	26	17	27	exit	        47592FJ	Eugene
--2020	7	29	11	44	entrance	Y18DLY3	Raymond
--2020	7	29	13	11	exit	        Y18DLY3	Raymond
--2020	7	30	8	53	entrance	47592FJ	Eugene
--2020	7	30	15	45	exit	        47592FJ	Eugene
-------------------------------------------------------------------------

-- KEY NOTES:
-- (1) thief took earliest flight out of Fiftyville on 7/29/2020
-- (2) talked to accomplice for less than 1 minute
-- (3) accomplice purchased flight ticket for thief
-- (4) thief withdrew from the ATM on Fifer Street
-- (5) left within 10 min after the theft at 10:15am

-- With given clues, we can simplify query above on lines 76 - 113:
SELECT *
FROM   courthouse_security_logs
WHERE  activity = 'exit'
       AND month = 7
       AND day = 28
       AND hour = 10
       AND minute >= 15
       AND minute <= 25;

------------------------------------------------------------------------
--RESULTS:
--[id, year, month, day, hour, minute, activity, license plate]
--260	2020	7	28	10	16	exit	5P2BI95
--261	2020	7	28	10	18	exit	94KL13X
--262	2020	7	28	10	18	exit	6P58WS2
--263	2020	7	28	10	19	exit	4328GD8
--264	2020	7	28	10	20	exit	G412CB7
--265	2020	7	28	10	21	exit	L93JTIZ
--266	2020	7	28	10	23	exit	322W7JE
--267	2020	7	28	10	23	exit	0NTHK55
-------------------------------------------------------------------------

-- This query was formulated on the tip that the thief called someone
-- for less than a minute.
-- As a recap, this query returns those who called and had a convo less than 1 minute
-- after leaving the scene and then drove off within 10 min after crime
SELECT people.NAME,
       passport_number,
       phone_calls.caller,
       phone_calls.receiver,
       year,
       day,
       month,
       duration
FROM   phone_calls
       INNER JOIN people
               ON people.phone_number = phone_calls.caller
WHERE  caller IN (SELECT phone_number
                  FROM   people
                  WHERE  license_plate IN (SELECT license_plate
                                           FROM   courthouse_security_logs
                                           WHERE  activity = 'exit'
                                                  AND month = 7
                                                  AND day = 28
                                                  AND hour = 10
                                                  AND minute >= 15
                                                  AND minute <= 25))
       AND year = 2020
       AND month = 7
       AND day = 28
       AND duration < 60;

------------------------------------------------------------------------
--RESULTS: when we uncover thief, we shall backtrack here as the accomplice is receiver!
--[name, passport, caller, receiver, year, month, day, duration]
--Roger 	1695452385	(130) 555-0289	(996) 555-8899	2020	28	7	51
--Evelyn	8294398571	(499) 555-9472	(892) 555-8872	2020	28	7	36
--Ernest	5773159633	(367) 555-5533	(375) 555-8161	2020	28	7	45
--Evelyn	8294398571	(499) 555-9472	(717) 555-1342	2020	28	7	50
--Russell	3592750733	(770) 555-1861	(725) 555-3243	2020	28	7	49

------------------------------------------------------------------------
-- this query returns the names of those who withdrew at Fifer Street
-- the day of the incident
SELECT *
FROM   bank_accounts
       INNER JOIN people
               ON people.id = bank_accounts.person_id
WHERE  account_number IN (SELECT account_number
                          FROM   atm_transactions
                          WHERE  year = 2020
                                 AND month = 7
                                 AND day = 28
                                 AND transaction_type = 'withdraw'
                                 AND atm_location = 'Fifer Street');

------------------------------------------------------------------------
--[account_number, person_id, creation_year, id, name, phone_number, passport, license_plate]
--49610011	686048	2010	686048	Ernest	    (367) 555-5533	5773159633	94KL13X
--26013199	514354	2012	514354	Russell	    (770) 555-1861	3592750733	322W7JE
--16153065	458378	2012	458378	Roy	        (122) 555-4581	4408372428	QX4YZN3
--28296815	395717	2014	395717	Bobby	    (826) 555-1652	9878712108	30G67EN
--25506511	396669	2014	396669	Elizabeth	(829) 555-5269	7049073643	L93JTIZ
--28500762	467400	2014	467400	Danielle	(389) 555-5198	8496433585	4328GD8
--76054385	449774	2015	449774	Madison	    (286) 555-6063	1988161715	1106N58
--81061156	438727	2018	438727	Victoria	(338) 555-6650	9586786673	8X428L0

------------------------------------------------------------------------
-- Intersecting those who withdrew at Fifer Street from the listing of those
-- who had a phone call for less than 1 minute and drove off within 10 min of the scene,
-- both Ernest and Russell fit the description so one of them must be the thief.
-- Now, with 3 more tables: flights, passengers, and airports, we can eliminate one of them

 SELECT people.NAME
FROM   phone_calls
       INNER JOIN people
               ON people.phone_number = phone_calls.caller
WHERE  caller IN (SELECT phone_number
                  FROM   people
                  WHERE  license_plate IN (SELECT license_plate
                                           FROM   courthouse_security_logs
                                           WHERE  activity = 'exit'
                                                  AND month = 7
                                                  AND day = 28
                                                  AND hour = 10
                                                  AND minute >= 15
                                                  AND minute <= 25))
       AND year = 2020
       AND month = 7
       AND day = 28
       AND duration < 60
INTERSECT
SELECT people.NAME
FROM   bank_accounts
       INNER JOIN people
               ON people.id = bank_accounts.person_id
WHERE  account_number IN (SELECT account_number
                          FROM   atm_transactions
                          WHERE  year = 2020
                                 AND month = 7
                                 AND day = 28
                                 AND transaction_type = 'withdraw'
                                 AND atm_location = 'Fifer Street');
------------------------------------------------------------------------
--RESULTS:
-- [name]
-- Russell
-- Ernest
------------------------------------------------------------------------