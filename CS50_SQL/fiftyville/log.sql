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

select * from courthouse_security_logs
where hour = 10
and minute = 15;
------------------------
-- RESULTS
-- id=459, year=2020, month=7, day=31, hour=10,	minute=15, activity=exit, license plate=11J91FW
-------------------------
select * from people where license_plate = '11J91FW';
------------------------
-- RESULTS: so Noah is the ony person to left the courthouse at the hour of 10:15 but this occurred 3 days after the crime so there's something wrong here!
-- id=37552, name=Noah,	phone_number=(959)-555-4871, passport_number=1095374669, license_plate=11J91FW
-------------------------

SELECT *
FROM   phone_calls
WHERE  caller = '(959) 555-4871'
       AND month = 7
       AND day = 31;

------------------------
-- RESULTS
-- id=494, caller=(959) 555-4871, receiver=(839) 555-1757, year=2020, month=7, day=31, duration=257
-------------------------