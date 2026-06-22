/*
Answer: What are the most optimal skills to learn 
(aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries 
  for Data Analyst roles.
- Concentrates on remote positions with specified salaries.
- Why? Targets skills that offer job security (high demand) 
  and financial benefits (high salaries), offering strategic
  insights for career development in data analysis.
*/

WITH skills_demand AS ( -- THIS IS FROM THE 3rd FILE OF OUR PROJECT
    SELECT 
        skills,
        COUNT (skills_job_dim.job_id) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND -- to look for remote job
        job_work_from_home = True
    GROUP BY
        skills
    ORDER BY
        demand_count DESC
    LIMIT 5
)

WITH average_salary AS ( -- THIS IS FROM THE 4th FILE OF OUR PROJECT
    SELECT 
        skills,
    ROUND (AVG (salary_year_avg), 0) AS avg_salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY
        skills
    ORDER BY
        avg_salary DESC
    LIMIT 25
)

/* 
we will add changes to the work from the previous sections. 
We will be connecting both tables by adding skill_id. 
We will erase the order by and limit.
And copy salary not being null from table 4 to table 3.
Lastly we will combine them adding another select clause at the bottom
*/

WITH skills_demand AS ( -- THIS IS FROM THE 3rd FILE OF OUR PROJECT
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT (skills_job_dim.job_id) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND -- to look for remote job
        job_work_from_home = True
        AND salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
),  average_salary AS ( -- THIS IS FROM THE 4th FILE OF OUR PROJECT (WITH is removed)
    SELECT
        skills_job_dim.skill_id,
        ROUND (AVG (salary_year_avg), 0) AS avg_salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY
        skills_job_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM 
    skills_demand
INNER JOIN average_salary 
ON skills_demand.skill_id = average_salary.skill_id
-- now we will use ORDER BY and LIMIT clauses
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25

-- The above work was to demonstrate how to use CTEs. Now we will use a shorter way to get it done.

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT (skills_job_dim.job_id) AS demand_count,
    ROUND (AVG (job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills_dim.skill_id
HAVING 
    COUNT (skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;