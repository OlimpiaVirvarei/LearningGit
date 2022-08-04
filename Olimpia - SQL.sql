/*2. Tipuri de timesheet pe o luna*/

SELECT distinct u.last_name, u.first_name, tm.task_type
FROM user u
left join time_sheet tm
on tm.user_details_id = u.id
AND task_type = 'HOLIDAY' AND day_of_work BETWEEN '2022-05-01' AND '2022-05-30';

SELECT distinct u.last_name, u.first_name, tm.task_type
FROM user u
left join time_sheet tm
on tm.user_details_id = u.id
AND task_type = 'SICK' AND day_of_work BETWEEN '2022-05-01' AND '2022-05-30';

SELECT distinct u.last_name, u.first_name, tm.task_type
FROM user u
left join time_sheet tm
on tm.user_details_id = u.id
AND task_type = 'Other_events' AND day_of_work BETWEEN '2022-05-01' AND '2022-05-30';

SELECT distinct u.last_name, u.first_name, tm.task_type
FROM user u
left join time_sheet tm
on tm.user_details_id = u.id
AND task_type = 'timesheet' AND day_of_work BETWEEN '2022-05-01' AND '2022-05-30';




/*3. Tipuri de timesheet counted for each user*/

SELECT u.last_name, u.first_name, COUNT(tm.task_type) AS Holiday FROM user u
left join time_sheet tm
on task_type = 'HOLIDAY'AND day_of_work BETWEEN '2022-05-01' AND '2022-05-30'
AND tm.user_details_id = u.id
group by u.last_name;


SELECT u.last_name, u.first_name, COUNT(tm.task_type) AS Sick FROM user u
left join time_sheet tm
on task_type = 'SICK'AND day_of_work BETWEEN '2022-05-01' AND '2022-05-30'
AND tm.user_details_id = u.id
GROUP BY u.last_name;

SELECT u.last_name, u.first_name, COUNT(tm.task_type) AS OtherEvents FROM user u
left join time_sheet tm
on task_type = 'OTHER_EVENTS'AND day_of_work BETWEEN '2022-05-01' AND '2022-05-30'
AND tm.user_details_id = u.id
GROUP BY u.last_name;

SELECT u.last_name, u.first_name, COUNT(tm.task_type) AS Timesheet FROM user u
left join time_sheet tm
on task_type = 'TIMESHEET'AND day_of_work BETWEEN '2022-05-01' AND '2022-05-30'
AND tm.user_details_id = u.id
GROUP BY u.last_name;
 
 /*4.  Days of holiday more than 15 days*/
SELECT U.last_name, U.first_name, COUNT(T.task_type) AS DaysOfHoliday
FROM time_sheet T, user U
WHERE task_type = 'HOLIDAY'AND day_of_work BETWEEN '2022-01-01' AND '2022-12-31'
AND T.user_details_id = U.id
GROUP BY U.last_name
HAVING COUNT(T.task_type) > 15;



/* 5. Days more than 15*/
Select u.last_name,u.first_name,ud.no_of_vacations_days AS 'LeftOvers'
from user u, user_details ud
WHERE u.id=ud.user_id 
AND no_of_vacations_days>15
Group by last_name
Order by LeftOvers Desc;


 /*6.  Days of holiday more than 15 days, first five*/

SELECT U.last_name, COUNT(T.task_type) 
FROM time_sheet T, user U 
WHERE task_type = 'HOLIDAY'AND day_of_work BETWEEN '2022-01-01' AND '2022-12-31' AND T.user_details_id = U.id
GROUP BY U.last_name 
HAVING COUNT(T.task_type) > 15 LIMIT 5;

 /*7.  Days of holiday more than 15 days, next five*/
 
 SELECT U.last_name, COUNT(T.task_type) 
FROM time_sheet T, user U 
WHERE task_type = 'HOLIDAY'AND day_of_work BETWEEN '2022-01-01' AND '2022-12-31' AND T.user_details_id = U.id
GROUP BY U.last_name 
HAVING COUNT(T.task_type) > 15 LIMIT 5,5;



/* 8. Inactive users */
SELECT last_name, first_name,activated FROM user
WHERE activated = 'NULL';

/* 9.  Users more than 3 years in company*/
SELECT U.last_name, U.first_name,C.start_contract_date
FROM contract_details C, user U
WHERE C.start_contract_date <  CURRENT_DATE - INTERVAL 3 YEAR
AND C.id = U.id
ORDER BY start_contract_date ASC;

/*10. Users that have been in Germany at least once*/
SELECT DISTINCT u.first_name, u.last_name,tm.location 
FROM time_sheet tm, user u
WHERE tm.user_details_id = u.id
AND UPPER(tm.location) = 'BENSHEIM';

/*11. Users  that are/were in maternity leave*/

SELECT  DISTINCT tm.task_type, u.last_name, u.first_name FROM time_sheet tm, user u
WHERE u.id = tm.user_details_id
AND UPPER(task_type) = 'MATERNITY';



/* 12. TM grouped after their type*/
SELECT u.last_name, u.first_name,tm.task_type, COUNT(task_type) AS NoOfTM
FROM user u, time_sheet tm
WHERE u.id = tm.user_details_id
AND day_of_work BETWEEN '2022-06-01' AND '2022-06-30'
GROUP BY u.last_name, u.first_name,tm.task_type
ORDER BY 1 ASC;

SELECT u.last_name, u.first_name,tm.task_type, COUNT(task_type) AS NoOfTM
FROM user u
left join time_sheet tm
on u.id = tm.user_details_id
AND day_of_work BETWEEN '2022-06-01' AND '2022-06-30'
GROUP BY u.last_name, u.first_name,tm.task_type
ORDER BY 1 ASC;


