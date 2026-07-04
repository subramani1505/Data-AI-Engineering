# Hadoop Learning Foundations

This document covers the core concepts and architectural foundations necessary to understand Apache Hadoop, including client-server models, nodes, clusters, distributed systems, scaling, fault tolerance, replication, and the master-worker architecture.
---

## 1. Client-Server Architecture
A server is simply a computer whose job is to provide services or resources to other computers (clients).

### Restaurant Analogy
*   **Client (Customer):** Asks for a service (e.g., "One Masala Dosa, please").
*   **Server (Chef):** Receives the request, prepares the food, and delivers it to the customer.

### Technical Concept (e.g., YouTube)
```
[Client (Laptop/Phone)]  ---(Request: "Give me this video")--->  [YouTube Server]
[Client (Laptop/Phone)]  <---(Response: Video stream data)-------  [YouTube Server]
```
*   **Laptop/Phone:** Acts as the client.
*   **YouTube Server:** Serves the video file.
*   **Common Examples:** Google Search, YouTube Server, Netflix Server, Gmail Server.

---

## 2. Node
A **Node** is any individual machine participating in a network or cluster. 

*   A node can be a physical server, a personal laptop, a desktop, or a virtual machine (VM).
*   **Office Analogy:** If you have four employees (Rahul, Ravi, Sita, Kiran) working individually, each employee represents a single worker. In server terms, if you have four servers (Server 1, Server 2, Server 3, Server 4), each server is one **node**.

---

## 3. Cluster
A **Cluster** is a group of multiple computers (nodes) connected together via a fast local network that work in unison to perform tasks as a single system. Instead of relying on one ultra-powerful, expensive computer, we combine many affordable computers to share the workload.

``` 
                  +-----------------------------------+
                  |              CLUSTER              |
                  |                                   |
                  |  +---------+         +---------+  |
                  |  | Node 1  |         | Node 2  |  |
                  |  +---------+         +---------+  |
                  |                                   |
                  |  +---------+         +---------+  |
                  |  | Node 3  |         | Node 4  |  |
                  |  +---------+         +---------+  |
                  +-----------------------------------+
```

### Why Do We Need a Cluster?
When dealing with massive scale (e.g., 100 TB of data, millions of concurrent users, complex calculations), a single computer will eventually face bottlenecks:
1.  It becomes extremely slow.
2.  It becomes exponentially expensive to upgrade.
3.  It represents a **Single Point of Failure (SPOF)**.

By grouping machines into a cluster, they share the storage and processing workload.

### Analogies
*   **Moving Furniture:** Moving 100 heavy boxes alone (single computer) takes 10 hours. Hiring 4 people (a cluster) to carry 25 boxes each takes only 2.5 hours.
*   **Cricket Team:** One player cannot bat, bowl, field, and wicket-keep all at once. An 11-player team acts like a cluster, working together to win.
*   **Restaurant Kitchen:** A single chef taking orders, cooking biryani, making chapati, and serving food is extremely slow. A cluster of chefs (Chef 1 for Biryani, Chef 2 for Curry, Chef 3 for Chapati, Chef 4 for Desserts) finishes the work significantly faster.
*   **Google Search Cluster:** Instead of a single supercomputer, Google uses millions of interconnected standard servers working together to answer billions of searches.

### Real-world & Computational Examples
*   **YouTube Video Processing:**
    *   **Single Server:** If 1,000 videos are uploaded, one server processing them sequentially might take hours.
    *   **Cluster of 10 Servers:** The workload is shared. Server 1 processes 100 videos, Server 2 processes 100 videos, ..., and Server 10 processes 100 videos. Processing completes 10 times faster.
*   **Sum Calculation (Parallel Processing):**
    *   *Goal:* Calculate the sum of numbers from 1 to 1,000,000.
    *   **Single Computer:** Calculates from 1 to 1,000,000 sequentially alone.
    *   **Cluster with 4 Nodes:** 
        *   Node 1 calculates the sum from 1 to 250,000.
        *   Node 2 calculates the sum from 250,001 to 500,000.
        *   Node 3 calculates the sum from 500,001 to 750,000.
        *   Node 4 calculates the sum from 750,001 to 1,000,000.
        *   *Final Answer:* `Result 1` + `Result 2` + `Result 3` + `Result 4`. This is called **Parallel Processing**.

### Cluster Hardware Aggregation Example
| Node Name | RAM | CPU Cores |
| :--- | :--- | :--- |
| Node 1 | 16 GB | 8 Core |
| Node 2 | 16 GB | 8 Core |
| Node 3 | 16 GB | 8 Core |
| Node 4 | 16 GB | 8 Core |
| **Total Cluster Power** | **64 GB** | **32 Cores** |

