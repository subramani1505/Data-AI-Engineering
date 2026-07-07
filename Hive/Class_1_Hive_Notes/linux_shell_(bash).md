# Module 1: Linux Shell (Bash) — A Clear & Short Guide

---

## 1. What is Bash?

**Bash** (Bourne Again Shell) is the **most commonly used shell in Linux**.

- Just like CMD and PowerShell are Windows shells, **Bash is Linux's shell**.
- Its job: read your commands → understand them → ask Linux to execute them → show results.
- It is the **primary tool for Big Data Engineers** since all cloud servers run Linux.

```
You (type a command)
        │
        ▼
  GNOME Terminal / SSH Terminal   ← Window where you type
        │
        ▼
     Bash Shell                   ← Reads & interprets the command
        │
        ▼
    Linux Kernel                  ← Executes the task
        │
        ▼
   CPU / RAM / SSD                ← Hardware does the work
        │
        ▼
   Result shown back on Terminal
```

---

## 2. Why is Bash Important?

**Almost every cloud server and Big Data cluster runs Linux.**

| Platform | OS | Shell Used |
|----------|----|-----------|
| Google Cloud VM (GCP) | Linux | ✅ Bash |
| AWS EC2 | Linux | ✅ Bash |
| Azure Virtual Machines | Linux | ✅ Bash |
| Hadoop Clusters | Linux | ✅ Bash |
| Spark Clusters | Linux | ✅ Bash |
| Kubernetes Nodes | Linux | ✅ Bash |
| Docker Containers | Linux | ✅ Bash |

> When you **SSH into any of these**, you get a Bash shell by default.
> That's why **Bash is the #1 skill for Data Engineers**.

---

## 3. Bash Prompt Explained

```bash
subramani@ubuntu:~$
│           │     │ │
│           │     │ └── $ = normal user  |  # = root (admin) user
│           │     └──── ~ = home directory (/home/subramani)
│           └────────── hostname (machine name)
└────────────────────── username
```

---

## 4. Essential Bash Commands

### 4.1 — Navigation

| Task | Command | Example |
|------|---------|---------|
| Show current directory | `pwd` | `pwd` → `/home/subramani` |
| List files & folders | `ls` | `ls` |
| List with details | `ls -l` | shows size, date, permissions |
| List including hidden | `ls -a` | shows `.bashrc`, `.ssh` etc. |
| Go into a folder | `cd folder` | `cd Projects` |
| Go back one level | `cd ..` | `cd ..` |
| Go to home directory | `cd ~` | `cd ~` |
| Clear the screen | `clear` | `clear` |

**Example:**

```bash
pwd
# Output: /home/subramani

cd Projects/Hive
pwd
# Output: /home/subramani/Projects/Hive

ls -l
# Output:
# drwxr-xr-x 2 subramani subramani 4096 Jul 7 10:00 raw_data
# -rw-r--r-- 1 subramani subramani  512 Jul 7 09:50 employees.csv
```

---

### 4.2 — Create Files & Folders

| Task | Command | Example |
|------|---------|---------|
| Create a directory | `mkdir name` | `mkdir Hive_Project` |
| Create nested directories | `mkdir -p a/b/c` | `mkdir -p Data/Hive/raw` |
| Create an empty file | `touch file.txt` | `touch employees.csv` |
| Write text to a file | `echo "text" > file` | `echo "id,name" > data.csv` |
| Append text to a file | `echo "text" >> file` | `echo "1,John" >> data.csv` |

**Example:**

```bash
# Create folder structure for a project
mkdir -p DataEngineering/Hive/raw_data

# Create an empty CSV file
touch employees.csv

# Write a header line to the CSV
echo "id,name,dept,salary" > employees.csv

# Add a data row
echo "1,Subramani,Engineering,72000" >> employees.csv

# Verify
cat employees.csv
# Output:
# id,name,dept,salary
# 1,Subramani,Engineering,72000
```

---

### 4.3 — Read / View Files

| Task | Command | Example |
|------|---------|---------|
| View full file content | `cat file` | `cat employees.csv` |
| View page by page | `less file` | `less large_file.csv` |
| View first N lines | `head -n 5 file` | `head -5 data.csv` |
| View last N lines | `tail -n 5 file` | `tail -5 data.csv` |
| Search inside a file | `grep "word" file` | `grep "Sales" data.csv` |
| Count lines in a file | `wc -l file` | `wc -l data.csv` |

**Example:**

```bash
cat employees.csv
# Output:
# id,name,dept,salary
# 1,Subramani,Engineering,72000
# 2,Anitha,HR,48000
# 3,Ravi,Sales,55000

# Show only first 2 data rows
head -2 employees.csv

# Search for a specific department
grep "Sales" employees.csv
# Output: 3,Ravi,Sales,55000

# Count total rows
wc -l employees.csv
# Output: 4 employees.csv (including header)
```

---

### 4.4 — Copy, Move & Delete

| Task | Command | Example |
|------|---------|---------|
| Copy a file | `cp src dest` | `cp data.csv backup/` |
| Copy a folder | `cp -r src dest` | `cp -r Hive/ Hive_backup/` |
| Move or rename | `mv old new` | `mv data.csv archive/` |
| Delete a file | `rm file` | `rm old.csv` |
| Delete a folder + contents | `rm -r folder` | `rm -r OldData/` |