/*13. Useri care si au facut autorecenzarea*/
SELECT tm.task_type, u.last_name, u.first_name,tm.task_details
FROM time_sheet tm, user u
WHERE u.id = tm.user_details_id
AND task_type = 'OTHER_EVENTS' AND  UPPER(task_details) = 'RECENSAMANT';


/* 14. Users born in 1998 */
SELECT DISTINCT u.last_name,u.first_name, pd.cnp 
FROM private_details pd, user_details ud, user u
WHERE ud.private_details_id = pd.id AND ud.user_id = u.id
AND cnp LIKE '198%' OR cnp LIKE '298%';

/*15. Date  */
Select u.first_name as 'Prenume',u.last_name as'Nume',pd.ci_series as'Serie CI',pd.ci_no as 'Numar CI',pd.cnp as 'CNP',a.city as 'Oras',cd.start_contract_date as 'Data_angajare',cd.contractual_hours as 'Numar ore contract',jt.name AS 'Nume functie interna'
FROM user u
LEFT join private_details pd
ON u.id=pd.id 
LEFT JOIN  address a
ON pd.id=a.id
LEFT JOIN contract_details cd
ON pd.id=cd.id
LEFT JOIN user_details ud
ON ud.id=u.id 
LEFT JOIN job_title_extern jt
ON ud.job_title_extern_id=jt.id 

Order by Data_angajare DESC;

Select u.first_name as 'Prenume',u.last_name as'Nume',pd.ci_series as'Serie CI',pd.ci_no as 'Numar CI',pd.cnp as 'CNP',a.city as 'Oras',cd.start_contract_date as 'Data_angajare',cd.contractual_hours as 'Numar ore contract',jt.name AS 'Nume functie interna'
FROM user u, private_details pd, address a, contract_details cd, user_details ud, job_title_extern jt
WHERE u.id=pd.id AND pd.id=a.id AND pd.id=cd.id AND ud.id=u.id AND ud.job_title_extern_id=jt.id
Order by Data_angajare DESC;


/* 16. Names that contain Alexandra*/
SELECT last_name, first_name 
FROM user
WHERE UPPER(first_name) LIKE '%ALEXANDRA%';


/*17. Structura de Date*/
SELECT CONCAT (u.first_name,' ',u.last_name) AS 'Name', CONCAT(pd.ci_series,' ',pd.ci_no) AS 'INFO'
FROM user u, private_details pd, user_details ud
WHERE ud.user_id = u.id AND pd.id = ud.private_details_id;


/*18. User > than 5 years- senior*/
SELECT CONCAT (u.first_name,' ',u.last_name) AS 'Name',CONCAT('senior'), cd.start_contract_date
FROM user u, private_details pd, user_details ud, contract_details cd
WHERE ud.user_id = u.id AND pd.id = ud.private_details_id AND cd.id = ud.contract_details_id
AND YEAR(cd.start_contract_date) < YEAR(CURRENT_DATE()) - 5;



/*19.Checking if they are seniors, juniors pr MID*/

SELECT u.first_name, u.last_name, c.start_contract_date,
CASE 
	WHEN start_contract_date > CURRENT_DATE - INTERVAL 1 YEAR THEN 'Junior'
    WHEN  start_contract_date <= CURRENT_DATE - INTERVAL 1 YEAR AND  start_contract_date > CURRENT_DATE - INTERVAL 3 YEAR THEN 'MID'
    WHEN start_contract_date <= CURRENT_DATE - INTERVAL 3 YEAR THEN 'Senior'
END AS RESULT
FROM contract_details c, user u, user_details ud
WHERE c.id = ud.contract_details_id AND ud.user_id = u.id;


/*20. Userii care nu s au pontat sapt asta*/
SELECT  u.id, concat(u.last_name,' ',u.first_name) AS 'Nume',concat('sapt_nepontata') AS 'notCompleted'
FROM user u
WHERE u.activated = 1
AND u.id NOT IN (SELECT user_details_id FROM time_sheet WHERE day_of_work BETWEEN '2022-06-20' AND '2022-06-24')
Group by last_name;


/*Deactivate the user*/

UPDATE user
SET activated = 0
WHERE last_name = 'Buzila' AND first_name = 'Gabriel' AND login = 'gabriel.buzila';

SELECT login, activated FROM user
WHERE login = 'gabriel.buzila';

/*Update to english for the first 5 users*/
UPDATE user
SET lang_key = 'en'
Limit 5;
SELECT * FROM user ;


/*Delete the location history*/

DELETE FROM location_history
WHERE user_details_id = 47;


INSERT INTO location_history (id, start_date, is_active, created_by, created_date, last_modified_by, last_modified_date, user_details_id, previous_id, actual_id) VALUES
(66, '2021-06-18', NULL, 'gabriel.buzila', '2021-06-18', 'gabriel.buzila', '2021-06-18', 47, 1, 2),
(67, '2021-06-18', NULL, 'gabriel.buzila', '2021-06-18', 'gabriel.buzila', '2021-06-18', 47, 2, 1);



SELECT u.id, u.first_name, u.last_name, l.id, l.name "locatie curenta" FROM
user_details ud
JOIN location l
ON l.id=ud.location_id
JOIN user u
ON u.id=ud.user_id
WHERE u.id=47;


Select lh.id, lh.user_details_id, lh.previous_id, lh.actual_id from location_history lh
Where user_details_id=47;

Select lh.previous_id from location_history lh
Where user_details_id=47
ORDER BY id desc
limit 1;

UPDATE user_details
set location_id=(
          Select lh.previous_id from location_history lh
          Where user_details_id=47
          ORDER BY id desc
          limit 1
)
WHERE id=47;