CPU Core : A core is the individual processing unit inside a cpu. That reads instructions and perform calculations.

### Why Grouping is Better Than One Large Machine
*   **Single Machine (64 GB RAM, 32 Cores):** If this machine crashes, the entire system goes down. Upgrading it beyond a certain point is physically impossible or cost-prohibitive.
*   **Four-Node Cluster (4x 16 GB RAM, 8 Cores):** If Node 1 crashes, the remaining 3 nodes continue working. The system stays online.
*   **Key Benefits:** Scalability, Fault Tolerance, High Availability, Faster Processing.

---

## 4. Distributed Systems
A **Distributed System** is a system where data storage and processing are spread across multiple independent computers (nodes) that work together over a network. To the end-user, the system appears as a single coherent computer.

```
                              Distributed Storage
               +-----------------------------------------------+
               |                 100 GB File                   |
               +-----------------------------------------------+
                                      |
                 +----------+---------+----------+----------+
                 |          |                    |          |
                 v          v                    v          v
             +-------+  +-------+            +-------+  +-------+
             | Node1 |  | Node2 |            | Node3 |  | Node4 |
             | 25 GB |  | 25 GB |            | 25 GB |  | 25 GB |
             +-------+  +-------+            +-------+  +-------+
```

### Storage and Processing Distribution
*   **Distributed Storage:** Instead of storing a 100 GB file on a single server (where a crash means absolute data loss), the file is split into smaller portions (e.g., 25 GB each) and distributed across Node 1, Node 2, Node 3, and Node 4.
*   **Distributed Processing:** To process 1 TB of data, each node processes its local 250 GB segment simultaneously. The final results are combined at the end. This is called **Parallel Processing**.

### Real-world Examples
*   **Netflix:** Millions of users watch videos simultaneously. Netflix doesn't store and serve all these movies from a single computer. The media files and user requests are distributed across thousands of servers around the world. However, when you open the app, it looks like a single unified service.
*   **Hadoop Clusters (e.g., 1 TB file):** 
    *   The file is split into multiple blocks (e.g., Block 1, Block 2, Block 3) and stored across different workers.
    *   During execution, Worker 1 processes Block 1, Worker 2 processes Block 2, and Worker 3 processes Block 3 simultaneously. This parallel execution is why Hadoop can process petabytes of data efficiently.

### Differences Between a Cluster and a Distributed System

| Feature | Cluster | Distributed System |
| :--- | :--- | :--- |
| **Definition** | A group of interconnected computers working together closely to perform a task. | Multiple independent computers communicating and coordinating to share resources. |
| **Coupling** | **Tightly Coupled:** Nodes are usually in the same physical location and connected via a dedicated local network. | **Loosely Coupled:** Nodes can be geographically dispersed and connected via WAN or the Internet. |
| **Communication** | High-speed local area network (LAN). | General network protocols over LAN, WAN, or the internet. |
| **Primary Goal** | Maximize processing power and performance for heavy calculations. | Maximize resource sharing, reliability, and system availability. |
| **Scalability** | Limited by physical space and local network infrastructure. | Highly scalable; can expand globally. |
| **Fault Tolerance** | Moderate; depends heavily on local cluster management. | Extremely high; built from the ground up to expect node failures. |
| **Examples** | Hadoop cluster, Kubernetes cluster, Beowulf cluster. | The Internet, Cloud services (AWS, Azure), Blockchain networks. |

---

## 5. Scaling: Vertical vs. Horizontal
When user demand or data volume increases, systems must scale to handle the load.

```
   Vertical Scaling (Scale Up)               Horizontal Scaling (Scale Out)
         +-------------+                    +-----+  +-----+  +-----+  +-----+
         |             |                    |Node1|  |Node2|  |Node3|  |Node4|
         |  Upgraded   |                    +-----+  +-----+  +-----+  +-----+
         |   Server    |                         (Add more cheap servers)
         |             |
         +-------------+
    (Make one machine stronger)
```

### 1. Vertical Scaling (Scaling Up)
Increasing the capacity of a single machine by adding more RAM, faster CPU cores, or larger storage drives.
*   **Analogy:** Forcing a single supermarket cashier to work faster instead of hiring helper cashiers.
*   **Pros:** Simple to implement; does not require complex distributed software or networking setups.
*   **Cons:** Hard hardware limits exist (you cannot upgrade a single machine indefinitely). If that single machine crashes, the entire system goes offline (Single Point of Failure).

### 2. Horizontal Scaling (Scaling Out)
Adding more standard, cost-effective machines (nodes) to the existing system.
*   **Analogy:** Opening more cashier lanes in a supermarket during busy hours to distribute the customers.
*   **Pros:** Highly scalable (add as many machines as needed), cost-effective using commodity hardware, and provides fault tolerance.
*   **Cons:** Requires specialized software (like Apache Hadoop) to manage data and coordinate tasks across nodes.
*   **Note:** Hadoop relies entirely on **Horizontal Scaling**.

