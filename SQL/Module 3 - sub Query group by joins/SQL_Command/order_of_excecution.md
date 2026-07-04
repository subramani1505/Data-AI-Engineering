# 📋 SQL Order of Execution

> SQL does **NOT** execute clauses in the order you write them.
> Understanding the execution order is key to writing correct and optimized queries.

---

## 📊 Sample Table — `employees`

| emp_id | name  | department | salary |
| -----: | ----- | ---------- | -----: |
|      1 | John  | HR         |  50000 |
|      2 | Alice | IT         |  70000 |
|      3 | Bob   | HR         |  60000 |
|      4 | David | IT         |  80000 |
|      5 | Emma  | Sales      |  55000 |
|      6 | Sam   | IT         |  90000 |
|      7 | Mike  | Sales      |  65000 |

---

## 🔢 Execution Order of SQL Clauses

| Order | Clause     | Purpose                                      |
| :---: | ---------- | -------------------------------------------- |
|   1   | `FROM`     | Load the source table(s)                     |
|   2   | `WHERE`    | Filter rows **before** grouping              |
|   3   | `GROUP BY` | Group the remaining rows                     |
|   4   | `HAVING`   | Filter groups **after** aggregation          |
|   5   | `SELECT`   | Pick columns & compute expressions/aliases   |
|   6   | `ORDER BY` | Sort the final result set                    |
|   7   | `LIMIT`    | Restrict the number of rows returned         |

---

## 🧪 Example Query

```sql
SELECT
    department,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department;
```

### ✅ Expected Output

| department | avg_salary |
| ---------- | ---------: |
| HR         |      55000 |
| IT         |      80000 |
| Sales      |      60000 |

---

## 🔍 Step-by-Step Execution Walkthrough

### Step 1 — `FROM` : Load the Table

SQL first loads **all rows** from the `employees` table into memory.

```
emp_id | name  | department | salary
-------+-------+------------+-------
1      | John  | HR         | 50000
2      | Alice | IT         | 70000
3      | Bob   | HR         | 60000
4      | David | IT         | 80000
5      | Emma  | Sales      | 55000
6      | Sam   | IT         | 90000
7      | Mike  | Sales      | 65000
```

---

### Step 2 — `WHERE` : Filter Rows (if present)

Rows are filtered **before** any grouping or aggregation.

**Modified query with WHERE:**

```sql
SELECT
    department,
    AVG(salary) AS avg_salary
FROM employees
WHERE salary > 55000
GROUP BY department;
```

> ⚠️ Rows with `salary <= 55000` are **removed** at this stage.
> (John: 50,000 and Emma: 55,000 are excluded)

**Rows remaining after WHERE:**

| Name  | Department | Salary |
| ----- | ---------- | -----: |
| Alice | IT         |  70000 |
| Bob   | HR         |  60000 |
| David | IT         |  80000 |
| Sam   | IT         |  90000 |
| Mike  | Sales      |  65000 |

---

### Step 3 — `GROUP BY` : Group Rows by Department

SQL groups the filtered rows into **buckets** by department.

```
HR    → [ Bob:60000 ]
IT    → [ Alice:70000, David:80000, Sam:90000 ]
Sales → [ Mike:65000 ]
```

> 💡 Think of GROUP BY as a **sorting machine in a warehouse** that puts each employee into the correct department box before calculating summaries.

```
Incoming Rows
      │
      ▼
┌─────────────────┐
│  Grouping Step  │
│  ┌───┐ ┌───┐   │
│  │HR │ │IT │   │
│  └───┘ └───┘   │
│  ┌───────┐      │
│  │ Sales │      │
│  └───────┘      │
└─────────────────┘
      │
      ▼
┌──────────────────────────┐
│  Aggregation Step        │
│  HR    → AVG, SUM, COUNT │
│  IT    → AVG, SUM, COUNT │
│  Sales → AVG, SUM, COUNT │
└──────────────────────────┘
      │
      ▼
  Final Result Table
```

---

### Step 4 — Aggregate Functions : Compute Values

SQL calculates `AVG(salary)` **per group**:

| Department | Calculation               | Result |
| ---------- | ------------------------- | -----: |
| HR         | 60000 ÷ 1                 |  60000 |
| IT         | (70000 + 80000 + 90000) ÷ 3 |  80000 |
| Sales      | 65000 ÷ 1                 |  65000 |

---

### Step 5 — `SELECT` : Pick Columns

SQL now picks **only the requested columns** from the aggregated result:

```sql
SELECT department, AVG(salary) AS avg_salary
```

**Result:**

| department | avg_salary |
| ---------- | ---------: |
| HR         |      60000 |
| IT         |      80000 |
| Sales      |      65000 |

---

### Step 6 — `ORDER BY` : Sort Results (if present)

Sorting happens **last**, after all filtering, grouping, and column selection is done.

```sql
ORDER BY avg_salary DESC
```

---

### Step 7 — `LIMIT` : Restrict Rows (if present)

Applied at the very end to cap the number of rows returned.

```sql
LIMIT 5
```

---

## ⚡ Key Rules to Remember

| Rule | Explanation |
| ---- | ----------- |
| `WHERE` filters **rows**, `HAVING` filters **groups** | Use `WHERE` before `GROUP BY`, `HAVING` after |
| You **cannot** use column aliases in `WHERE` | Aliases are created in `SELECT` which runs later |
| You **can** use column aliases in `ORDER BY` | `ORDER BY` runs after `SELECT` |
| Aggregate functions (`AVG`, `SUM`, `COUNT`) run **after** `GROUP BY` | Never use them in `WHERE` — use `HAVING` instead |

---

## 🧠 Quick Memory Aid

```
FROM  →  WHERE  →  GROUP BY  →  HAVING  →  SELECT  →  ORDER BY  →  LIMIT
 1          2          3           4           5           6           7
```