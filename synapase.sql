--top 5 stadiums by capacity --
SELECT top 5 rank, stadium, capacity
FROM [stadiumDB].[dbo].[stadiums]
ORDER BY capacity DESC

-- Stadium Distribution by Region and Country
SELECT region, country, COUNT(*) AS stadium_count
FROM [stadiumDB].[dbo].[stadiums]
GROUP BY region, country
ORDER BY region, country;

--  Concentration of stadiums in different cities
SELECT city, COUNT(*) AS stadium_count
FROM [stadiumDB].[dbo].[stadiums]
GROUP BY city
ORDER BY stadium_count DESC;

-- Stadiums Without Images in Top Regions
SELECT region, stadium
FROM [stadiumDB].[dbo].[stadiums]
WHERE images IS NULL AND region IN (
  SELECT TOP 5 region
  FROM [stadiumDB].[dbo].[stadiums]
  GROUP BY region
  ORDER BY COUNT(*) DESC
);


-- City and Country Wise Stadium Location Analysis
SELECT city, country, location
FROM [stadiumDB].[dbo].[stadiums]
WHERE location IS NOT NULL;

-- Stadiums Unique to Their City:
SELECT city, stadium
FROM [stadiumDB].[dbo].[stadiums]
WHERE city IN (
  SELECT city
  FROM [stadiumDB].[dbo].[stadiums]
  GROUP BY city
  HAVING COUNT(*) = 1
);


-- average capacity by region --
SELECT region, AVG(capacity) as avg_capacity
FROM [stadiumDB].[dbo].[stadiums]
GROUP BY region
ORDER BY avg_capacity DESC;

--count of stadiums in each country--
SELECT country, count(country) stadium_count
FROM [stadiumDB].[dbo].[stadiums]
GROUP BY country
ORDER BY stadium_count desc, country asc

--stadium ranking within each region--
SELECT rank, stadium, region,
    RANK() OVER(PARTITION BY region ORDER BY capacity DESC) as region_rank
FROM [stadiumDB].[dbo].[stadiums];

--top 3 stadium ranking within each region--
SELECT rank, stadium, region, capacity, region_rank
FROM (
    SELECT rank, stadium, region, capacity,
           RANK() OVER (PARTITION BY region ORDER BY capacity DESC) as region_rank
    FROM [stadiumDB].[dbo].[stadiums]
) ranked_stadiums
WHERE region_rank <= 3;

-- stadiums with capacity above average --
SELECT stadium, t2.region, capacity, avg_capacity
FROM [stadiumDB].[dbo].[stadiums], (SELECT region, AVG(capacity) avg_capacity FROM stadiums GROUP BY region) t2
WHERE t2.region = stadiums.region
and capacity > avg_capacity
ORDER BY region

--stadiums with the closest capacity to regional median--
WITH MedianCTE AS (
    SELECT
        region, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY capacity) OVER (PARTITION BY region) AS median_capacity
    FROM [stadiumDB].[dbo].[stadiums]
)
SELECT rank, stadium, region, capacity, ranked_stadiums.median_rank
FROM (
    SELECT
        s.rank, s.stadium, s.region, s.capacity,
        ROW_NUMBER() OVER (PARTITION BY s.region ORDER BY ABS(s.capacity - m.median_capacity)) AS median_rank
    FROM [stadiumDB].[dbo].[stadiums] s JOIN MedianCTE m ON s.region = m.region
) ranked_stadiums
WHERE median_rank = 1;