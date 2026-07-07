# Module 1: Terminal — A Complete Guide

---

## 1. What is a Terminal?

A **Terminal** (also called a **Console** or **Shell**) is a program that provides a text-based interface to interact with the operating system.

```
You (User)
    │
    │  Type a command (e.g., ls -l)
    ▼
┌─────────────┐
│   Terminal  │   ← The window where you type
│  (Shell UI) │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    Shell    │   ← Interprets the command (Bash, PowerShell, Zsh)
│  (bash/zsh) │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│     OS      │   ← Executes the instruction (Linux, Windows, macOS)
│   Kernel    │
└──────┬──────┘
       │
       ▼
   Output returned to Terminal
```

> **In simple words**: The Terminal is the window → The Shell is the interpreter → The OS does the actual work.

---

## 2. Terminal vs GUI — Key Differences

| Feature | GUI (Graphical UI) | Terminal (CLI) |
|---------|-------------------|----------------|
| Interaction | Mouse clicks & icons | Text commands |
| Speed | Slower for repetitive tasks | Faster with commands |
| Automation | Limited | Fully scriptable |
| Learning Curve | Easy for beginners | Requires command knowledge |
| Used in Big Data | Hadoop Ambari, Hue | HDFS, Hive, Spark shells |
| Remote Access | Needs VNC/RDP (heavy) | SSH (lightweight) |
| Error Details | Often hidden | Always visible |

---

## 3. Types of Terminals

### 3.1 Windows Terminals

| Terminal | Description | How to Open |
|----------|-------------|-------------|
| **Command Prompt (CMD)** | Basic Windows terminal | `Win + R` → type `cmd` → Enter |
| **PowerShell** | Advanced scripting shell | `Win + X` → PowerShell |
| **Windows Terminal** | Modern tabbed terminal (supports CMD, PS, WSL) | Search "Windows Terminal" in Start |
| **Git Bash** | Linux-like terminal on Windows | Installed with Git |

### 3.2 Linux / Mac Terminals

| Terminal | Description | OS |
|----------|-------------|----|
| **Bash** | Bourne Again Shell — most common | Linux / Mac |
| **Zsh** | Extended Bash with plugins | Linux / Mac (default on Mac) |
| **Fish** | User-friendly shell | Linux |
| **Gnome Terminal** | Default Linux terminal (Ubuntu) | Ubuntu / Debian |
| **iTerm2** | Popular macOS terminal | macOS |

### 3.3 Big Data / Cloud Terminals

| Terminal | Used For |
|----------|----------|
| **Hive CLI** | Running HQL queries on Hive |
| **HDFS Shell** | Managing files in Hadoop HDFS |
| **Spark Shell** | Interactive Spark computations |
| **GCP Cloud Shell** | Terminal inside Google Cloud Platform browser |
| **SSH Terminal** | Connecting to remote servers/clusters |

---

## 4. Opening a Terminal

### Windows — Command Prompt:
```
Method 1: Win + R → type "cmd" → Enter
Method 2: Search "Command Prompt" in Start Menu
Method 3: Right-click folder → "Open in Terminal"
```

### Windows — PowerShell:
```
Method 1: Win + X → "Windows PowerShell"
Method 2: Search "PowerShell" in Start Menu
```

### Linux / Mac — Bash Terminal:
```
Method 1: Ctrl + Alt + T  (Ubuntu shortcut)
Method 2: Applications → Terminal
Method 3: Right-click Desktop → "Open Terminal"
```

### GCP Cloud Shell (Browser-based):
```
1. Go to console.cloud.google.com
2. Click the "Activate Cloud Shell" button (top-right)
3. A terminal opens at the bottom of the browser
```

---

## 5. Terminal Prompt Explained

When you open a terminal, you see a **prompt** — this tells you who you are and where you are.

### Linux / Mac Prompt:
```bash
subramani@ubuntu:~$
│           │     │ │
│           │     │ └── $ = normal user   # = root/admin user
│           │     └──── ~ = home directory (/home/subramani)
│           └────────── hostname (machine name)
└────────────────────── username
```

### Windows CMD Prompt:
```
C:\Users\subramani.v>
│                    │
│                    └── > = ready for input
└────────────────────── current directory path
```

