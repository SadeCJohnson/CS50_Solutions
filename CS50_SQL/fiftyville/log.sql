-- Keep a log of any SQL queries you execute as you solve the mystery.


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