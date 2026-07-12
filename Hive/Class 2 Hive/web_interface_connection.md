# Connecting to Hive / YARN Web Interface via SSH Tunnel

> **Goal**: Access the Dataproc cluster web UIs (YARN, HDFS, Hive) from your Windows browser using an SSH tunnel.

---

## Why Do We Need an SSH Tunnel?

The Dataproc cluster web UIs (YARN, HDFS) are only accessible **inside the GCP network**.
They are NOT exposed to the public internet for security reasons.

An SSH tunnel acts as a **secure bridge** between your laptop and the cluster:

```
Your Windows Laptop
        │
        │  SSH Tunnel (SOCKS5 proxy on port 1080)
        ▼
GCP Network
        │
        ▼
hadoop-hive-cluster-m  (Master Node)
        │
        ├── :8088  YARN ResourceManager UI
        ├── :9870  HDFS NameNode UI
        └── :8080  Hadoop Overview UI
```

---

## Step 1: Create the SSH Tunnel

Run this in your **Windows CMD** (single line — no backslash needed):

```cmd
gcloud compute ssh hadoop-hive-cluster-m --project=reliable-cacao-501508-p7 --zone=us-central1-b -- -D 1080 -N
```

### What each part means:

| Flag / Part | Meaning |
|---|---|
| `hadoop-hive-cluster-m` | Master node of your Dataproc cluster |
| `--project=reliable-cacao-501508-p7` | Your GCP project ID |
| `--zone=us-central1-b` | Zone where the cluster is running |
| `-- -D 1080` | Opens SOCKS5 proxy on your local port 1080 |
| `-- -N` | No command execution — just keep the tunnel alive |

### Expected behaviour:
- A **PuTTY window** will open and show:
  ```
  Using username "subramani.v".
  Authenticating with public key "..."
  ```
- After authentication the terminal goes **blank/frozen**
- ✅ This is NORMAL — the tunnel is active and running

> ⚠️ **Do NOT close this PuTTY/CMD window.** If you close it, the tunnel dies and Chrome loses connection.

---

## Step 2: Open Chrome Through the Proxy

Open a **new CMD window** (keep the tunnel window open) and run:

```cmd
"C:\Program Files\Google\Chrome\Application\chrome.exe" --proxy-server="socks5://localhost:1080" --user-data-dir="C:\tmp\hadoop-hive-cluster-m" http://hadoop-hive-cluster-m:8088
```

### What each part means:

| Flag | Meaning |
|---|---|
| `--proxy-server="socks5://localhost:1080"` | Route all Chrome traffic through the SSH tunnel |
| `--user-data-dir="C:\tmp\hadoop-hive-cluster-m"` | Separate Chrome profile (avoids conflict with your normal Chrome) |
| `http://hadoop-hive-cluster-m:8088` | Opens YARN ResourceManager UI directly |

---

## Web UI Ports — Quick Reference

| Port | Web UI | What You Can See |
|---|---|---|
| `:8088` | **YARN ResourceManager** | All running / completed MapReduce jobs |
| `:9870` | **HDFS NameNode UI** | HDFS file system, DataNode health |
| `:8080` | **Hadoop Overview** | Cluster summary |
| `:10002` | **HiveServer2 UI** | Hive query sessions |
| `:19888` | **Job History Server** | Past completed MapReduce job history |

To switch between UIs, just change the port in Chrome:
```
http://hadoop-hive-cluster-m:9870   ← HDFS UI
http://hadoop-hive-cluster-m:8088   ← YARN UI
```

---

## Windows vs Linux Command Comparison

| Task | Linux / macOS | Windows CMD |
|---|---|---|
| Line continuation | `\` backslash | `^` caret or just one line |
| SSH Tunnel command | Multi-line with `\` | Single line — no `\` |
| Chrome path | `/usr/bin/google-chrome` | `C:\Program Files\Google\Chrome\Application\chrome.exe` |

---

## Common Errors & Fixes

| Error | Cause | Fix |
|---|---|---|
| `unrecognized arguments: \` | Using Linux `\` in Windows CMD | Write command on one line |
| `did you mean '--zone'?` | `\--zone` instead of `--zone` | No space/backslash before `--` flags |
| `us-central-1b` zone error | Wrong zone format (extra hyphen) | Use `us-central1-b` (no hyphen before 1) |
| Chrome shows "This site can't be reached" | Tunnel is not running | Check if PuTTY window is still open |
| PuTTY window closes immediately | Authentication failed | Re-run `gcloud init` and set correct project/zone |

---

## Full Flow — End to End

```
Step 1: Open CMD Window 1
        └── gcloud compute ssh hadoop-hive-cluster-m --project=... --zone=... -- -D 1080 -N
              └── PuTTY opens → authenticates → goes blank (tunnel is LIVE)

