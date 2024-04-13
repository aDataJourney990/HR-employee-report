-- Questions to solve;

-- 1. What is the gender breakdown of employees in the company?
SELECT gender,COUNT(*) AS COUNT
FROM hr
WHERE age>= 18 AND termdate IS NULL
GROUP BY gender;

-- 2. What is the race/ ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS COUNT
FROM hr
WHERE age>= 18 AND termdate IS NULL
GROUP BY race
ORDER BY COUNT(*) DESC;

-- 3. What is the age distribution of employees in the company?
SELECT
	min(age) AS youngest,
    max(age) AS oldest
FROM hr
WHERE age>= 18 AND termdate IS NULL;

SELECT
	CASE
		WHEN age>=18 AND age <= 23 THEN 'Interns'
        WHEN age>=24 AND age <= 35 THEN 'full-time employees'
        WHEN age>=36 AND age <= 50 THEN 'Mid career professionals'
        WHEN age>=50 AND age <= 58 THEN 'Senior professionals'
        ELSE '65+'
	END AS age_group, gender,
    COUNT(*) AS COUNT
FROM hr
WHERE age>= 18 AND termdate IS NULL
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headaquarters versus remote locations and by gender too?
SELECT location, COUNT(*) AS COUNT, gender
FROM hr
WHERE age>= 18 AND termdate IS NULL
GROUP BY location, gender;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT
	round(avg(DATEDIFF(termdate, hire_date))/365,0) AS avg_employment_length
FROM hr
WHERE termdate <= CURDATE() AND termdate IS NOT NULL AND age >= 18;

-- 6. How does gender distribution vary across departments and job titles?
SELECT department, gender, COUNT(*) AS COUNT
FROM hr
WHERE age>= 18 AND termdate IS NULL
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job_titles across the company?
SELECT jobtitle,gender, COUNT(*) AS COUNT
FROM hr
WHERE age>= 18 AND termdate IS NULL
GROUP BY jobtitle, gender
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?
SELECT department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM (
	SELECT department,
    COUNT(*) AS total_count,
    SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age>= 18
    GROUP BY department
    ) AS subquery
ORDER BY termination_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, COUNT(*) AS COUNT
FROM hr
WHERE age>= 18 AND termdate IS NULL
GROUP BY location_state
ORDER BY COUNT DESC;

-- 10. How has company employee's count changed over time based on hire and term dates?
SELECT
	year,
    hires,
    terminations,
    hires - terminations AS net_change,
    round((hires - terminations) / hires * 100,2) AS net_change_percent
FROM(
	SELECT YEAR(hire_date) AS year,
    COUNT(*) as hires,
    SUM(CASE WHEN termdate IS NOT NULL AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
FROM hr
WHERE age>= 18
GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;

-- 11. Tenure distribution for each department?
SELECT department, round(avg(DATEDIFF(termdate, hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate IS NOT NULL AND termdate <= CURDATE() AND age >= 18
GROUP BY department;








