# Hive — Warehouse, Database & Query Testing on Reviews.csv

> **Goal**: Use Hive to create a database, define an external table over the `Reviews.csv` file already stored in HDFS, and run analytical queries on it.

---

## Dataset Overview — Reviews.csv (Amazon Fine Food Reviews)

**HDFS Path**: `/user/subramani_uvce1/input/Reviews.csv`

| Column Name             | Data Type | Description                              |
|-------------------------|-----------|------------------------------------------|
| `Id`                    | INT       | Row identifier                           |
| `ProductId`             | STRING    | Unique product identifier (ASIN)         |
| `UserId`                | STRING    | Unique user identifier                   |
| `ProfileName`           | STRING    | Display name of the reviewer             |
| `HelpfulnessNumerator`  | INT       | Number of users who found review helpful |
| `HelpfulnessDenominator`| INT       | Total users who rated the review         |
| `Score`                 | INT       | Rating given (1 to 5)                    |
| `Time`                  | BIGINT    | Unix timestamp of the review             |
| `Summary`               | STRING    | Short summary of the review              |
| `Text`                  | STRING    | Full review text                         |

---

## Step 1: Launch Hive

SSH into the master node first (if not already inside):

```bash
gcloud compute ssh subramani.uvce1@hadoop-hive-cluster-m --zone=us-central1-b
```

Then start the Hive shell:

```bash
hive
```

> You should see the `hive>` prompt once Hive starts.

---

## Step 2: Create a Database

```sql
-- Create a new database called amazon_reviews
CREATE DATABASE IF NOT EXISTS amazon_reviews
COMMENT 'Database for Amazon Fine Food Reviews dataset'
LOCATION '/user/hive/warehouse/amazon_reviews.db';

-- Verify the database was created
SHOW DATABASES;

-- Switch to the newly created database
USE amazon_reviews;
```

**Expected output of SHOW DATABASES:**
```
default
amazon_reviews
```

---

## Step 3: Create an External Table

We use an **EXTERNAL** table so that Hive points to the existing CSV file in HDFS without moving or copying it.

> ⚠️ **Important**: `TIME` and `TEXT` are **reserved keywords** in Hive. Always wrap them in backticks `` ` `` to avoid a `ParseException`.

```sql
CREATE EXTERNAL TABLE IF NOT EXISTS reviews (
    Id                      INT,
    ProductId               STRING,
    UserId                  STRING,
    ProfileName             STRING,
    HelpfulnessNumerator    INT,
    HelpfulnessDenominator  INT,
    Score                   INT,
    `Time`                  BIGINT,
    Summary                 STRING,
    `Text`                  STRING
)
ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/subramani_uvce1/input/'
TBLPROPERTIES ("skip.header.line.count"="1");
```

> **Why EXTERNAL?**
> - The CSV is already in HDFS at `/user/subramani_uvce1/input/`
> - Dropping the table will **NOT** delete the underlying CSV file
> - INTERNAL (managed) tables would move the data into Hive's warehouse directory

---

## Step 4: Verify the Table

```sql
-- List all tables in the current database
SHOW TABLES;

-- Describe the table schema
DESCRIBE reviews;

-- Describe in detail (includes location, format, etc.)
DESCRIBE FORMATTED reviews;
```

**Expected output of DESCRIBE reviews:**
```
id                       int
productid                string
userid                   string
profilename              string
helpfulnessnumerator     int
helpfulnessdenominator   int
score                    int
time                     bigint
summary                  string
text                     string
```

---

## Step 5: Basic Test Queries

### 5.1 — Preview the Data

```sql
-- View first 10 rows
SELECT * FROM reviews LIMIT 10;
```

### 5.2 — Count Total Records

```sql
-- Total number of reviews
SELECT COUNT(*) AS total_reviews FROM reviews;
```

### 5.3 — Check Score Distribution

```sql
-- How many reviews per rating (1 to 5)?
SELECT Score, COUNT(*) AS review_count
FROM reviews
GROUP BY Score
ORDER BY Score;
```

**Expected output:**
```
Score | review_count
------+-------------
1     | xxxxx
2     | xxxxx
3     | xxxxx
4     | xxxxx
5     | xxxxx
```

### 5.4 — Average Score Overall

```sql
-- Average rating across all reviews
SELECT ROUND(AVG(Score), 2) AS avg_score
FROM reviews;
```

---

## Step 6: Analytical Queries

### 6.1 — Top 10 Most Reviewed Products

```sql
SELECT ProductId,
       COUNT(*) AS num_reviews,
       ROUND(AVG(Score), 2) AS avg_rating
