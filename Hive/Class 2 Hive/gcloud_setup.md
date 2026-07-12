# GCloud Setup Guide — Connecting to Dataproc & Running Hive

> **Goal**: Configure `gcloud` CLI on your Windows laptop, copy a dataset to the Dataproc cluster master node, upload it to HDFS, and prepare it for Hive.

---

## Overview — What We Are Doing

```
Your Windows Laptop
│
├── Reviews.csv (dataset)
│
└── gcloud CLI (installed)
        │
        │  SCP (Secure Copy)
        ▼
GCP Project
│
├── Dataproc Cluster
│       │
│       ├── Master Node (Linux VM)  ← Copy file here
│       ├── Worker Node 1
│       └── Worker Node 2
│
├── Compute Engine
├── Cloud Storage
└── BigQuery
```

---

## Step 1: Initialize gcloud CLI

Run this command to configure your GCP account for the first time:

```bash
gcloud init
```

This will prompt you to:
1. **Log in** with your Google account
2. **Select a GCP project** (e.g., `reliable-cacao-501508-p7`)
3. **Set a default region and zone** (e.g., `us-central1` / `us-central1-c`)

> To connect to a GCP cluster, you need **3 things configured**:
> - ✅ **Project** — which GCP project to use
> - ✅ **Region** — where your cluster is hosted
> - ✅ **Zone** — the specific zone inside the region

---

## Step 2: Verify Your Configuration

After `gcloud init`, verify everything is set correctly:

```bash
gcloud config list
```

**Expected output:**

```ini
[compute]
region = us-central1
zone   = us-central1-c

[core]
project = reliable-cacao-501508-p7
account = subramani.uvce1@gmail.com
```

---

## Step 3: Find Your Dataproc Cluster Name

```bash
gcloud dataproc clusters list --region=us-central1
```

**Example output:**

```
NAME              WORKER_COUNT  STATUS   ZONE
my-hive-cluster   2             RUNNING  us-central1-a
```

> **Note**: After `gcloud init`, you may see `[compute]` config but **not** `[dataproc]` config. You need to add it manually.

---

## Step 4: Configure Dataproc Region, Zone & Cluster Name

Set the Dataproc defaults so you don't have to specify them every time:

```bash
# Set the default Dataproc region
gcloud config set dataproc/region us-central1

# Set the default Dataproc zone
gcloud config set dataproc/zone us-central1-c

# Set your cluster name as the default
gcloud config set dataproc/cluster my-hive-cluster
```

**Verify — run again:**

```bash
gcloud config list
```

**Expected output after fix:**

```ini
[compute]
region  = us-central1
zone    = us-central1-c

[core]
project = reliable-cacao-501508-p7
account = subramani.uvce1@gmail.com

[dataproc]
cluster = my-hive-cluster     ← Now this appears!
region  = us-central1
zone    = us-central1-c
```

---

## Step 5: Copy Dataset from Laptop to Master Node

Navigate to the folder containing your dataset first:

```bash
# On Windows — go to the dataset folder
cd C:\Users\subramani.v\Documents\Subramani_PW\Hive\Dataset
```

Now copy the file using `gcloud compute scp`:

```bash
gcloud compute scp Reviews.csv subramani_uvce1@my-hive-cluster-m:/home/subramani_uvce1 --zone=us-central1-a
```

**Command breakdown:**

| Part | Meaning |
|------|---------|
| `Reviews.csv` | The file on your local laptop |
| `subramani_uvce1` | Your username on the Linux VM |
| `my-hive-cluster-m` | The master node VM name (`-m` = master) |
| `/home/subramani_uvce1` | Destination folder on the master node |
| `--zone=us-central1-a` | The zone where your cluster is running |

in gcloud terminal it shows : Reviews.csv | 293852 kB | 2825.5 kB/s | ETA: 00:00:00 | 100%

**What happens internally:**

```
Windows Laptop
│
│  Reviews.csv (300 MB)
│
└───────────────────────┐
                        │
                 gcloud compute scp
                        │
              Step 1: Authenticate with GCP
                        │
              Step 2: Find VM (my-hive-cluster-m)
                        │
              Step 3: Connect via SSH (Port 22)
                        │
              Step 4: Transfer file using SCP protocol
                        ▼
          Master Node (Linux VM)
          │
          └── /home/subramani_uvce1/Reviews.csv  ✅ File arrives here
```

---

## Step 6: SSH into the Master Node & Verify the File

```bash
# SSH into the master node
gcloud compute ssh subramani_uvce1@my-hive-cluster-m --zone=us-central1-a

# Once inside the master node, verify the file is there
ls /home/subramani_uvce1/
# Output: Reviews.csv
```

---

## Step 7: Understand the Two File Systems on the Master Node

The master node has **two separate file systems** — be clear about which one you're using:

```
Master Node
│
├── Linux File System (local)     ←  Reviews.csv is here after SCP
│       /
│       ├── home/
│       │     └── subramani_uvce1/
│       │              └── Reviews.csv   ← Copied here via SCP
│       └── etc/
│
└── Hadoop File System - HDFS     ← We need to put the file here for Hive
        /
        ├── tmp/
        ├── user/
        └── var/
```

> **Why move to HDFS?** Hive reads data from **HDFS**, not from the local Linux file system.
> So we first copy to the Linux VM (SCP), then move from Linux to HDFS.

---

## Step 8: Create a Directory in HDFS