**Example:**

```bash
# Copy CSV to backup folder
cp employees.csv /home/subramani/backup/

# Rename the file
mv employees.csv emp_data.csv

# Delete an old folder
rm -r OldProject/
```

---

### 4.5 — Permissions

| Task | Command | Example |
|------|---------|---------|
| Make script executable | `chmod +x script.sh` | Then run `./script.sh` |
| Give full permissions | `chmod 777 file` | All users: read/write/execute |
| View file permissions | `ls -l` | `ls -l data.csv` |
| Change file owner | `chown user file` | `chown hadoop data.csv` |

**Example:**

```bash
# Create and run a shell script
touch run.sh
echo "echo Hello from Bash!" > run.sh
chmod +x run.sh
./run.sh
# Output: Hello from Bash!
```

---

### 4.6 — Bash in Big Data (Hive & HDFS)

```bash
# SSH into a GCP Dataproc cluster
ssh -i ~/.ssh/gcp_key subramani@34.123.45.67

# Once inside the cluster (Linux Bash), run Hive
hive

# Run HDFS commands from Bash
hadoop fs -ls /tmp/input_data/
hadoop fs -put employees.csv /tmp/input_data/
hadoop fs -cat /tmp/input_data/employees.csv

# Run a Hive query directly from Bash (no need to open hive shell)
hive -e "SELECT * FROM department_data LIMIT 5;"

# Run a Hive query file from Bash
hive -f queries.sql
```

---

## 5. Bash Scripting — Automate Tasks

A **shell script** is a `.sh` file with a list of Bash commands that run automatically.

**Example — `setup.sh`:**

```bash
#!/bin/bash
# Script: setup.sh
# Purpose: Set up Hive project structure and upload data

echo "=== Starting Setup ==="

# Create project folders
mkdir -p DataEngineering/Hive/raw_data
echo "Folders created"

# Upload data to HDFS
hadoop fs -mkdir -p /tmp/input_data/
hadoop fs -put employees.csv /tmp/input_data/
echo "Data uploaded to HDFS"

# Run Hive setup query
hive -e "CREATE DATABASE IF NOT EXISTS hive_db;"
echo "Hive database ready"

echo "=== Setup Complete ==="
```

**Run it:**

```bash
chmod +x setup.sh
./setup.sh

# Output:
# === Starting Setup ===
# Folders created
# Data uploaded to HDFS
# Hive database ready
# === Setup Complete ===
```

---

## 6. Bash vs CMD vs PowerShell

| Feature | Bash (Linux) | CMD (Windows) | PowerShell (Windows) |
|---------|-------------|---------------|----------------------|
| Operating System | Linux / Mac | Windows | Windows (also Linux/Mac) |
| Shell Type | Linux shell | Traditional Windows | Modern Windows |
| Output Type | Text | Text | Objects |
| Scripting | ✅ Excellent (`.sh`) | Basic (`.bat`) | ✅ Excellent (`.ps1`) |
| Automation | ✅ Excellent | Limited | ✅ Excellent |
| Cloud / Big Data | ✅ Primary tool | ❌ Rarely | Sometimes |
| Primary Use | Servers, cloud, Big Data | Legacy Windows tasks | Windows admin, Azure |

---

## 7. Quick Reference Cheat Sheet

| Command | Description | Example |
|---------|-------------|---------|
| `pwd` | Show current directory | `pwd` |
| `ls -la` | List all files with details | `ls -la` |
| `cd folder` | Go into folder | `cd Projects` |
| `cd ..` | Go back one level | `cd ..` |
| `cd ~` | Go to home directory | `cd ~` |
| `mkdir -p` | Create nested folders | `mkdir -p a/b/c` |
| `touch` | Create empty file | `touch data.csv` |
| `echo "text" >` | Write to file | `echo "id,name" > data.csv` |
| `cat` | View file | `cat data.csv` |
| `head -n` | First N lines | `head -5 data.csv` |
| `tail -n` | Last N lines | `tail -5 data.csv` |
| `grep` | Search in file | `grep "Sales" data.csv` |
| `wc -l` | Count lines | `wc -l data.csv` |
| `cp` | Copy file | `cp a.csv backup/` |
| `mv` | Move / rename | `mv old.csv new.csv` |
| `rm -r` | Delete folder | `rm -r OldData/` |
| `chmod +x` | Make executable | `chmod +x script.sh` |
| `ssh` | Connect to remote server | `ssh user@ip` |
| `scp` | Copy file over SSH | `scp file user@ip:/path` |
| `clear` | Clear screen | `clear` |

---

## 8. Key Takeaways

> **Bash** = The most important shell for Data Engineers — all Big Data tools run on Linux.

> **Why Bash?** → Every cloud server (GCP, AWS, Azure), Hadoop, Spark, and Docker uses Linux → Bash is how you control them.

> **Bash scripts (`.sh`)** let you automate repetitive tasks like uploading files, running Hive queries, and setting up clusters.

> **CMD & PowerShell** are for Windows machines — but in production Big Data environments, **Bash is the standard**.