FROM reviews
GROUP BY ProductId
ORDER BY num_reviews DESC
LIMIT 10;
```

### 6.2 — Top 10 Most Active Reviewers

```sql
SELECT UserId,
       ProfileName,
       COUNT(*) AS total_reviews
FROM reviews
GROUP BY UserId, ProfileName
ORDER BY total_reviews DESC
LIMIT 10;
```

### 6.3 — Most Helpful Reviews

```sql
-- Reviews where HelpfulnessDenominator > 0 (rated by at least 1 person)
SELECT Id,
       ProductId,
       Score,
       HelpfulnessNumerator,
       HelpfulnessDenominator,
       ROUND(HelpfulnessNumerator / HelpfulnessDenominator, 2) AS helpfulness_ratio,
       Summary
FROM reviews
WHERE HelpfulnessDenominator > 0
ORDER BY helpfulness_ratio DESC
LIMIT 10;
```

### 6.4 — Products with Highest Average Rating (min 50 reviews)

```sql
SELECT ProductId,
       COUNT(*) AS num_reviews,
       ROUND(AVG(Score), 2) AS avg_rating
FROM reviews
GROUP BY ProductId
HAVING COUNT(*) >= 50
ORDER BY avg_rating DESC
LIMIT 10;
```

### 6.5 — Worst Rated Products (min 50 reviews)

```sql
SELECT ProductId,
       COUNT(*) AS num_reviews,
       ROUND(AVG(Score), 2) AS avg_rating
FROM reviews
GROUP BY ProductId
HAVING COUNT(*) >= 50
ORDER BY avg_rating ASC
LIMIT 10;
```

### 6.6 — Reviews Over Time (Year-wise Count)

```sql
-- Convert Unix timestamp to year and count reviews per year
SELECT YEAR(FROM_UNIXTIME(Time)) AS review_year,
       COUNT(*) AS total_reviews
FROM reviews
GROUP BY YEAR(FROM_UNIXTIME(Time))
ORDER BY review_year;
```

### 6.7 — 5-Star Review Percentage per Product (Top 10)

```sql
SELECT ProductId,
       COUNT(*) AS total_reviews,
       SUM(CASE WHEN Score = 5 THEN 1 ELSE 0 END) AS five_star_count,
       ROUND(SUM(CASE WHEN Score = 5 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS five_star_pct
FROM reviews
GROUP BY ProductId
HAVING COUNT(*) >= 50
ORDER BY five_star_pct DESC
LIMIT 10;
```

---

## Step 7: Working with Hive Warehouse

### 7.1 — Check Hive Warehouse Location in HDFS

```bash
# Run from Linux terminal (not Hive shell)
hadoop fs -ls /user/hive/warehouse/
```

### 7.2 — Check Your Database Directory

```bash
hadoop fs -ls /user/hive/warehouse/amazon_reviews.db/
```

### 7.3 — Check Where the External Table Points

```sql
-- Inside Hive shell
DESCRIBE FORMATTED reviews;
-- Look for: Location field -> shows the HDFS path
```

---

## Step 8: Exit Hive

```sql
EXIT;
```

---

## Quick Reference — Internal vs External Table

| Feature           | INTERNAL (Managed) Table     | EXTERNAL Table                       |
|-------------------|------------------------------|--------------------------------------|
| **Data location** | Hive warehouse directory     | Stays in original HDFS path          |
| **DROP TABLE**    | Deletes metadata + data      | Deletes only metadata, data stays    |
| **Use case**      | Hive fully owns the data     | Data shared with other tools (Spark) |
| **Our case**      | Not used                     | Used (data already in HDFS)          |

---

## Summary — Command Flow

```
hive
  |
  |-- CREATE DATABASE amazon_reviews
  |-- USE amazon_reviews
  |-- CREATE EXTERNAL TABLE reviews (...) LOCATION '/user/.../input/'
  |-- SELECT COUNT(*) FROM reviews                  <- test
  |-- SELECT Score, COUNT(*) GROUP BY Score         <- score distribution
  |-- SELECT ProductId ... ORDER BY num_reviews     <- top products
  |-- SELECT YEAR(FROM_UNIXTIME(Time)) ...          <- time trend
  `-- EXIT
```
