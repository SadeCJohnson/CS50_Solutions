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
ORDER  BY license_plate;

------------------------------------------------------------------------
-- RESULTS:
--[id, year, month, day, hour, minute, activity, license plate]
--243	2020	7	28	8	42	entrance	0NTHK55
--237	2020	7	28	8	34	entrance	1106N58
--259	2020	7	28	10	14	entrance	13FNH73
--240	2020	7	28	8	36	entrance	322W7JE
--254	2020	7	28	9	14	entrance	4328GD8
--255	2020	7	28	9	15	entrance	5P2BI95
--256	2020	7	28	9	20	entrance	6P58WS2
--232	2020	7	28	8	23	entrance	94KL13X
--257	2020	7	28	9	28	entrance	G412CB7
--231	2020	7	28	8	18	entrance	L93JTIZ
--258	2020	7	28	10	8	entrance	R3G7486
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
ORDER  BY license_plate;

------------------------------------------------------------------------
-- CONFIRMATION RESULTS:
--[id, year, month, day, hour, minute, activity, license plate]
--267	2020	7	28	10	23	  exit      0NTHK55
--268	2020	7	28	10	35	  exit      1106N58
--288	2020	7	28	17	15	  exit	    13FNH73
--266	2020	7	28	10	23	  exit	    322W7JE
--263	2020	7	28	10	19	  exit	    4328GD8
--260	2020	7	28	10	16	  exit      5P2BI95
--262	2020	7	28	10	18	  exit      6P58WS2
--261	2020	7	28	10	18	  exit      94KL13X
--264	2020	7	28	10	20	  exit      G412CB7
--265	2020	7	28	10	21	  exit      L93JTIZ
--290	2020	7	28	17	18	  exit	    R3G7486
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
--2020	7	26	17	27	exit	         47592FJ	Eugene
--2020	7	29	11	44	entrance	Y18DLY3	Raymond
--2020	7	29	13	11	exit	         Y18DLY3	Raymond
--2020	7	30	8	53	entrance	47592FJ	Eugene
--2020	7	30	15	45	exit	         47592FJ	Eugene
-------------------------------------------------------------------------