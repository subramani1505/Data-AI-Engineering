# Module 1: Google Cloud Shell — A Clear & Short Guide

---

## 1. What is Google Cloud Shell?

**Google Cloud Shell** is a **free, browser-based Linux terminal** provided by Google Cloud Platform (GCP).

- No installation needed — it runs **directly in your web browser**.
- It gives you a **Bash shell** on a small Linux VM managed by Google.
- Pre-installed with tools like `gcloud`, `kubectl`, `git`, `python`, `hadoop`, and more.
- It's the fastest way to interact with GCP resources without setting up anything locally.

```
Your Browser (Chrome / Firefox / Edge)
        │
        │   Opens Google Cloud Console
        ▼
┌─────────────────────────────────┐
│     Google Cloud Console        │
│  console.cloud.google.com       │
│                                 │
│  [ Activate Cloud Shell ]  🖥️   │  ← Click this button
└───────────────┬─────────────────┘
                │
                ▼
┌─────────────────────────────────┐
│     Google Cloud Shell          │
│  (Bash terminal in browser)     │
│                                 │
│  user@cloudshell:~$  _          │  ← You type here
└─────────────────────────────────┘
```

> **In simple words**: You get a full Linux terminal inside your browser — no SSH setup, no VM configuration needed.

---

## 2. Key Features of Google Cloud Shell

| Feature | Details |
|---------|---------|
| **OS** | Debian Linux (Ubuntu-based) |
| **Shell** | Bash |
| **Storage** | 5 GB persistent home directory (`/home/username`) |
| **Free** | ✅ Free to use (no charges) |
| **Pre-installed Tools** | `gcloud`, `gsutil`, `bq`, `kubectl`, `git`, `python3`, `java`, `docker` |
| **Access** | Browser only — no installation |
| **Timeout** | Disconnects after ~20 min of inactivity |
| **Custom tools** | You can install any Linux tools with `apt-get` |

---

## 3. How to Open Google Cloud Shell

### Method 1 — From GCP Console:

```
1. Go to: https://console.cloud.google.com
2. Log in with your Google account
3. Click the "Activate Cloud Shell" button (terminal icon, top-right corner)
4. A terminal panel opens at the bottom of the page
5. Wait ~30 seconds for it to start
```

### Method 2 — Directly in Browser:

```
Go to: https://shell.cloud.google.com
→ Opens Cloud Shell directly in a full browser tab
```

### Method 3 — From SSH (for advanced use):

```bash
# If you prefer to SSH into Cloud Shell from your local terminal
gcloud cloud-shell ssh
```

---

## 4. Cloud Shell Prompt Explained

```bash
subramani@cloudshell:~ (my-gcp-project)$
│           │          │  │              │
│           │          │  │              └── $ = normal user
│           │          │  └──────────────── your GCP project name
│           │          └─────────────────── ~ = home directory
│           └────────────────────────────── "cloudshell" = machine name
└────────────────────────────────────────── your Google username
```

---

## 5. Essential Cloud Shell Commands

### 5.1 — Basic Navigation (Same as Linux Bash)

```bash
# Show current directory
pwd
# Output: /home/subramani_v

# List files
ls -la

# Change directory
cd /tmp

# Clear screen
clear
```

---

### 5.2 — GCP-Specific Commands (`gcloud` CLI)

**`gcloud`** is the main command-line tool for controlling GCP resources.

```bash
# Check which project you are working in
gcloud config get-value project
# Output: my-gcp-project-123

# List all your GCP projects
gcloud projects list

# Set the active project
gcloud config set project my-gcp-project-123

# List all available GCP regions
gcloud compute regions list

# List all VM instances
gcloud compute instances list

# List Dataproc clusters
gcloud dataproc clusters list --region=us-central1
```

---

### 5.3 — Google Cloud Storage Commands (`gsutil`)

**`gsutil`** is used to manage files in **Google Cloud Storage (GCS) buckets**.

```bash
# List all your GCS buckets
gsutil ls

# List files inside a bucket
gsutil ls gs://my-bucket/

# Upload a file from Cloud Shell to GCS
gsutil cp employees.csv gs://my-bucket/input_data/

# Download a file from GCS to Cloud Shell
gsutil cp gs://my-bucket/output/result.csv ~/

# Copy all files in a folder to GCS (recursive)
gsutil cp -r Projects/ gs://my-bucket/projects/

# Delete a file from GCS
gsutil rm gs://my-bucket/old_file.csv
```

---

### 5.4 — Connecting to Dataproc Cluster from Cloud Shell

```bash
# SSH into a Dataproc cluster master node (from Cloud Shell)
gcloud compute ssh cluster-name-m --zone=us-central1-a

# Once inside the cluster, use Hive
hive

# Or run HDFS commands
hadoop fs -ls /tmp/input_data/

# Upload file from Cloud Shell to cluster HDFS
hadoop fs -put ~/employees.csv /tmp/input_data/

# Run a Hive query directly from Cloud Shell (without opening hive shell)
gcloud dataproc jobs submit hive \
    --cluster=my-cluster \
    --region=us-central1 \
    --execute "SELECT * FROM department_data LIMIT 10;"
```

