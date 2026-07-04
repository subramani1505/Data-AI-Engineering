# ⚙️ YARN (Yet Another Resource Negotiator) — Interview Reference

> **Purpose:** Complete interview reference for YARN — Hadoop's cluster resource manager.  
> **Topics Covered:** Architecture, Components, Job Lifecycle, Examples, Fault Tolerance, Q&A.

---

## 📑 Table of Contents

1. [What is YARN?](#1-what-is-yarn)
2. [Why was YARN Introduced?](#2-why-was-yarn-introduced)
3. [YARN Architecture — Core Components](#3-yarn-architecture--core-components)
4. [How YARN Runs a Job — Step-by-Step](#4-how-yarn-runs-a-job--step-by-step)
5. [Worked Example — Word Count Job](#5-worked-example--word-count-job)
6. [YARN Resource Model](#6-yarn-resource-model)
7. [Fault Tolerance in YARN](#7-fault-tolerance-in-yarn)
8. [YARN Schedulers](#8-yarn-schedulers)
9. [Complete Flow Diagram](#9-complete-flow-diagram)
10. [Interview Q&A](#10-interview-qa)

---

## 1. What is YARN?

**YARN = Yet Another Resource Negotiator**

YARN is the **resource management layer** of Hadoop. It was introduced in **Hadoop 2.x** to separate two responsibilities that were previously mixed together:

| Responsibility         | Who handles it in YARN?     |
|------------------------|-----------------------------|
| Resource Management    | ResourceManager             |
| Job Monitoring         | ApplicationMaster (per job) |

**Simple Analogy:**
```
YARN is like an Airport Control Tower.

The Control Tower (ResourceManager) manages all runways and gates.
Each Pilot (ApplicationMaster) manages their own flight.
Passengers (Tasks) sit in seats (Containers) on the plane (NodeManager).
```

---

## 2. Why was YARN Introduced?

### Problem with Hadoop 1.x (MRv1)

In Hadoop 1.x, there was a component called **JobTracker** that did everything:

```
JobTracker (Hadoop 1.x)
  |
  |-- Resource Management (which machine runs what)
  |-- Job Scheduling
  |-- Job Monitoring
  |-- Task progress tracking
```

**Problems:**
- Single point of failure — if JobTracker crashes, all jobs fail.
- Could only run MapReduce jobs (no Spark, no Tez, etc.).
- Scalability limit: ~4,000 nodes.

### Solution: YARN (Hadoop 2.x)

```
YARN separates concerns:

ResourceManager    ->  Global resource management only
ApplicationMaster  ->  Per-job coordination
NodeManager        ->  Per-node resource reporting
```

**Benefits of YARN:**
- Supports **multiple frameworks**: MapReduce, Spark, Tez, Flink.
- Scales to **10,000+ nodes**.
- No single point of failure for job tracking.

---

## 3. YARN Architecture — Core Components

### 3.1 ResourceManager (RM)

The **ResourceManager** is the master daemon of YARN.

- Runs on the **master node**.
- Manages cluster resources globally.
- Has two key sub-components:

| Sub-Component    | Role                                                |
|------------------|-----------------------------------------------------|
| Scheduler        | Allocates resources (CPU, memory) to applications  |
| ApplicationsManager | Accepts job submissions, manages ApplicationMasters |

```
ResourceManager
  |
  |-- Scheduler         (allocates containers)
  |-- ApplicationsManager (launches ApplicationMasters)
```

---

### 3.2 NodeManager (NM)

The **NodeManager** runs on **every worker node**.

- Reports available resources (CPU, memory) to ResourceManager.
- Launches and monitors **Containers** on that node.
- Reports container status back to ApplicationMaster.

```
Worker Node
  |
  |-- NodeManager
        |
        |-- Container 1 (running task)
        |-- Container 2 (running task)
        |-- Container 3 (running task)
```

---

### 3.3 ApplicationMaster (AM)

The **ApplicationMaster** is created **per job** — one per submitted application.

- Negotiates resources from the ResourceManager.
- Works with NodeManagers to launch containers.
- Monitors task progress.
- Handles task failures and retries.

> **Key Insight:** The ApplicationMaster itself runs inside a **Container** on a worker node. The ResourceManager does NOT directly manage tasks — it only launches the ApplicationMaster.

---

### 3.4 Container

A **Container** is a bundle of resources:

```
Container = Memory slice + CPU cores
```

**Example:**
```
Container-001:  2 GB RAM, 1 vCore
Container-002:  4 GB RAM, 2 vCores
```

Every task (Map task, Reduce task, Spark executor) runs inside a container.

---

### Component Summary Table

| Component         | Where it runs   | Responsibility                                |
|-------------------|-----------------|-----------------------------------------------|
| ResourceManager   | Master node     | Global resource allocation                    |
| NodeManager       | Every worker    | Launches & monitors containers on that node   |
| ApplicationMaster | One per job     | Job-level coordination, resource negotiation  |
| Container         | Worker nodes    | Isolated execution environment for each task  |

---

## 4. How YARN Runs a Job — Step-by-Step

**Scenario:** You submit a MapReduce Word Count job.

```bash
hadoop jar wordcount.jar WordCount /input /output
```

---

### Step 1 — Client Submits Job

```
Client
  |
  | Submits job (JAR + input path + config)
  v
ResourceManager
```

---

### Step 2 — ResourceManager Launches ApplicationMaster

The ResourceManager allocates a container on one of the worker nodes to run the **ApplicationMaster** for this job.

```
ResourceManager
  |
  | "NodeManager on Node3, launch an AM container"
  v
NodeManager (Node3)
  |
  v
Container-001
  |
  v
ApplicationMaster (started for WordCount job)
```

---

### Step 3 — ApplicationMaster Registers with ResourceManager

The ApplicationMaster starts and registers itself with the ResourceManager.

```
ApplicationMaster --> ResourceManager
  "I am managing Job-001. I need X containers."
```

---

### Step 4 — ApplicationMaster Requests Containers

The ApplicationMaster negotiates with the ResourceManager for containers to run tasks.

```
ApplicationMaster --> ResourceManager
  "I need 10 Map containers (2GB each) on nodes close to my data."
```

ResourceManager allocates containers considering:
- Available resources on each node.
- **Data locality** (prefer nodes where input data blocks reside).

---

### Step 5 — NodeManagers Launch Containers

ResourceManager instructs NodeManagers to launch the allocated containers.

```
ResourceManager --> NodeManager (Node1)
  "Launch Container-002 for Job-001 Map Task 1"

ResourceManager --> NodeManager (Node2)
  "Launch Container-003 for Job-001 Map Task 2"
```

---

### Step 6 — Tasks Run in Containers

Each container runs a Map or Reduce task.

```
Node1: Container-002 -> Map Task 1 (reads HDFS Block1)
Node2: Container-003 -> Map Task 2 (reads HDFS Block2)
Node3: Container-004 -> Map Task 3 (reads HDFS Block3)
```

---

### Step 7 — ApplicationMaster Monitors Progress

```
Container Task ---> progress report ---> ApplicationMaster
ApplicationMaster ---> status ---> ResourceManager
Client can query status from ResourceManager or AM directly.
```

---

### Step 8 — Job Completes

After all tasks finish:
1. ApplicationMaster notifies ResourceManager.
2. ApplicationMaster shuts down.
3. Containers are released back to the cluster.

```
ApplicationMaster --> ResourceManager
  "Job-001 is complete. Releasing all containers."
```

---

## 5. Worked Example — Word Count Job

**Input File:** `logs.txt` (500 MB, split into 4 blocks of 128 MB each)

**Cluster:**
```
Master Node:  ResourceManager
Worker Node1: NodeManager  (hosts Block1, Block2)
Worker Node2: NodeManager  (hosts Block3)
Worker Node3: NodeManager  (hosts Block4)
```

**Job Execution:**

```
Step 1: Client submits wordcount.jar to ResourceManager

Step 2: RM launches ApplicationMaster on Node1
        Container-AM: 1GB RAM, 1 vCore

Step 3: AM requests 4 Map containers + 1 Reduce container

Step 4: RM allocates:
        Node1 -> Container-M1 (Block1), Container-M2 (Block2)
        Node2 -> Container-M3 (Block3)
        Node3 -> Container-M4 (Block4)

Step 5: Map Tasks run (data locality honoured):
        M1: reads Block1 from local disk  (no network needed!)
        M2: reads Block2 from local disk
        M3: reads Block3 from local disk
        M4: reads Block4 from local disk

Step 6: After all Maps complete:
        RM allocates: Node2 -> Container-R1 (Reduce Task)
        Reduce aggregates results from all Map outputs

Step 7: Output written to HDFS /output/
        AM reports completion to RM
        All containers released
```

**Resource Usage:**
```
Container-AM:  1 GB RAM, 1 vCore   (ApplicationMaster)
Container-M1:  2 GB RAM, 1 vCore   (Map Task 1)
Container-M2:  2 GB RAM, 1 vCore   (Map Task 2)
Container-M3:  2 GB RAM, 1 vCore   (Map Task 3)
Container-M4:  2 GB RAM, 1 vCore   (Map Task 4)
Container-R1:  3 GB RAM, 1 vCore   (Reduce Task)
```

---

## 6. YARN Resource Model

YARN tracks two primary resources per node:

| Resource | Configured By               | Example         |
|----------|-----------------------------|-----------------|
| Memory   | `yarn.nodemanager.resource.memory-mb` | 16384 MB (16 GB)|
| vCores   | `yarn.nodemanager.resource.cpu-vcores` | 8               |

**Example Node (16 GB, 8 vCores):**
```
Available: 16 GB RAM, 8 vCores

Running Containers:
  Container-1: 2 GB, 1 vCore  (Map Task)
  Container-2: 2 GB, 1 vCore  (Map Task)
  Container-3: 4 GB, 2 vCores (Reduce Task)

Remaining Free: 8 GB RAM, 4 vCores
```

---

## 7. Fault Tolerance in YARN

### 7.1 If a Task Fails

- The **ApplicationMaster** detects the failure (container exits with error).
- AM requests a **new container** from ResourceManager.
- AM re-runs the failed task in the new container.
- Up to **4 attempts** by default (`mapreduce.map.maxattempts`).

```
Task Failure:
  Container-M2 crashes
     |
     v
  ApplicationMaster detects failure
     |
     v
  AM requests replacement container from RM
     |
     v
  RM allocates Container-M2b on Node3
     |
     v
  Map Task 2 re-runs successfully
```

---

### 7.2 If the ApplicationMaster Fails

- The **ResourceManager** detects AM failure (no heartbeat).
- RM restarts the ApplicationMaster in a new container.
- Up to **2 attempts** by default (`yarn.resourcemanager.am.max-attempts`).

---

### 7.3 If a NodeManager Fails

- ResourceManager stops receiving heartbeats from that NodeManager.
- All containers on that node are marked as failed.
- ApplicationMasters are notified and request replacement containers on healthy nodes.

---

## 8. YARN Schedulers

YARN supports 3 pluggable schedulers:

| Scheduler        | Behaviour                                                          | Best For                        |
|------------------|--------------------------------------------------------------------|---------------------------------|
| FIFO Scheduler   | First In, First Out. One job at a time.                           | Development/testing only        |
| Capacity Scheduler | Cluster divided into queues (e.g., 60% prod, 40% dev). Each queue gets guaranteed capacity. | Multi-tenant clusters (default) |
| Fair Scheduler   | Resources shared equally among all running jobs.                   | Mixed workload clusters         |

**Capacity Scheduler Example:**
```
Total Cluster: 100 containers

Queue: production  -> 60 containers guaranteed
Queue: development -> 40 containers guaranteed

If development queue is idle, production can use up to 100 containers.
```

---

## 9. Complete Flow Diagram

```
====================================================
              YARN JOB EXECUTION FLOW
====================================================

Client
  |
  | 1. Submit application (JAR, config, input path)
  v
ResourceManager
  |
  | 2. Allocate container for ApplicationMaster
  v
NodeManager (Node X)
  |
  | 3. Launch ApplicationMaster container
  v
ApplicationMaster
  |
  | 4. Register with ResourceManager
  | 5. Request containers for tasks
  v
ResourceManager
  |
  | 6. Allocate containers on NodeManagers
  v
NodeManagers (Node 1, 2, 3...)
  |
  | 7. Launch task containers
  v
Containers (Map Tasks / Reduce Tasks / Spark Executors)
  |
  | 8. Execute tasks, report progress to AM
  v
ApplicationMaster
  |
  | 9. Monitor, handle failures, request retries
  | 10. Report completion to ResourceManager
  v
ResourceManager
  |
  | 11. Release all containers
  v
Job Complete — Output on HDFS
```

---

## 10. Interview Q&A

### Q1. What is YARN and why was it introduced?

**Answer:** YARN (Yet Another Resource Negotiator) is Hadoop's resource management layer, introduced in Hadoop 2.x. It was introduced to solve limitations of Hadoop 1.x's JobTracker: single point of failure, inability to run non-MapReduce workloads, and poor scalability. YARN separates resource management (ResourceManager) from job coordination (ApplicationMaster).

---

### Q2. What is the difference between ResourceManager and ApplicationMaster?

**Answer:**
| ResourceManager | ApplicationMaster |
|---|---|
| One per cluster | One per submitted job |
| Manages global cluster resources | Manages a single application's lifecycle |
| Allocates containers | Requests containers and monitors tasks |
| Runs on master node | Runs in a container on a worker node |

---

### Q3. What is a Container in YARN?

**Answer:** A Container is an isolated allocation of resources (memory + CPU cores) on a worker node. Every task — Map task, Reduce task, Spark executor — runs inside a container. The ApplicationMaster itself also runs in a container.

---

### Q4. What is data locality and how does YARN achieve it?

**Answer:** Data locality means running computation on or near the node where the data resides, avoiding network transfer. When the ApplicationMaster requests containers, it provides a **preferred host list** (the nodes storing the input blocks). The ResourceManager tries to allocate containers on those exact nodes first (node-local), then the same rack (rack-local), then any node.

---

### Q5. What happens when a task fails in YARN?

**Answer:** The ApplicationMaster detects the container failure, requests a new container from the ResourceManager, and re-runs the failed task. By default, a task is retried up to 4 times before the job is marked as failed.

---

### Q6. What happens if the ApplicationMaster itself crashes?

**Answer:** The ResourceManager detects the missing heartbeat and restarts the ApplicationMaster in a new container, up to the configured maximum attempts (default: 2). The new AM can recover task progress from HDFS-stored intermediate state.

---

### Q7. What is the difference between YARN's Capacity Scheduler and Fair Scheduler?

**Answer:**
- **Capacity Scheduler:** Divides the cluster into queues with guaranteed capacity. A team gets exactly their allocated quota even if others are idle (unless elastic sharing is configured). Default in most Hadoop distributions.
- **Fair Scheduler:** Resources are shared equally among all running jobs. If only one job runs, it gets all resources. When a second job arrives, resources are split fairly. Good for mixed, interactive workloads.

---

### Q8. Can YARN run frameworks other than MapReduce?

**Answer:** Yes. This is one of YARN's key advantages over Hadoop 1.x. YARN can run **Apache Spark**, **Apache Tez**, **Apache Flink**, **Apache Storm**, and any other framework that implements the YARN ApplicationMaster API.

---

### Q9. What is the role of the NodeManager?

**Answer:** The NodeManager runs on every worker node. It launches and monitors containers on that node, reports resource availability (memory, CPU) to the ResourceManager via heartbeats, and kills containers if the ResourceManager instructs it to.

---

### Q10. How does YARN differ from Hadoop 1.x's JobTracker?

**Answer:**
| JobTracker (Hadoop 1.x) | YARN (Hadoop 2.x) |
|---|---|
| Single process does everything | Separated into RM + AM |
| Single point of failure | AM failure does not crash RM |
| Only MapReduce supported | Multiple frameworks supported |
| Scales to ~4,000 nodes | Scales to 10,000+ nodes |
| No resource isolation | Container-based resource isolation |

---

> **Next Topics to Study:**
> How YARN interacts with MapReduce internally — **Shuffle & Sort**, **Speculative Execution**, and **YARN Timeline Server** for job history.