### Windows PowerShell Prompt:
```
PS C:\Users\subramani.v>
│                       │
│                       └── > = ready for input
└─────────────────────────── PS = PowerShell indicator
```

---

## 6. Essential Terminal Commands

### 6.1 Navigation Commands

| Task | Linux/Mac | Windows CMD | Windows PowerShell |
|------|-----------|-------------|-------------------|
| Show current path | `pwd` | `cd` | `pwd` or `cd` |
| List files | `ls` | `dir` | `ls` or `dir` |
| List with details | `ls -l` | `dir` | `ls -l` |
| List hidden files | `ls -a` | `dir /a` | `ls -Force` |
| Go into folder | `cd folder` | `cd folder` | `cd folder` |
| Go back one level | `cd ..` | `cd ..` | `cd ..` |
| Go to home directory | `cd ~` | `cd %USERPROFILE%` | `cd ~` |
| Go to root | `cd /` | `cd \` | `cd \` |
| Clear screen | `clear` | `cls` | `cls` or `clear` |

**Examples:**

```bash
# Linux — Navigate to a project folder
cd /home/user/Projects/Hive

# Linux — Go back to home directory
cd ~

# Check where you are
pwd
# Output: /home/user/Projects/Hive

# List all files with details
ls -la
# Output:
# drwxr-xr-x  2 user user 4096 Jul  7 10:00 .
# drwxr-xr-x 10 user user 4096 Jul  7 09:50 ..
# -rw-r--r--  1 user user  512 Jul  7 10:00 depart_data.csv
```

---

### 6.2 File & Directory Management

| Task | Linux/Mac | Windows CMD |
|------|-----------|-------------|
| Create folder | `mkdir folder` | `mkdir folder` |
| Create nested folders | `mkdir -p a/b/c` | `mkdir a\b\c` |
| Create empty file | `touch file.txt` | `type nul > file.txt` |
| Copy file | `cp src dest` | `copy src dest` |
| Copy folder | `cp -r src dest` | `xcopy src dest /E` |
| Move / Rename | `mv old new` | `move old new` |
| Delete file | `rm file.txt` | `del file.txt` |
| Delete folder | `rm -r folder` | `rmdir /s folder` |

**Examples:**

```bash
# Create project structure in one command (Linux)
mkdir -p DataEngineering/Hive/raw_data

# Create a sample data file
touch employees.csv

# Copy data file to backup
cp employees.csv DataEngineering/Hive/raw_data/

# Rename a file
mv employees.csv emp_data.csv

# Delete old backup
rm -r OldBackup/
```

---

### 6.3 Viewing File Content

| Task | Linux/Mac | Windows CMD |
|------|-----------|-------------|
| Print full file | `cat file.txt` | `type file.txt` |
| Scroll through file | `less file.txt` | `more file.txt` |
| First N lines | `head -n 5 file.txt` | — |
| Last N lines | `tail -n 5 file.txt` | — |
| Search inside file | `grep "word" file.txt` | `findstr "word" file.txt` |
| Count lines | `wc -l file.txt` | — |
| Follow live file updates | `tail -f file.txt` | — |

**Examples:**

```bash
# View CSV data
cat depart_data.csv
# Output:
# 10,Sales,101,55000
# 20,HR,102,48000
# 30,Engineering,103,72000

# View first 3 lines only
head -3 depart_data.csv

# Search for a specific department
grep "Engineering" depart_data.csv
# Output: 30,Engineering,103,72000

# Count how many rows (lines) in file
wc -l depart_data.csv
# Output: 10 depart_data.csv

# Monitor a log file in real time
tail -f /var/log/hive/hive.log
```

---

### 6.4 Process Management

| Task | Linux/Mac | Windows CMD |
|------|-----------|-------------|
| List running processes | `ps aux` | `tasklist` |
| Kill a process by ID | `kill <PID>` | `taskkill /PID <PID>` |
| Kill by name | `pkill firefox` | `taskkill /IM firefox.exe` |
| Run in background | `command &` | — |
| Show running jobs | `jobs` | — |
| Top (live process monitor) | `top` or `htop` | `taskmgr` (GUI) |

**Examples:**

```bash
# See all running processes
ps aux

# Find a specific process
ps aux | grep hive
# Output: user 1234 0.5 2.1 ... hive

# Kill a stuck Hive process
kill 1234

# Run a script in the background
./run_etl.sh &

