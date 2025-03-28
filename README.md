# SQL Data Exploration - Covid Data

![License](https://img.shields.io/badge/license-MIT-blue)
![Contributions](https://img.shields.io/badge/contributions-welcome-brightgreen)

## Table of Contents
1. [Introduction](#introduction)
2. [Datasets](#datasets)
3. [SQL Analyses](#sql-analyses)
4. [Features](#features)
5. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Setup](#setup)
6. [Examples](#examples)
7. [Contributions](#contributions)
8. [License](#license)

## Introduction
Welcome to the Covid Data Exploration with SQL repository! The "SQL Data Exploration - Covid Data" repository is dedicated to analyzing Covid-19 related data, focusing on death records and vaccination statistics using SQL queries. This project aims to provide insights into the impact of the Covid-19 pandemic on mortality rates and vaccination progress. By leveraging SQL, users can gain valuable insights into various aspects of the pandemic, including mortality rates, vaccination progress, regional trends, and more.

## Datasets
I utilize publicly available datasets related to Covid-19, including death records and vaccination statistics. These datasets are sourced from reputable sources and are regularly updated to ensure the analysis reflects the latest information. Detailed information about the datasets and their sources can be found at [Our World in Data](https://ourworldindata.org/covid-deaths).

## SQL Analyses
This project includes a variety of SQL queries to analyze the Covid-19 data. Below are some key analyses performed:

1. **Mortality Analysis**:
   - Calculate death percentages by comparing total deaths to total cases.
   - Identify countries with the highest death counts and analyze death counts by continent.

2. **Infection Analysis**:
   - Calculate infection percentages by comparing total cases to population.
   - Identify countries with the highest infection rates relative to their population.

3. **Vaccination Analysis**:
   - Analyze vaccination progress by joining death and vaccination datasets.
   - Use Common Table Expressions (CTEs) to calculate rolling vaccination numbers.
   - Create temporary tables and views to store vaccination percentages for further analysis and visualization.

4. **Global Trends**:
   - Analyze global trends in new cases and deaths over time.
   - Summarize data by continent and date to observe regional trends.

## Features
- **Joins**: Combine data from `CovidDeaths` and `CovidVaccinations` tables for comprehensive analysis.
- **CTEs**: Simplify complex queries, such as calculating rolling vaccination numbers.
- **Temporary Tables**: Store intermediate results, such as vaccination percentages, for further processing and optimization.
- **Views**: Create reusable views for visualization, reporting, and sharing insights.
- **Aggregations**: Perform advanced aggregations to summarize data by region, date, and other dimensions.
- **Trend Analysis**: Use SQL functions to analyze trends over time, such as moving averages for new cases and deaths.

## Getting Started

### Prerequisites
- A compatible SQL environment (e.g., MySQL, PostgreSQL, or SQL Server).
- Tools for visualization (e.g., Tableau, Power BI, or Excel).

### Setup
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/kenobech/SQL-Data-Exploration---Covid-Data.git
   cd SQL-Data-Exploration---Covid-Data
   ```

2. **Set Up the Database**:
   - Import the provided SQL scripts to create and populate the `CovidDeaths` and `CovidVaccinations` tables.

3. **Run the Queries**:
   - Use the SQL scripts in the repository to perform the analyses described above.

4. **Explore the Results**:
   - Use visualization tools like Tableau or Power BI to create dashboards based on the query outputs.

## Examples
Here are some examples of SQL queries and their outputs:

### Mortality Analysis
```sql
SELECT country, SUM(deaths) AS total_deaths, SUM(cases) AS total_cases,
       (SUM(deaths) / SUM(cases)) * 100 AS death_percentage
FROM CovidDeaths
GROUP BY country
ORDER BY death_percentage DESC;
```

### Vaccination Progress
```sql
WITH VaccinationCTE AS (
    SELECT country, date, SUM(vaccinations) OVER (PARTITION BY country ORDER BY date) AS rolling_vaccinations
    FROM CovidVaccinations
)
SELECT * FROM VaccinationCTE WHERE country = 'United States';
```

## Contributions
Contributions to the Covid Data Exploration with SQL project are welcome! To contribute:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a detailed description of your changes.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