```bash
# Create the HDFS input directory for your user
hadoop fs -mkdir -p /user/subramani_uvce1/input
```

**Flag explanation:**

| Flag | Meaning |
|------|---------|
| `-mkdir` | Create a directory in HDFS |
| `-p` | Create all parent directories if they don't exist (no error if already exists) |

**Verify the directory was created:**

```bash
hadoop fs -ls /user
```

**Expected output:**

```
Found 1 items
drwxr-xr-x  - subramani_uvce1 supergroup  0 2026-07-07 10:00 /user/subramani_uvce1
```

---

## Step 9: Upload the File from Linux → HDFS

```bash
# Upload Reviews.csv from Linux local storage to HDFS
hadoop fs -put /home/subramani_uvce1/Reviews.csv /user/subramani_uvce1/input/

# Verify the file is in HDFS
hadoop fs -ls /user/subramani_uvce1/input/
```

**Expected output:**

```
Found 1 items
-rw-r--r-- 3 subramani_uvce1 supergroup 314572800 2026-07-07 10:05 /user/subramani_uvce1/input/Reviews.csv
```
-rw-r--r--   2 subramani_uvce1 hadoop  300904694 2026-07-10 12:17 /user/subramani_uvce1/input/Reviews.csv
---
## Description of Above result from the Hadoop Cluster

 -   rw-   r--   r--
 │    │     │     │
 │    │     │     └── Others : read only
 │    │     └──── Group  : read only
 │    └────────── Owner  : read + write (NO execute)
 └─────────────── File type: `-` = file, `d` = directory

Here 2 is the replication factor = 2 replicas (copies) of this file stored across 2 DataNodes.

usaully in HDFS we have by defualt 3 replicas are there for fault tolerance.

# just for an Reference
File is 300 MB
100 MB in DN 1
100 MB in DN 2
100 MB in DN 3

| Field | Value | Meaning |
|---|---|---|
| **Permissions** | `-rw-r--r--` | File type + access rights (owner/group/others) |
| **Replication Factor** | `2` | Number of copies stored across DataNodes |
| **Owner** | `subramani_uvce1` | The user who owns the file |
| **Group** | `hadoop` | The group associated with the file |
| **Size** | `300904694` | File size in bytes (~287 MB) |
| **Date** | `2026-07-10` | Last modification date |
| **Time** | `12:17` | Last modification time (UTC) |
| **Path** | `/user/subramani_uvce1/input/Reviews.csv` | Full HDFS file path |

## Complete Setup — End to End Summary

```
Step 1: gcloud init
        └── Configure account, project, region, zone

Step 2: gcloud config list
        └── Verify [compute] and [core] sections

Step 3: gcloud dataproc clusters list --region=us-central1
        └── Find your cluster name

Step 4: gcloud config set dataproc/region us-central1
        gcloud config set dataproc/zone us-central1-c
        gcloud config set dataproc/cluster my-hive-cluster
        └── Fix missing [dataproc] section

Step 5: gcloud compute scp Reviews.csv user@my-hive-cluster-m:/home/user --zone=us-central1-a
        └── Copy file from Windows → Master Node (Linux local)

Step 6: gcloud compute ssh user@my-hive-cluster-m --zone=us-central1-a
        └── SSH in and verify file is there

Step 7: hadoop fs -mkdir -p /user/subramani_uvce1/input
        └── Create HDFS input directory

Step 8: hadoop fs -put /home/subramani_uvce1/Reviews.csv /user/subramani_uvce1/input/
        └── Upload from Linux local → HDFS

Step 9: hadoop fs -ls /user/subramani_uvce1/input/
        └── Verify file is in HDFS → Ready for Hive!
```

---

## Common Issues & Fixes

| Problem | Cause | Fix |
|---------|-------|-----|
| `[dataproc]` section missing in `gcloud config list` | Dataproc region/zone not set | Run `gcloud config set dataproc/region` and `dataproc/zone` |
| `gcloud compute scp` fails | Wrong zone specified | Check zone with `gcloud dataproc clusters list` and use the correct `--zone` |
| `Permission denied` during SCP | SSH key not set up | Run `gcloud compute ssh` once first to generate keys |
| `hadoop fs -put` fails | HDFS directory doesn't exist | Create it first with `hadoop fs -mkdir -p /path/` |
| `File not found` after SCP | Wrong path or filename case | Linux is case-sensitive — `Reviews.csv` ≠ `reviews.csv` |

---

## Quick Reference Cheat Sheet

| Command | Purpose |
|---------|---------|
| `gcloud init` | Initialize and configure gcloud |
| `gcloud config list` | View all current configurations |
| `gcloud config set dataproc/region us-central1` | Set Dataproc region |
| `gcloud config set dataproc/zone us-central1-c` | Set Dataproc zone |
| `gcloud config set dataproc/cluster <name>` | Set default cluster |
| `gcloud dataproc clusters list --region=us-central1` | List all Dataproc clusters |
| `gcloud compute scp <file> <user>@<vm>:/path --zone=<zone>` | Copy file to VM |
| `gcloud compute ssh <user>@<vm> --zone=<zone>` | SSH into VM |
| `hadoop fs -mkdir -p /path/` | Create HDFS directory |
| `hadoop fs -put <local-file> <hdfs-path>` | Upload to HDFS |
| `hadoop fs -ls /path/` | List HDFS files |
| `hadoop fs -cat /path/file` | View HDFS file content |