# Check background jobs
jobs
# Output: [1]+ Running ./run_etl.sh &
```

---

### 6.5 Permissions (Linux/Mac)

| Task | Command | Example |
|------|---------|---------|
| View file permissions | `ls -l` | `ls -l data.csv` |
| Make file executable | `chmod +x script.sh` | Run shell scripts |
| Give full permissions | `chmod 777 file` | All users read/write/execute |
| Change file owner | `chown user file` | `chown hadoop data.csv` |

**Understanding Permissions:**

```
-rw-r--r--  1 subramani staff 1024 Jul 7 10:00 data.csv
│└──┘└──┘└──┘
│ │   │   │
│ │   │   └── Others: r-- (read only)
│ │   └────── Group: r-- (read only)
│ └────────── Owner: rw- (read + write)
└──────────── - = file, d = directory

Permission bits: r=read(4), w=write(2), x=execute(1)
chmod 755 = Owner: rwx(7), Group: r-x(5), Others: r-x(5)
```

**Examples:**

```bash
# Make a shell script executable
chmod +x setup_hive.sh

# Run it
./setup_hive.sh

# Give full access to a data directory
chmod 777 /tmp/input_data/

# Change owner to hadoop user
chown hadoop:hadoop /tmp/input_data/
```

---

### 6.6 Network & Remote Access

| Task | Linux/Mac | Windows |
|------|-----------|---------|
| Check network connectivity | `ping google.com` | `ping google.com` |
| SSH into a server | `ssh user@ip` | `ssh user@ip` (PowerShell) |
| Copy files over SSH | `scp file.csv user@ip:/path/` | `scp file.csv user@ip:/path/` |
| Download a file | `wget URL` or `curl -O URL` | `curl -O URL` (PowerShell) |
| Check open ports | `netstat -tulnp` | `netstat -an` |

**Examples:**

```bash
# SSH into a GCP Dataproc cluster
ssh -i ~/.ssh/gcp_key subramani@34.123.45.67

# Copy a local CSV to remote server
scp depart_data.csv subramani@34.123.45.67:/tmp/input_data/

# Download a file from the internet
wget https://example.com/data/employees.csv

# Check if cluster is reachable
ping 34.123.45.67
```

---

## 7. Terminal Shortcuts (Productivity Boosters)

### Linux / Mac Bash Shortcuts:

| Shortcut | Action |
|----------|--------|
| `Tab` | Auto-complete command or filename |
| `↑` / `↓` | Navigate command history |
| `Ctrl + C` | Stop/cancel running command |
| `Ctrl + Z` | Pause/suspend running process |
| `Ctrl + L` | Clear the screen |
| `Ctrl + A` | Move cursor to start of line |
| `Ctrl + E` | Move cursor to end of line |
| `Ctrl + U` | Delete entire line |
| `Ctrl + R` | Search command history |
| `!!` | Repeat last command |
| `history` | Show all past commands |

**Examples:**

```bash
# Use Tab to autocomplete
cd Proj[TAB]      # auto-completes to "cd Projects/"

# Search command history
# Press Ctrl + R, then type "hive"
# Shows last command containing "hive"

# Repeat last command (useful for sudo)
sudo !!

# See last 10 commands
history | tail -10
```

### Windows CMD Shortcuts:

| Shortcut | Action |
|----------|--------|
| `Tab` | Auto-complete |
| `↑` / `↓` | Command history |
| `F7` | Show command history in popup |
| `Ctrl + C` | Cancel command |
| `cls` | Clear screen |
| `Ctrl + A` | Select all text |

---

## 8. Terminal for Big Data — Hive & HDFS

### Launch Hive from Terminal:

```bash
# Open terminal and start Hive shell
hive

# You will see the Hive prompt:
# hive>

# Run a query
hive> show databases;
# Output:
# OK
# default
# hive_db

hive> use hive_db;
hive> show tables;
hive> select * from department_data limit 5;

# Exit Hive
hive> exit;
```

### HDFS Commands from Terminal:

```bash
# Check HDFS storage
hadoop fs -df -h /

# List HDFS files
hadoop fs -ls /tmp/input_data/

# Upload local file to HDFS
hadoop fs -put ~/depart_data.csv /tmp/input_data/

# Verify upload
hadoop fs -ls /tmp/input_data/