---

## 6. Fault Tolerance and Replication
Distributed architectures must be prepared for hardware failures.

### Fault Tolerance
**Fault Tolerance** is the property that enables a system to continue operating properly in the event of the failure of one or more of its components.
*   **Analogy:** If a company has four employees and one goes on leave, the remaining three employees divide the work. The company doesn't stop operating.

### Replication
**Replication** is the process of storing duplicate copies of data across multiple physical machines so that if one machine fails, the data remains safe and accessible.
*   **Analogy:** Storing your family photos on your laptop, a USB drive, and cloud storage. If your laptop crashes, you do not lose your photos because copies exist elsewhere.

### Replication in Hadoop (HDFS)
By default, Hadoop splits files into blocks and creates **3 copies** of each block across different nodes in the cluster.

```
       File 1 ---> Split into [Block 1], [Block 2], [Block 3]
       
       [Block 1 Copies] ---> Stored on Node 1, Node 2, Node 3
       [Block 2 Copies] ---> Stored on Node 4, Node 5, Node 6
       [Block 3 Copies] ---> Stored on Node 7, Node 8, Node 9
```

*   **Why 3 Copies?**
    *   **2 Copies:** Risky. If one node fails and the second node experiences a read error during recovery, data is lost.
    *   **4+ Copies:** Safe but wastes storage space and network bandwidth.
    *   **3 Copies:** The optimal balance between safety, cost, and performance.

---

## 7. Master-Worker Architecture in Hadoop
Hadoop operates on a Master-Worker (formerly Master-Slave) topology to manage storage and computation.

```
                         +-----------------------+
                         |  MASTER NODE (Manager)|
                         |   - NameNode          |
                         |   - ResourceManager   |
                         +-----------------------+
                                     |
                +--------------------+--------------------+
                |                    |                    |
                v                    v                    v
      +------------------+  +------------------+  +------------------+
      |  WORKER NODE 1   |  |  WORKER NODE 2   |  |  WORKER NODE 3   |
      |   - DataNode     |  |   - DataNode     |  |   - DataNode     |
      |   - NodeManager  |  |   - NodeManager  |  |   - NodeManager  |
      +------------------+  +------------------+  +------------------+
```

### 1. The Master Node (The Manager)
The Master Node does not store the bulk of the raw data. Instead, it manages the metadata, coordinates the cluster, and distributes tasks.
*   **Responsibilities:**
    *   Tracking which physical worker nodes store which data blocks (metadata).
    *   Managing data replication and balancing.
    *   Scheduling processing jobs.
    *   Monitoring worker health and handling node failures.
*   **Components:**
    *   **NameNode:** Manages the HDFS metadata (storage directory tree and file-to-block mappings).
    *   **ResourceManager:** Coordinates cluster resources and schedules execution tasks (YARN).

### 2. Worker Nodes (The Laborers)
Worker nodes are the workhorses of the cluster. They store the raw data blocks and perform computational tasks.
*   **Responsibilities:**
    *   Storing data blocks assigned by the Master Node.
    *   Executing processing tasks on their local data.
    *   Reporting status back to the Master Node.
*   **Components:**
    *   **DataNode:** Stores the actual data blocks in HDFS.
    *   **NodeManager:** Launches and monitors processing tasks on the node (YARN).

- **Office Analogy:** A construction site manager (Master Node) plans, assigns work, and monitors progress, while the bricklayers/workers (Worker Nodes) perform the actual manual labor.

---

## 8. Summary: How Hadoop Solves Big Data Problems

| Big Data Challenge | Hadoop Core Solution | How It Works |
| :--- | :--- | :--- |
| **Data too big for one computer** | **Distributed Storage (HDFS)** | Files are split into blocks and spread across multiple nodes. |
| **Processing takes too long** | **Distributed Processing (MapReduce)** | Computations are processed in parallel on the nodes holding the data. |
| **Single machine failures** | **Replication & Fault Tolerance** | 3 copies of every block are stored; if a node goes down, others take over. |
| **Limited scaling capacity** | **Horizontal Scaling** | New nodes can be added to the cluster dynamically without downtime. |

### Complete Infrastructure Flow
```
Need Capacity Upgrade 
  └──> Horizontal Scaling 
        └──> Add Commodity Nodes 
              └──> Form a Cluster 
                    └──> Distributed Storage & Processing 
                          └──> Data Replication (3x) 
                                └──> Achieve Fault Tolerance 
                                      └──> Managed by Master Node 
                                            └──> Executed by Worker Nodes 
                                                  └──> Apache Hadoop
```