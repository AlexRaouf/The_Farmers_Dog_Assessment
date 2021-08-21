-- First Checking for duplicate users in our database. By definition each user only has 24 hour period that counts towards our experiment, so any duplicates will need to be removed
SELECT 
    user_id, 
    COUNT(*) as counts
FROM `tfdalexanderraouf.assessment_01.experiment`
GROUP BY 1
HAVING counts > 1;

-- Looking at all duplicated users
SELECT 
    e1.*, e2.counts
FROM `tfdalexanderraouf.assessment_01.experiment` e1
JOIN (
    SELECT 
        user_id, 
        COUNT(*) as counts
    FROM `tfdalexanderraouf.assessment_01.experiment`
    GROUP BY 1
    HAVING counts > 1
) e2
ON e1.user_id = e2.user_id
ORDER BY e1.user_id, e1.day_of_experiment;

-- Creating a temp table where the additional entries will be removed
CREATE TABLE `tfdalexanderraouf.assessment_01.experimentCleaned`
OPTIONS(
    expiration_timestamp=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 3 DAY)
) AS
SELECT 
    e.*,
    RANK() OVER (PARTITION BY user_id ORDER BY day_of_experiment ASC) as login_rank
FROM `tfdalexanderraouf.assessment_01.experiment` e;

-- Remove the second logins from select users
DELETE FROM `tfdalexanderraouf.assessment_01.experimentCleaned`
WHERE login_rank != 1;

-- Double checking that all second logins have been removed
SELECT * FROM `tfdalexanderraouf.assessment_01.experimentCleaned`
WHERE user_id IN ( 
    SELECT 
        user_id, 
    FROM `tfdalexanderraouf.assessment_01.experimentCleaned`
    GROUP BY 1
    HAVING count(*) > 1);

-- User 557105889 has logged in twice on the same day. We will combine the minutes listened during the experiment for them for both logins.
UPDATE `tfdalexanderraouf.assessment_01.experimentCleaned`
SET minutes_listening_during_experiment = (SELECT SUM(minutes_listening_during_experiment) 
                                            FROM `tfdalexanderraouf.assessment_01.experimentCleaned`
                                            WHERE user_id = 557105889
    )
WHERE user_id = 557105889;

-- Removing the second entry for user 557105889 and removing the login_rank column
CREATE OR REPLACE TABLE `tfdalexanderraouf.assessment_01.experimentCleaned`
AS
SELECT DISTINCT * EXCEPT (login_rank) FROM `tfdalexanderraouf.assessment_01.experimentCleaned`;

-- Checking to make sure our second entry for user 557105889 was duplicated
SELECT * FROM `tfdalexanderraouf.assessment_01.experimentCleaned`
WHERE user_id = 557105889;




-- Checking to see that our control and experiment groups are even. Since participants are placed into control or treatment via a coin flip, we expect the control and treatment groups to have the same number of participants.
SELECT
    experiment_cohort,
    COUNT(*) as counts
FROM `tfdalexanderraouf.assessment_01.experimentCleaned`
GROUP BY 1;

-- Exploring why the counts are off. Maybe there is a noticable bug in our data.
-- First I'm checking if there might be a large discrepancy in one specific day of experiment between the experiment_cohort

SELECT * FROM (
    SELECT 
        user_id,
        experiment_cohort,
        day_of_experiment
    FROM `tfdalexanderraouf.assessment_01.experimentCleaned`) AS BaseData

PIVOT (
    COUNT(user_id)
    FOR day_of_experiment
    IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29)
) AS PivotTable;

-- Next checking for any discrepancies in device_type
SELECT * FROM (
    SELECT 
        user_id,
        experiment_cohort,
        device_type
    FROM `tfdalexanderraouf.assessment_01.experimentCleaned`) AS BaseData

PIVOT (
    COUNT(user_id)
    FOR device_type
    IN ('desktop', 'mobile', 'tablet')
) AS PivotTable;
/* It looks like there are siz times as many control participants in the desktop device */

-- Checking for discrepancies in gender
SELECT * FROM (
    SELECT 
        user_id,
        experiment_cohort,
        gender
    FROM `tfdalexanderraouf.assessment_01.experimentCleaned`) AS BaseData

PIVOT (
    COUNT(user_id)
    FOR gender
    IN ('F', 'M', 'X')
) AS PivotTable;
/* It looks like there are three times as many control participants in each gender */

-- Checking for discrepancies in region
SELECT * FROM (
    SELECT 
        user_id,
        experiment_cohort,
        region
    FROM `tfdalexanderraouf.assessment_01.experimentCleaned`) AS BaseData

PIVOT (
    COUNT(user_id)
    FOR region
    IN ('midwest', 'northeast', 'south', 'west')
) AS PivotTable;
/* It looks like there are three times as many control participants in each region */


-- Taking a more ganular look into the discrepancies we saw above
SELECT * FROM (
    SELECT 
        user_id,
        experiment_cohort,
        device_type,
        gender
        region
    FROM `tfdalexanderraouf.assessment_01.experimentCleaned`) AS BaseData

PIVOT (
    COUNT(user_id)
    FOR region
    IN ('midwest', 'northeast', 'south', 'west')
) AS PivotTable;

-- Checking average minutes listened during the experiment, and standard deviation of minutes listened to
-- during the experiment for both treatment and control groups
SELECT 
    experiment_cohort,
    AVG(minutes_listening_during_experiment) as avg_minutes_listened,
    STDDEV(minutes_listening_during_experiment) as std_minutes_listened
FROM `tfdalexanderraouf.assessment_01.experimentCleaned`
GROUP BY experiment_cohort; 

-- BONUS QUESTION
-- How many users does the business have in total on the last day of the experiment?
SELECT ROUND(COUNT(DISTINCT user_id) * (100/19.73)) as total_users 
FROM `tfdalexanderraouf.assessment_01.experiment`;