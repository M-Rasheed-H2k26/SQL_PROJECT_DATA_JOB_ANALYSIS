# Introduction
Dive into the data job market! Focusing on data analyst roles,
this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.

SQL queries? Check them out here: [project_sql folder](/project_sql/)

# Background
Driven by my quest to navigate the data analyst job msarket more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

Data hails from Luke Barousse's [SQL Course](https://lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.

### The questions that were answered in the SQL queries were:
1. What are the top-paying Data Analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in-demand for Data Analyst?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn? 

# Tools I Used
For this project, several key tools were used :

- **SQL** : The backbone of this analysis. It allows to query the database and unearth critical insights.
- **PostgreSQL** : The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code** : My go-to for database management and executing SQL queries.
- **Git & Github** : Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. 
Here's how each question was approached: 

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS comapny_name 
FROM 
    job_postings_fact
LEFT JOIN company_dim 
ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
Here's the breakdown of the top Data Analyst jobs in 2023:
- **Wide Salary Range :** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers :** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety :** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

![Top Paying Roles](assets\top_paying_data_analyst_roles.png)
*Bar graph visualizing the salary for the top 10 salaries for Data Analysts; ChatGPT generated this graph from the SQL query results*

### 2. Top Paying Data Analyst Job Skills
To identify the job skills that are in high demand for a Data Analyst role. This will help job seekers understand which skills to develop that align with top salaries.

```sql
WITH top_paying_jobs AS (

    SELECT 
        job_id,
        job_title,
        job_location,
        salary_year_avg,
        name AS company_name 
    FROM 
        job_postings_fact
    LEFT JOIN company_dim 
    ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim 
ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```
Here's the breakdown of the most demanded skills for data analyst in 2023, based on job postings:

- **SQL** is leading with a bold count of **8**.

- **Python** follows closely with a bold count of **7**.

- **Tableau** is also highly sought after, with a bold count of **6**.

- Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.

![Top Paying Job Skills](assets\top_skills_top_paying_data_analyst_jobs.png)
*Bar graph visualizing the most common skills in Top Paying Data Analyst jobs; ChatGPT generated this graph from the SQL query results*

### 3. Top In-Demand Skills for Data Analysts
This will help identify the top 5 in-demand skills for a Data Analyst.

```sql
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
LIMIT 5;
```
Here's a breakdown for this data:

- **SQL** is the most in-demand skill for data analysts, appearing in **7,291** job postings.

- **Excel** ranks second with **4,611** mentions, highlighting its continued importance for data analysis and reporting.

- **Python** follows closely with **4,330** postings, reflecting the growing demand for automation and advanced analytics.

- **Tableau** is highly sought after, appearing in **3,745** job postings, emphasizing the importance of data visualization skills.

- **Power BI** rounds out the top five with **2,609** mentions, showing strong demand for business intelligence and dashboarding expertise.

**Key takeaway:** SQL remains the dominant skill in the data analytics job market, while Excel, Python, Tableau, and Power BI form a strong supporting skill set that employers frequently seek in candidates.

![Top Demanded Roles](assets\top_demanded_roles_for_data_analyst_jobs.png)
*Bar graph visualizing the most in-demand skills for Data Analyst jobs; ChatGPT generated this graph from the SQL query results*

### 4. Top Paying Skills For Data Analysts
To identify how different skills impact salary levels for Data Analyst and
helps identify the most financially rewarding skills to acquire or improve.

```sql
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
LIMIT 25;
```
Here's a breakdown of the results for top paying skills for Data Analyst position:
- Big data skills such as PySpark ($208K), Databricks ($142K), and Airflow ($126K) 
  are linked to the highest-paying data analyst roles.
- Programming and ML skills like Pandas ($152K), NumPy ($144K), and DataRobot ($155K)
  show that advanced analytics expertise commands higher salaries.
- Cloud and DevOps tools including GCP ($123K), Kubernetes ($133K), and GitLab ($155K) 
  indicate strong demand for analysts with technical and engineering-focused skills.

![Top Paying Skills](assets\top_paying_skills_for_data_analyst_jobs.png)
*Bar graph visualizing the top paying skills for Data Analyst jobs; ChatGPT generated this graph from the SQL query results*

### 5. Optimal Skills For Data Analysts
Identify skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis.

```sql
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
```
Here's a breakdown:

- **Python** is the most in-demand skill, appearing in **236** job postings, with an average salary of **$101,397**.

- **Tableau** follows closely with **230** postings and an average salary of **$99,288**, highlighting strong demand for data visualization skills.

- **R** remains highly valued, appearing in **148** postings with an average salary of **$100,499**.

- **Go** offers the highest average salary at **$115,320**, despite appearing in only **27** postings, indicating a specialized, high-paying skill.

**Snowflake**, **Oracle**, **Azure**, and **AWS** combine strong salaries **(over $104K–$113K)** with moderate demand, reflecting the importance of cloud and data platform expertise.

**Key takeaway :** **Python** and **Tableau** dominate demand, while specialized cloud, big data, and programming skills such as Go, Snowflake, Azure, and Hadoop command some of the highest salaries.

![Optimal Skills](assets\optimal_skills_for_data_analyst_jobs.png)
*Bar graph visualizing the optimal skills for Data Analyst jobs; ChatGPT generated this graph from the SQL query results*

# What I Learnt
Through following **Luke Barousse's Data Analyst Bootcamp**, I developed a strong foundation in SQL and database querying. 

I learned how to retrieve, filter, sort, and aggregate data using key SQL clauses such as SELECT, FROM, WHERE, GROUP BY, ORDER BY, and LIMIT. I also gained experience combining data from multiple tables using INNER JOIN, LEFT JOIN, and RIGHT JOIN, enabling more comprehensive data analysis. 

Additionally, I learned how to create and use Common Table Expressions (CTEs) to simplify complex queries and improve readability. Throughout the bootcamp, I practiced writing real-world SQL queries, working with databases, and applying analytical techniques to extract meaningful insights from data.

# Conclusions

### Insights
This project provided hands-on experience applying SQL to analyze real-world job market data. Using SQL concepts such as filtering, aggregation, joins, and Common Table Expressions (CTEs), I was able to explore job postings, identify in-demand skills, and uncover salary trends within the data analytics field.

Some key insights from the analysis include:

- **SQL** was the most in-demand skill, appearing in the highest number of job postings.
- ***Excel, Python, Tableau, and Power BI** were also among the most frequently requested skills for data analyst roles.

- Specialized technical skills such as **PySpark, Bitbucket, and Couchbase** were associated with some of the highest average salaries.
- **Python and Tableau** demonstrated a strong combination of high demand and competitive salaries, making them valuable skills for aspiring data analysts.
- Cloud and big data technologies, including **Snowflake, Azure, AWS, and Hadoop**, showed strong earning potential despite lower demand compared to core analytics tools.

Overall, this project strengthened my SQL skills while providing valuable insights into the current data analyst job market. It demonstrated how SQL can be used to transform raw data into actionable business insights and support data-driven decision-making.

### Closing Thoughts

This project provided hands-on experience applying SQL to real-world data analysis problems. By using SQL queries, joins, aggregations, and CTEs, I was able to extract meaningful insights from the dataset and answer business-focused questions. The project strengthened my ability to work with relational databases and demonstrated how SQL can be used to transform raw data into actionable information. Overall, this project helped build a solid foundation for more advanced data analytics and business intelligence projects.