# View HDFS file without downloading
hadoop fs -cat /tmp/input_data/depart_data.csv | head -5

# Download from HDFS to local
hadoop fs -get /tmp/input_data/depart_data.csv ~/downloads/
```

### Running Hive Non-Interactively from Terminal:

```bash
# Run a single HQL command from terminal (no need to open hive shell)
hive -e "show databases;"

# Run an HQL file from terminal
hive -f my_queries.sql

# Run with output saved to file
hive -e "select * from department_data;" > output.csv
```

---

## 9. Shell Scripting — Automate Terminal Commands

A **shell script** is a file containing a series of terminal commands that run automatically.

**Example — Create a Shell Script to Set Up Hive:**

```bash
# Create script file
touch setup_hive.sh

# Open and edit it
nano setup_hive.sh
```

**Contents of `setup_hive.sh`:**

```bash
#!/bin/bash
# Script: setup_hive.sh
# Description: Automates Hive database and table setup

echo "=== Starting Hive Setup ==="

# Create database
hive -e "create database if not exists hive_db;"
echo "Database created"

# Upload data to HDFS
hadoop fs -mkdir -p /tmp/input_data/
hadoop fs -put ~/depart_data.csv /tmp/input_data/
echo "Data uploaded to HDFS"

# Create table
hive -f create_table.sql
echo "Table created"

echo "=== Setup Complete ==="
```

**Run the script:**

```bash
# Make executable
chmod +x setup_hive.sh

# Run
./setup_hive.sh

# Output:
# === Starting Hive Setup ===
# Database created
# Data uploaded to HDFS
# Table created
# === Setup Complete ===
```

---

## 10. Quick Reference Cheat Sheet

### Linux/Mac Terminal

| Command | Description | Example |
|---------|-------------|---------|
| `pwd` | Show current path | `pwd` |
| `ls -la` | List all files with details | `ls -la` |
| `cd /path` | Change directory | `cd /tmp` |
| `mkdir -p` | Create nested dirs | `mkdir -p a/b/c` |
| `touch` | Create empty file | `touch data.csv` |
| `cat` | View file | `cat data.csv` |
| `head -n` | First N lines | `head -5 data.csv` |
| `tail -n` | Last N lines | `tail -5 data.csv` |
| `grep` | Search in file | `grep "Sales" data.csv` |
| `cp` | Copy | `cp a.csv backup/` |
| `mv` | Move/rename | `mv a.csv b.csv` |
| `rm -r` | Delete folder | `rm -r old/` |
| `chmod +x` | Make executable | `chmod +x script.sh` |
| `ssh` | Remote login | `ssh user@ip` |
| `scp` | Copy over SSH | `scp file user@ip:/path` |
| `ps aux` | Show processes | `ps aux \| grep hive` |
| `kill` | Kill process | `kill 1234` |
| `clear` | Clear screen | `clear` |
| `history` | Show past commands | `history \| tail -20` |

### Windows Terminal (CMD / PowerShell)

| Command | Description | Example |
|---------|-------------|---------|
| `dir` | List files | `dir` |
| `cd` | Change/show directory | `cd Projects` |
| `mkdir` | Create folder | `mkdir Data` |
| `copy` | Copy file | `copy a.txt b.txt` |
| `move` | Move file | `move a.txt C:\tmp` |
| `del` | Delete file | `del old.txt` |
| `rmdir /s` | Delete folder | `rmdir /s OldData` |
| `type` | View file | `type data.csv` |
| `findstr` | Search in file | `findstr "Sales" data.csv` |
| `cls` | Clear screen | `cls` |
| `tasklist` | Show processes | `tasklist` |
| `taskkill` | Kill process | `taskkill /PID 1234` |
| `ssh` | Remote login (PS) | `ssh user@ip` |
| `ping` | Test connectivity | `ping google.com` |

---

## 11. Key Takeaways

> **Terminal** = The window/application you open to type commands.

> **Shell** = The interpreter inside the terminal (Bash, Zsh, PowerShell).

> **CLI** = The style of interaction (text-based), which the Terminal enables.

> In **Big Data Engineering**: The terminal is your primary tool for managing HDFS files, launching Hive, submitting Spark jobs, and connecting to cloud clusters via SSH.

> **Shell scripting** lets you automate repetitive tasks — a critical skill for Data Engineers.
