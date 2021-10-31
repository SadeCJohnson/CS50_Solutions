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