select report_date, sum(new_deaths) as new_deaths, sum(lag_waight) / sum(new_deaths) lag_average
from
(select report_date, new_deaths, lag_effect,  lag_effect * new_deaths as lag_waight  from
(SELECT 
    report_date,
    death_date,
    deaths,
    CASE WHEN report_date > MIN(report_date) OVER () THEN report_date - death_date ELSE 0 END AS lag_effect,
    deaths - COALESCE(LAG(deaths) OVER (PARTITION BY death_date ORDER BY report_date),0) AS new_deaths
  FROM deaths) as theList
  where new_deaths > 0 and report_date > '2020-04-02') as theList1
  
group by report_date
  order by report_date;
