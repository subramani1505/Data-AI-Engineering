# 🔄 MapReduce — Interview Reference with Examples

> **Purpose:** Complete interview reference for MapReduce — Hadoop's distributed data processing model.  
> **Topics Covered:** Concept, Phases, Shuffle & Sort, Worked Examples, Code Logic, Fault Tolerance, Q&A.

---

## 📑 Table of Contents

1. [What is MapReduce?](#1-what-is-mapreduce)
2. [The Big Idea — Divide and Conquer](#2-the-big-idea--divide-and-conquer)
3. [MapReduce Phases](#3-mapreduce-phases)
4. [Example 1 — Word Count (Classic)](#4-example-1--word-count-classic)
5. [Example 2 — Sales Total by Product](#5-example-2--sales-total-by-product)
6. [Example 3 — Finding Maximum Temperature](#6-example-3--finding-maximum-temperature)
7. [Shuffle and Sort — The Hidden Phase](#7-shuffle-and-sort--the-hidden-phase)
8. [Combiner — Mini Reducer](#8-combiner--mini-reducer)
9. [Partitioner](#9-partitioner)
10. [MapReduce in YARN](#10-mapreduce-in-yarn)
11. [Fault Tolerance](#11-fault-tolerance)
12. [Complete Flow Diagram](#12-complete-flow-diagram)
13. [Interview Q&A](#13-interview-qa)

---

## 1. What is MapReduce?

**MapReduce** is a programming model for processing **large datasets in parallel** across a distributed cluster.

It breaks any big data problem into two types of functions:

| Function   | What it does                                      |
|------------|---------------------------------------------------|
| **Map**    | Reads input, processes it, emits key-value pairs  |
| **Reduce** | Groups key-value pairs by key, aggregates values  |

**Simple Analogy:**
```
MapReduce is like counting votes in an election.

MAP (Polling Booths):
  Each booth counts local votes independently.
  Booth 1: "Candidate A: 200, Candidate B: 150"
  Booth 2: "Candidate A: 300, Candidate B: 100"

SHUFFLE:
  All results for Candidate A grouped together.
  All results for Candidate B grouped together.

REDUCE (Central Office):
  Candidate A total: 200 + 300 = 500
  Candidate B total: 150 + 100 = 250
```

---

## 2. The Big Idea — Divide and Conquer

Suppose you have a 1 TB log file and want to count how many times each word appears.

**Without MapReduce:**
```
One machine reads 1 TB -> takes hours -> memory overflow
```

**With MapReduce:**
```
Split into 8000 blocks (128 MB each)
  |
  v
8000 Map Tasks run in parallel across 100 machines
  |
  v
Results grouped and sent to Reduce Tasks
  |
  v
Final answer in minutes
```

---

## 3. MapReduce Phases

```
INPUT
  |
  v
[SPLIT]  -- Input divided into splits (usually one per HDFS block)
  |
  v
[MAP]    -- Each split processed by one Map task
  |         Emits (key, value) pairs
  v
[SHUFFLE & SORT]  -- Framework groups all values by key
  |                  Sorts keys
  v
[REDUCE] -- Each Reduce task receives (key, list of values)
  |         Aggregates and writes final output
  v
OUTPUT (written to HDFS)
```

### Key Data Types

MapReduce always works with **key-value pairs**:

```
Map Input:    (offset, line_of_text)
Map Output:   (word, 1)
Reduce Input: (word, [1, 1, 1, 1])
Reduce Output:(word, total_count)
```

---

## 4. Example 1 — Word Count (Classic)

**Problem:** Count how many times each word appears in a text file.

**Input File (`books.txt`):**
```
hadoop is fast
hadoop is powerful
spark is fast
```

---

### Phase 1: Input Split

The file is split into blocks. Suppose 2 splits:
```
Split 1: "hadoop is fast"
Split 2: "hadoop is powerful\nspark is fast"
```

---

### Phase 2: Map

Each Map task reads its split line by line and emits `(word, 1)` for every word.

**Map Task 1** (processes Split 1):
```
Input:  "hadoop is fast"
Output:
  (hadoop, 1)
  (is,     1)
  (fast,   1)
```

**Map Task 2** (processes Split 2):
```
Input:  "hadoop is powerful"
        "spark is fast"
Output:
  (hadoop,   1)
  (is,       1)
  (powerful, 1)
  (spark,    1)
  (is,       1)
  (fast,     1)
```

---

### Phase 3: Shuffle & Sort

The framework **groups all values for the same key** together across all Map outputs:

```
fast     -> [1, 1]
hadoop   -> [1, 1]
is       -> [1, 1, 1]
powerful -> [1]
spark    -> [1]
```

Keys are also **sorted alphabetically**.

---

### Phase 4: Reduce

Each Reduce task receives `(key, list_of_values)` and sums them:

```
(fast,     [1, 1])      -> (fast,     2)
(hadoop,   [1, 1])      -> (hadoop,   2)
(is,       [1, 1, 1])   -> (is,       3)
(powerful, [1])         -> (powerful, 1)
(spark,    [1])         -> (spark,    1)
```

---

### Final Output (written to HDFS `/output/part-r-00000`):

```
fast      2
hadoop    2
is        3
powerful  1
spark     1
```

---

### Pseudo-code

```python
# MAP FUNCTION
def map(offset, line):
    words = line.split()
    for word in words:
        emit(word, 1)

# REDUCE FUNCTION
def reduce(word, counts):
    total = sum(counts)
    emit(word, total)
```

---

## 5. Example 2 — Sales Total by Product

**Problem:** Given sales transaction records, find the total revenue per product.

**Input File (`sales.csv`):**
```
ProductA, 100
ProductB, 200
ProductA, 150
ProductC, 300
ProductB, 250
ProductA, 200
```

---

### Map Phase

Each Map task reads lines and emits `(product, amount)`:

```
Map Task 1 (processes first 3 lines):
  (ProductA, 100)
  (ProductB, 200)
  (ProductA, 150)

Map Task 2 (processes last 3 lines):
  (ProductC, 300)
  (ProductB, 250)
  (ProductA, 200)
```

---

### Shuffle & Sort

Framework groups by key:
```
ProductA -> [100, 150, 200]
ProductB -> [200, 250]
ProductC -> [300]
```

---

### Reduce Phase

```
(ProductA, [100, 150, 200])  ->  (ProductA, 450)
(ProductB, [200, 250])       ->  (ProductB, 450)
(ProductC, [300])            ->  (ProductC, 300)
```

---

### Final Output:

```
ProductA    450
ProductB    450
ProductC    300
```

---

### Pseudo-code

```python
# MAP FUNCTION
def map(offset, line):
    product, amount = line.split(",")
    emit(product.strip(), int(amount.strip()))

# REDUCE FUNCTION
def reduce(product, amounts):
    total = sum(amounts)
    emit(product, total)
```

---

## 6. Example 3 — Finding Maximum Temperature

**Problem:** Given daily temperature records by city, find the maximum temperature per city.

**Input File (`weather.txt`):**
```
Mumbai  35
Delhi   42
Mumbai  38
Delhi   39
Mumbai  33
Delhi   45
```

---

### Map Phase

```
Map Task 1:
  (Mumbai, 35)
  (Delhi,  42)
  (Mumbai, 38)

Map Task 2:
  (Delhi,  39)
  (Mumbai, 33)
  (Delhi,  45)
```

---

### Shuffle & Sort

```
Delhi  -> [42, 39, 45]
Mumbai -> [35, 38, 33]
```

---

### Reduce Phase

```
(Delhi,  [42, 39, 45])  ->  (Delhi,  45)
(Mumbai, [35, 38, 33])  ->  (Mumbai, 38)
```

---

### Final Output:

```
Delhi   45
Mumbai  38
```

---

### Pseudo-code

```python
# MAP FUNCTION
def map(offset, line):
    city, temp = line.split()
    emit(city, int(temp))

# REDUCE FUNCTION
def reduce(city, temperatures):
    emit(city, max(temperatures))
```

---

## 7. Shuffle and Sort — The Hidden Phase

The **Shuffle and Sort** phase is done automatically by the MapReduce framework. It is critical to understand for interviews.

### What happens in detail:

```
STEP 1 — Map output written to local disk (not HDFS)
  Each Map task writes output to a local circular buffer in RAM.
  When buffer is 80% full, it spills to disk.

STEP 2 — Partitioning
  Each Map output key is assigned to a specific Reduce task.
  Default: hash(key) % numReducers

  Example (2 reducers):
    "fast"     -> hash("fast") % 2 = 0  -> Reducer 0
    "hadoop"   -> hash("hadoop") % 2 = 1 -> Reducer 1
    "is"       -> hash("is") % 2 = 0    -> Reducer 0

STEP 3 — Sort
  Map outputs are sorted by key before being sent to Reducers.

STEP 4 — Shuffle (Copy Phase)
  Reducers pull data from all Map task outputs over the network.

STEP 5 — Merge & Sort on Reducer side
  All pulled data is merged and sorted again.
  Reducer receives a sorted stream of (key, value) pairs.
```

### Why is Shuffle the most expensive phase?

```
Map output on local disk
  |
  | (network transfer)
  v
Reducer (different machine)
```

Shuffle involves **network I/O** — often the bottleneck in MapReduce jobs.

---

## 8. Combiner — Mini Reducer

A **Combiner** is an optional optimization that runs locally on each Map node before data is sent over the network.

### Without Combiner (Word Count):

```
Map Task 1 sends to network:
  (hadoop, 1)
  (hadoop, 1)
  (is, 1)
  (is, 1)
  (is, 1)
  ...many records...
```

### With Combiner:

```
Combiner runs locally on Map Task 1:
  (hadoop, 1) + (hadoop, 1)  ->  (hadoop, 2)
  (is, 1) + (is, 1) + (is, 1) -> (is, 3)

Map Task 1 sends to network:
  (hadoop, 2)   <- only 1 record instead of 2
  (is, 3)       <- only 1 record instead of 3
```

**Result:** Dramatically reduces network traffic during Shuffle.

> **Important:** The Combiner function must be **commutative and associative** (order/grouping shouldn't matter).  
> Works for: sum, max, min, count.  
> Does NOT work for: average (you can't average of averages correctly).

---

## 9. Partitioner

The **Partitioner** decides which Reduce task handles which keys.

### Default Partitioner

```python
partition = hash(key) % numReduceTasks
```

**Example with 3 reducers:**
```
Key: "apple"   -> hash("apple") % 3 = 0  -> Reducer 0
Key: "banana"  -> hash("banana") % 3 = 1 -> Reducer 1
Key: "cherry"  -> hash("cherry") % 3 = 2 -> Reducer 2
```

### Custom Partitioner Example

Suppose you want all words starting with A-M to go to Reducer 0 and N-Z to Reducer 1:

```python
def partition(key, num_reducers):
    if key[0].upper() <= 'M':
        return 0
    else:
        return 1
```

---

## 10. MapReduce in YARN

When you submit a MapReduce job, YARN manages the execution:

```
Client
  |
  | Submit job
  v
ResourceManager (YARN)
  |
  | Launch ApplicationMaster (MRAppMaster)
  v
MRAppMaster
  |
  | Request containers for Map tasks
  v
NodeManagers -> launch Map containers
  |
  | Maps complete
  v
MRAppMaster
  |
  | Request containers for Reduce tasks
  v
NodeManagers -> launch Reduce containers
  |
  | Reduces complete -> output on HDFS
  v
MRAppMaster reports completion to RM
```

**MapReduce ApplicationMaster = MRAppMaster**

It specifically manages:
- How many Map tasks to run.
- When to start Reduce tasks (after enough Maps complete).
- Retry logic for failed tasks.
- Speculative execution for slow tasks.

---

## 11. Fault Tolerance

### Task Failure

If a Map or Reduce task fails:
1. MRAppMaster detects the failure.
2. Requests a new container from ResourceManager.
3. Re-runs the failed task on a new container.
4. Map tasks are always re-runnable (input is on HDFS — immutable).

```
Task Failure:
  Container-M3 crashes
     |
     v
  MRAppMaster detects (no heartbeat)
     |
     v
  Request new container from RM
     |
     v
  Map Task 3 re-runs on Node4
```

### Speculative Execution

If a task is running much slower than others (straggler), HDFS launches a **duplicate speculative task** on another node. Whichever finishes first wins; the other is killed.

```
Map Task 7 is slow (straggler):
  Normal:    Node3, 80% done, slowing down
  Speculative: Node5, launched fresh

Whichever finishes first -> its output is used
Other task -> killed
```

---

## 12. Complete Flow Diagram

```
=====================================================
            MAPREDUCE COMPLETE FLOW
=====================================================

INPUT FILE on HDFS (e.g., 500 MB)
  |
  | Split into 4 x 128MB blocks
  v
INPUT SPLITS
  |
  +-- Split 1 --> Map Task 1 (runs on Node1, near Block1)
  +-- Split 2 --> Map Task 2 (runs on Node2, near Block2)
  +-- Split 3 --> Map Task 3 (runs on Node3, near Block3)
  +-- Split 4 --> Map Task 4 (runs on Node1, near Block4)
  |
  | Each Map task emits (key, value) pairs
  v
LOCAL SORT + COMBINER (optional, per Map node)
  |
  v
SHUFFLE (Reducers pull data from Map outputs over network)
  |
  v
MERGE + SORT (on Reducer side)
  |
  v
REDUCE TASKS
  +-- Reducer 0: processes keys A-M
  +-- Reducer 1: processes keys N-Z
  |
  | Each Reducer emits final (key, value)
  v
OUTPUT written to HDFS
  /output/part-r-00000  (from Reducer 0)
  /output/part-r-00001  (from Reducer 1)
```

---

## 13. Interview Q&A

### Q1. What are the two main functions in MapReduce?

**Answer:**
- **Map:** Takes input as key-value pairs, processes them, and emits intermediate key-value pairs.
- **Reduce:** Takes each unique key with a list of all its values, aggregates them, and emits the final key-value output.

---

### Q2. What is the role of the Shuffle and Sort phase?

**Answer:** Shuffle and Sort is performed automatically by the MapReduce framework between the Map and Reduce phases. It:
1. **Partitions** Map output to send to the correct Reducer.
2. **Transfers** (shuffles) Map output data to Reducer nodes over the network.
3. **Sorts** the data by key so the Reducer receives keys in order.

It is typically the most **network-intensive** phase of a MapReduce job.

---

### Q3. What is a Combiner and when should you use it?

**Answer:** A Combiner is a mini-Reducer that runs locally on each Map node before data is sent over the network during Shuffle. It reduces the amount of data transferred, improving performance. You should use a Combiner when the reduce function is **commutative and associative** — for example, sum, max, min, count. Do NOT use it for non-associative operations like average.

---

### Q4. What is data locality in MapReduce?

**Answer:** Data locality means scheduling Map tasks on the same node (or same rack) where their input HDFS block resides. This avoids reading data over the network. YARN's MRAppMaster requests containers on the preferred nodes where input blocks are stored, achieving node-local execution.

---

### Q5. Can a MapReduce job have 0 Reduce tasks?

**Answer:** Yes. If the job only needs to process and filter data without aggregation, you can set the number of reducers to 0. In this case, Map output is written directly to HDFS — there is no Shuffle phase. This is useful for jobs like data transformation, filtering, or format conversion.

---

### Q6. What is speculative execution in MapReduce?

**Answer:** If a task (Map or Reduce) is running significantly slower than other tasks (a "straggler"), MapReduce launches a duplicate of that task on another node. Whichever copy finishes first is used, and the other is killed. This prevents one slow machine from delaying the entire job.

---

### Q7. What is the difference between an Input Split and an HDFS Block?

**Answer:**
| HDFS Block | Input Split |
|---|---|
| Physical storage unit on DataNodes | Logical unit for MapReduce processing |
| Default 128 MB | Usually matches block size |
| Managed by HDFS | Managed by InputFormat in MapReduce |
| Replicated across nodes | Not stored — computed at job start |

Typically one split = one block, so one Map task per block. But InputFormat can define splits differently (e.g., smaller splits for very large records).

---

### Q8. How does MapReduce handle task failures?

**Answer:** The MRAppMaster detects task failures (via missing heartbeats or non-zero exit codes). It requests a new container from YARN's ResourceManager and re-runs the task. Map tasks are safe to retry because their input (HDFS blocks) is immutable. A task is retried up to 4 times by default before the job fails.

---

### Q9. What is a Partitioner and why does it matter?

**Answer:** The Partitioner determines which Reduce task handles which Map output keys. The default hash-based partitioner distributes keys evenly across reducers. A custom partitioner is needed when you want specific keys to go to specific reducers — for example, range partitioning for sorted output, or routing by a business key. Poor partitioning leads to **data skew** where one reducer gets much more data than others.

---

### Q10. What is data skew and how can you handle it?

**Answer:** Data skew occurs when some Reduce tasks receive far more data than others — for example, if one key appears in millions of records while others appear rarely. The overloaded Reducer becomes a bottleneck. Solutions:
- Use a **custom Partitioner** to distribute load evenly.
- Use a **Combiner** to pre-aggregate locally.
- Use a **salting technique**: add a random prefix to hot keys during Map, aggregate in two Reduce passes.

---

### Q11. What is the difference between MapReduce and Spark?

**Answer:**
| MapReduce | Apache Spark |
|---|---|
| Writes intermediate results to disk after each phase | Keeps intermediate data in memory (RDDs) |
| Slower for iterative algorithms (e.g., ML) | 10-100x faster for iterative jobs |
| Simple programming model | Richer API (DataFrames, Streaming, ML) |
| Fault tolerant via re-execution | Fault tolerant via RDD lineage |
| Native to Hadoop | Can run on YARN, Kubernetes, standalone |

MapReduce is ideal for simple, batch ETL. Spark is preferred for complex, iterative, or real-time workloads.

---

> **Next Topics to Study:**
> **Hadoop Streaming** (running Python/Ruby MapReduce jobs), **InputFormat types** (TextInputFormat, SequenceFileInputFormat), and **OutputFormat** — frequently asked in Data Engineering interviews.