Step 2: Open CMD Window 2 (new window)
        └── chrome.exe --proxy-server="socks5://localhost:1080" ... http://hadoop-hive-cluster-m:8088
              └── Chrome opens → routes through tunnel → YARN UI loads

Step 3: Inside YARN UI
        └── See all running Hive / MapReduce jobs
        └── Monitor Map and Reduce task progress live

Step 4: When done
        └── Close Chrome
        └── Close PuTTY window → tunnel closes
```

---

## Pro Tips

- Run a Hive query in one terminal and watch the **YARN UI at :8088** — you can see the Map/Reduce job running live with progress bars.
- Use **:9870** to browse HDFS files visually — navigate to `/user/subramani_uvce1/input/` to confirm your CSV is there.
- The `-N` flag keeps the SSH tunnel open without running any command on the server — it is purely for port forwarding.

---

## Checking Block Count & Replication Factor in the UI

> ⚠️ **Common Mistake**: Many people land on the YARN UI (`:8088`) and look for block info there — it is NOT there.
> Block and replication info is ONLY in the **HDFS NameNode UI at `:9870`**.

### Which UI Shows What?

| Port | UI | Contains Block / Replication Info? |
|---|---|---|
| `:8088` | YARN ResourceManager | ❌ No — only MapReduce job info |
| `:9870` | HDFS NameNode | ✅ Yes — blocks, replication, DataNodes |

---

### Step 1: Open the HDFS NameNode UI

In Chrome (with the SSH tunnel active), go to:

```
http://hadoop-hive-cluster-m:9870
```

You will see the **Hadoop Overview page** with cluster-level summary.

---

### Step 2: Navigate to Your File

```
Top Menu → Utilities → Browse the file system
```

In the path box, type:

```
/user/subramani_uvce1/input
```

Then click on **Reviews.csv**.

---

### Step 3: What You Will See

After clicking the file, a block info panel opens:

```
File: /user/subramani_uvce1/input/Reviews.csv

Replication:      2
Block Size:       128 MB
Number of Blocks: 3  (because 287 MB / 128 MB = 3 blocks)

Block 0:  blk_xxxxxxxxx  →  [worker-node-0, worker-node-1]
Block 1:  blk_xxxxxxxxx  →  [worker-node-0, worker-node-1]
Block 2:  blk_xxxxxxxxx  →  [worker-node-0, worker-node-1]
```

### Block Count Calculation:

```
File Size  = 300,904,694 bytes ≈ 287 MB
Block Size = 128 MB (HDFS default)

Block 1 →   0 MB to 128 MB
Block 2 → 128 MB to 256 MB
Block 3 → 256 MB to 287 MB  (partial block)

Total Blocks = 3
Replication  = 2
Total physical copies = 3 × 2 = 6 chunks stored across DataNodes
```

---

### Alternative — Check from Terminal (No UI needed)

```bash
# Full block details with DataNode locations
hdfs fsck /user/subramani_uvce1/input/Reviews.csv -files -blocks -locations
```

**Output:**
```
/user/subramani_uvce1/input/Reviews.csv:
  Replication: 2
  Block(s): 3
  0. blk_1234  len=134217728  repl=2  [DataNode1:50010, DataNode2:50010]
  1. blk_1235  len=134217728  repl=2  [DataNode1:50010, DataNode2:50010]
  2. blk_1236  len=32469238   repl=2  [DataNode1:50010, DataNode2:50010]
Status: HEALTHY
```

---

### HDFS UI Summary — Navigation Cheatsheet

```
http://hadoop-hive-cluster-m:9870
        │
        ├── Overview page
        │       └── Cluster summary, DataNodes count, replication setting
        │
        ├── Datanodes tab
        │       └── See all worker nodes, their storage used/available
        │
        └── Utilities → Browse the file system
                └── /user/subramani_uvce1/input/
                        └── Reviews.csv
                                └── Block count, Replication, Block IDs, DataNode locations
```