---

### 5.5 — BigQuery CLI (`bq`)

```bash
# List all datasets in your project
bq ls

# Run a SQL query directly from Cloud Shell
bq query --use_legacy_sql=false \
    "SELECT dept_name, AVG(salary) FROM hive_db.department_data GROUP BY dept_name"

# Load a CSV file from GCS into BigQuery
bq load --source_format=CSV \
    my_dataset.my_table \
    gs://my-bucket/data.csv \
    id:INTEGER,name:STRING,salary:INTEGER
```

---

## 6. Cloud Shell Editor (GUI)

Cloud Shell also has a built-in **web-based code editor** (similar to VS Code).

```
How to open:
1. In Cloud Shell terminal, click the "Open Editor" button (pencil icon)
   OR
2. Run: cloudshell edit filename.py

Features:
- Full file browser on the left panel
- Syntax highlighting
- Edit files without leaving the browser
- Integrated terminal at the bottom
```

---

## 7. Cloud Shell vs Local Terminal vs SSH

| Feature | Google Cloud Shell | Local Terminal | SSH to Server |
|---------|-------------------|---------------|---------------|
| Setup required | ❌ None | Install tools | SSH key setup |
| Runs in browser | ✅ Yes | ❌ No | ❌ No |
| Pre-installed GCP tools | ✅ Yes | ❌ Manual install | ❌ Manual install |
| Internet access | ✅ Yes | ✅ Yes | ✅ Yes |
| Persistent storage | 5 GB | Your local disk | Server disk |
| Free | ✅ Yes | ✅ Yes | Cost of server |
| Best for | Quick GCP tasks | Heavy local work | Full server control |

---

## 8. Real-World Workflow Example

**Data Engineer Workflow using Cloud Shell:**

```bash
# Step 1: Open Cloud Shell in browser
# → Go to console.cloud.google.com → Click terminal icon

# Step 2: Set your project
gcloud config set project my-gcp-project-123

# Step 3: Create a GCS bucket to store data
gsutil mb gs://hive-raw-data-bucket/

# Step 4: Upload local data to GCS
gsutil cp employees.csv gs://hive-raw-data-bucket/input_data/

# Step 5: SSH into the Dataproc cluster
gcloud compute ssh my-dataproc-cluster-m --zone=us-central1-a

# Step 6: Run HDFS + Hive on the cluster
hadoop fs -put ~/employees.csv /tmp/input_data/
hive -e "CREATE TABLE emp AS SELECT * FROM department_data;"

# Step 7: Exit cluster, download result to Cloud Shell
exit
gsutil cp gs://hive-raw-data-bucket/output/result.csv ~/

# Step 8: View result
cat result.csv
```

---

## 9. Useful Cloud Shell Tips

| Tip | How |
|-----|-----|
| **Open in full browser tab** | Click "Open in new window" icon in Cloud Shell |
| **Upload file to Cloud Shell** | Click ⋮ menu → "Upload file" |
| **Download file from Cloud Shell** | Click ⋮ menu → "Download file" |
| **Install extra tools** | `sudo apt-get install tool-name` |
| **Run Python scripts** | `python3 script.py` |
| **Keep session alive** | Cloud Shell disconnects after 20 min idle — type something to stay active |
| **Persistent storage** | Files in `/home/username` persist between sessions — others don't |

---

## 10. Quick Reference Cheat Sheet

| Command | Description | Example |
|---------|-------------|---------|
| `gcloud config get-value project` | Show active GCP project | — |
| `gcloud config set project` | Switch GCP project | `gcloud config set project my-proj` |
| `gcloud projects list` | List all projects | — |
| `gcloud compute instances list` | List VMs | — |
| `gcloud dataproc clusters list` | List Dataproc clusters | `--region=us-central1` |
| `gcloud compute ssh cluster-m` | SSH into cluster | `--zone=us-central1-a` |
| `gsutil ls` | List GCS buckets | — |
| `gsutil cp src dest` | Copy to/from GCS | `gsutil cp file gs://bucket/` |
| `gsutil rm` | Delete GCS file | `gsutil rm gs://bucket/file` |
| `gsutil mb` | Create GCS bucket | `gsutil mb gs://my-bucket/` |
| `bq ls` | List BigQuery datasets | — |
| `bq query` | Run BigQuery SQL | `bq query --use_legacy_sql=false "..."` |
| `cloudshell edit` | Open file in editor | `cloudshell edit file.py` |
| `sudo apt-get install` | Install a tool | `sudo apt-get install vim` |

---

## 11. Key Takeaways

> **Google Cloud Shell** = A free, browser-based Linux terminal with all GCP tools pre-installed.

> **No setup needed** — just open your browser, go to GCP Console, and click the terminal icon.

> **`gcloud`** = Controls GCP services (VMs, Dataproc, Kubernetes).

> **`gsutil`** = Manages files in Google Cloud Storage (GCS).

> **`bq`** = Runs BigQuery SQL queries from the terminal.

> **For Big Data**: Cloud Shell is your gateway to Dataproc clusters — SSH in, run HDFS and Hive commands, submit Spark jobs, all from the browser.
