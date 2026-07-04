# 📂 HDFS Read & Write Operations — Interview Reference

> **Purpose:** Complete, structured reference for Hadoop HDFS Read/Write interview preparation.  
> **Topics Covered:** Client, NameNode, DataNodes, Write Pipeline, Read Flow, Fault Tolerance.

---

## 📑 Table of Contents

1. [Core Components](#1-core-components)
2. [HDFS Write Operation](#2-hdfs-write-operation)
3. [HDFS Read Operation](#3-hdfs-read-operation)
4. [Fault Tolerance](#4-fault-tolerance)
5. [Design Principle — Why NameNode Doesn't Handle Data](#5-design-principle--why-namenode-doesnt-handle-data)
6. [Complete End-to-End Flow Summary](#6-complete-end-to-end-flow-summary)
7. [Interview Q&A](#7-interview-qa)

---

## 1. Core Components

### 1.1 Client

The **Client** is the application or user that interacts with HDFS.

**Example Command:**
```bash
hdfs dfs -put sales.csv /data/
```

**Client Flow:**
```
You
 |
 V
HDFS Client Library
 |
 V
Hadoop Cluster
```

> **Key Point:** The client **never stores data**. It only communicates with the NameNode (for metadata) and directly with DataNodes (for actual data transfer).

---

### 1.2 NameNode

The **NameNode** is the **brain** of HDFS. It stores only **metadata** — never actual file data.

**What it stores:**

| Metadata Field      | Example                       |
|---------------------|-------------------------------|
| Filename            | `sales.csv`                   |
| Owner & Permissions | `subramani`, `rwxr-xr-x`     |
| Block IDs           | `Block1`, `Block2`, `Block3` |
| Block Locations     | `Block1 → DN1, DN2, DN3`     |
| Replication Info    | Replication Factor = 3        |

**Analogy:**
```
Library Catalog
  Book Name -> Shelf Number

NameNode
  Filename  -> Block Locations

The librarian knows WHERE every book is — but doesn't carry the books.
```

---

### 1.3 DataNodes

**DataNodes** physically store the actual data blocks.

**Example Layout (3 DataNodes):**
```
DataNode1       DataNode2       DataNode3
---------       ---------       ---------
Block A         Block B         Block C
Block D         Block E         Block F
Block G
```

> **Key Point:** DataNodes periodically send **heartbeats** to the NameNode to confirm they are alive.

---

## 2. HDFS Write Operation

**Trigger Command:**
```bash
hdfs dfs -put sales.csv /input/
```

---

### Step 1 — Client Contacts NameNode

The client sends a **create file request** to the NameNode.

```
Client  ---- Request ---->  NameNode
```

**NameNode checks:**
- Does the file already exist?
- Does the user have permission?
- Is enough storage available?

If all checks pass, the NameNode replies **Approved**.

---

### Step 2 — NameNode Assigns Block Locations

Assume:
- **File Size:** 350 MB
- **Block Size:** 128 MB
- **Replication Factor:** 3

**Block Division:**
```
350 MB
  |
  v
Block1 = 128 MB
Block2 = 128 MB
Block3 =  94 MB
```

**NameNode assigns DataNodes for each block:**
```
Block1 -> Replica1: DN1 | Replica2: DN2 | Replica3: DN3
Block2 -> Replica1: DN3 | Replica2: DN2 | Replica3: DN1
Block3 -> Replica1: DN2 | Replica2: DN1 | Replica3: DN3
```

The NameNode sends these block-to-DataNode mappings back to the client.

---

### Step 3 — Client Writes to First DataNode

The client sends the block **directly to the first DataNode** — NOT to the NameNode.

```
Client
  |
  V
DataNode1
```

---

### Step 4 — Pipeline Replication ⭐

Instead of the client sending data to every replica individually:

```
Naive Approach (inefficient):
Client -> DN1
Client -> DN2
Client -> DN3
```

HDFS uses a **pipeline**:
```
Pipeline Approach (efficient):

Client
  |
  V
DN1 --> DN2 --> DN3
```

The client sends each block only **once**. Each DataNode forwards it to the next. This **reduces network traffic** and improves write throughput.

---

### Step 5 — Acknowledgement (ACK)

Once **DN3** receives the full block, ACK flows **backward** through the pipeline:

```
DN3
 ^
 |
DN2
 ^
 |
DN1
 ^
 |
Client  (ready to send next block)
```

Only after receiving ACK does the client send the next packet.

---

### Step 6 — Repeat for All Blocks

The pipeline write + ACK cycle repeats for each block:
```
Block1 -> Block2 -> Block3
```

---

### Step 7 — File Close & Metadata Update

After all blocks are written, the client notifies the NameNode:

```
"File upload completed."
```

**NameNode saves final metadata:**
```
sales.csv
  Block1 -> DN1, DN2, DN3
  Block2 -> DN3, DN1, DN2
  Block3 -> DN2, DN1, DN3
```

Upload Complete.

---

### Write Operation — Complete Flow Diagram

```
                  WRITE OPERATION

        Client
           |
           | 1. Create file request
           v
       NameNode
           |
           | 2. Returns block locations (DN assignments)
           v
        Client
           |
           | 3. Sends Block 1
           v
       DataNode1 --> DataNode2 --> DataNode3
                            ^
                            |
                       ACK flows back
           |
           | 4. Repeat for Block2, Block3
           v
       NameNode updates metadata
```

---

## 3. HDFS Read Operation

**Trigger Command:**
```bash
hdfs dfs -cat /input/sales.csv
```

---

### Step 1 — Client Contacts NameNode

Client sends a **read request**:
```
Client --- "I want sales.csv" ---> NameNode
```

---

### Step 2 — NameNode Returns Block Locations

The NameNode replies with metadata only — **no actual data**:
```
Block1 -> DN2, DN3, DN5
Block2 -> DN4, DN1, DN7
Block3 -> DN4, DN1, DN7
```

---

### Step 3 — Client Chooses Nearest DataNode

For each block, the client picks the **closest replica** to minimize latency:

```
Priority Order:
  1. Same Machine  (lowest latency)
  2. Same Rack
  3. Different Rack (highest latency)
```

---

### Step 4 — Client Reads Each Block Directly

```
Client --> DN2  -> reads Block1
Client --> DN4  -> reads Block2
Client --> DN4  -> reads Block3
```

No data passes through the NameNode.

---

### Step 5 — Client Reassembles the File

```
Block1
  +
Block2
  +
Block3
  =
sales.csv
```

---

### Read Operation — Complete Flow Diagram

```
                   READ OPERATION

        Client
           |
           | 1. Request file
           v
       NameNode
           |
           | 2. Returns block locations (metadata only)
           v
        Client
           |
           | 3. Reads each block from nearest DataNode
           v
       DataNodes (DN2, DN4, DN4...)
           |
           | 4. Client reassembles blocks
           v
       Original File Returned
```

---

### Worked Example — movie.mp4 (300 MB)

| Block  | Size   | DataNode Replicas      |
|--------|--------|------------------------|
| Block1 | 128 MB | DN1, DN2, DN3          |
| Block2 | 128 MB | DN2, DN5, DN6          |
| Block3 |  44 MB | DN4, DN1, DN7          |

**Client reads (choosing nearest replica):**
- Block1 from **DN2**
- Block2 from **DN5**
- Block3 from **DN4**

*(Selection depends on which replica is nearest or least loaded.)*

---

## 4. Fault Tolerance

### 4.1 DataNode Fails During Write

**Scenario:** DN2 crashes mid-write.

```
Failed Pipeline:
Client -> DN1 -> [X] DN2 -> DN3
```

**Recovery:**
1. Client reports the failure to the NameNode.
2. NameNode creates a **new pipeline** (e.g., DN4 replaces DN2).

```
New Pipeline:
Client -> DN1 -> DN4 -> DN3
```

Writing continues. HDFS later **re-replicates** to restore the desired replication factor.

---

### 4.2 DataNode Fails During Read

**Scenario:** Client is reading Block1 from DN2, and DN2 fails.

```
Block1 replicas: DN2 [FAILED]  DN5  DN8
```

**Recovery:**
- Client **automatically switches** to DN5 (next available replica).

```
Client --> DN5  (Block1 read continues)
```

The application **continues without interruption**.

---

## 5. Design Principle — Why NameNode Doesn't Handle Data

**If NameNode handled all data:**
```
Client -> NameNode -> DataNodes
```
The NameNode becomes a **bottleneck** and a **single point of heavy network traffic**.

**HDFS Solution:**
```
Client --> NameNode   (metadata only: file locations, permissions)
Client --> DataNodes  (actual data transfer directly)
```

This allows HDFS to scale to **petabytes** because:
- The NameNode handles only lightweight metadata.
- DataNodes handle all heavy data I/O in parallel.

---

## 6. Complete End-to-End Flow Summary

```
====================================================
                       WRITE
====================================================

Client
  |
  | 1. Create file request
  v
NameNode
  |
  | 2. Returns DataNode locations for each block
  v
Client
  |
  | 3. Sends Block 1 via pipeline
  v
DataNode1 --> DataNode2 --> DataNode3
                     ^
                     | ACK flows back
  |
  | 4. Repeat for all blocks
  v
NameNode updates metadata


====================================================
                       READ
====================================================

Client
  |
  | 1. Request file
  v
NameNode
  |
  | 2. Returns block locations (metadata only)
  v
Client
  |
  | 3. Reads each block from nearest DataNode
  v
DataNodes (parallel reads per block)
  |
  | 4. Client reassembles blocks in order
  v
Original File Returned
```

---

## 7. Interview Q&A

### Q1. Does the client send file data to the NameNode?

**Answer:** No. The client contacts the NameNode **only to obtain metadata** (block locations and permissions). Actual file data is sent directly to the DataNodes.

---

### Q2. Why does HDFS use a pipeline during writes?

**Answer:** The client sends each block only **once** to the first DataNode. That DataNode forwards it to the next, and so on. This reduces network traffic and improves write throughput by avoiding redundant client-to-DataNode transfers.

---

### Q3. How does the client know where the blocks are?

**Answer:** The client first queries the NameNode, which returns the locations of **all replicas for each block**. The client then reads directly from the most appropriate (nearest/least loaded) DataNode.

---

### Q4. Why are blocks replicated?

**Answer:** Replication provides **fault tolerance**. If one DataNode fails, data is still available from another replica. The NameNode monitors replication and creates new replicas to restore the configured replication factor.

---

### Q5. Does the NameNode store file contents?

**Answer:** No. The NameNode stores only **metadata**: filenames, permissions, block IDs, and block replica locations. The actual data resides only on the DataNodes.

---

### Q6. What happens if a DataNode fails during a write?

**Answer:** The client reports the failure to the NameNode. The NameNode reconstructs the pipeline with a healthy replacement DataNode, and writing continues. HDFS later re-replicates data to restore the replication factor.

---

### Q7. What happens if a DataNode fails during a read?

**Answer:** The client automatically switches to another replica of that block. The read continues seamlessly, usually without the application noticing the failure.

---

### Q8. Why doesn't the NameNode handle data transfer?

**Answer:** To avoid making the NameNode a bottleneck. By keeping the NameNode responsible only for metadata, the cluster can scale to petabytes — all heavy data I/O happens directly between clients and DataNodes in parallel.

---

### Q9. What is the default block size in HDFS and why?

**Answer:** The default block size is **128 MB** (configurable). Large block sizes reduce the number of metadata entries the NameNode must manage and reduce seek-time overhead for large sequential reads — the primary HDFS use case.

---

### Q10. What is the replication factor and where is it set?

**Answer:** The **replication factor** (default: **3**) defines how many copies of each block are stored across DataNodes. It can be set cluster-wide in `hdfs-site.xml` (`dfs.replication`) or per-file using:

```bash
hdfs dfs -setrep -w 3 /input/sales.csv
```

---

> **Next Topics to Study:**
> NameNode internals — **FSImage**, **EditLog**, **Checkpointing**, **Secondary NameNode**, and **NameNode High Availability (Active/Standby)**. These build directly on the read/write workflow and are frequently asked in interviews.
