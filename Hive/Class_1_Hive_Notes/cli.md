# Module 1: Command Line Interface (CLI) vs Graphical User Interface (GUI)

---

## 1. How Humans Communicate with Computers

There are **two major ways** humans interact with computers:

| Method | Full Form | Interaction Style |
|--------|-----------|-------------------|
| **GUI** | Graphical User Interface | Mouse clicks, icons, windows |
| **CLI** | Command Line Interface | Text-based commands typed in a terminal |

---

## 2. GUI — Graphical User Interface

A **GUI** lets you interact with the computer using **visual elements** like icons, buttons, and menus.

### How it works (Step-by-step):

```
User Action         →   Computer Response
──────────────────────────────────────────
Double-click folder →   Folder opens
Click "New Folder"  →   Dialog box appears
Drag file to folder →   File gets moved
```

### Example — Creating a Folder in Windows GUI:

```
1. Right-click on Desktop
2. Select "New" → "Folder"
3. Type the folder name: "Projects"
4. Press Enter
✅ Folder "Projects" is created!
```

### Where GUI is Used:
- **Windows Explorer** — Browse files and folders
- **Hadoop Ambari / Hue** — Web UI for managing Hadoop/Hive
- **MySQL Workbench** — Visual database management
- **VS Code** — Code editor with GUI interface

---

## 3. CLI — Command Line Interface

A **CLI** is a **text-based interface** where users type commands directly into a terminal/shell.

Instead of clicking, you **type an instruction → press Enter → computer executes it**.

### How it works (Step-by-step):

```
User Types Command   →   OS Reads It   →   Executes Task   →   Returns Response
─────────────────────────────────────────────────────────────────────────────────
mkdir Projects       →   OS reads cmd  →   Creates folder  →   (no output = success)
```

### Where CLI is Used:
- **Windows** → Command Prompt (`cmd`), PowerShell
- **Linux/Mac** → Bash Terminal
- **Hadoop** → HDFS CLI (`hadoop fs -ls /`)
- **Hive** → Hive CLI (`hive` shell)

---

## 4. Core CLI Commands (with GUI Comparison)

### 4.1 — List Files in a Directory

| Action | GUI | CLI (Windows) | CLI (Linux/Mac) |
|--------|-----|--------------|-----------------|
| Show all files | Open folder in Explorer | `dir` | `ls` |
| Show hidden files | View → Hidden Items | `dir /a` | `ls -a` |
| Show with details | Details view | `dir /q` | `ls -l` |

**CLI Examples:**

```bash
# Windows — List files
dir

# Windows — List files with details
dir /q

# Linux/Mac — List files
ls

# Linux/Mac — List with details (permissions, size, date)
ls -l

# Linux/Mac — List all including hidden files
ls -la
```

---

### 4.2 — Create a Directory (Folder)

| Action | GUI | CLI (Windows) | CLI (Linux/Mac) |
|--------|-----|--------------|-----------------|
| Create folder | Right-click → New Folder | `mkdir FolderName` | `mkdir FolderName` |
| Create nested folders | Create one by one | `mkdir a\b\c` | `mkdir -p a/b/c` |

**CLI Examples:**

```bash
# Create a folder called "employees"
mkdir employees

# Windows — Create nested folders
mkdir Projects\Hive\Data

# Linux — Create nested folders in one command
mkdir -p Projects/Hive/Data
```

---

### 4.3 — Navigate Between Directories

| Action | GUI | CLI (Windows) | CLI (Linux/Mac) |
|--------|-----|--------------|-----------------|
| Go into a folder | Double-click | `cd FolderName` | `cd FolderName` |
| Go back one level | Click back arrow | `cd ..` | `cd ..` |
| Go to root | Click drive (C:\) | `cd \` | `cd /` |
| Show current path | Look at address bar | `cd` | `pwd` |

**CLI Examples:**

```bash
# Go into the "Projects" folder
cd Projects

# Go back to the parent folder
cd ..

# Windows — Show current directory
cd

# Linux — Show current directory (Print Working Directory)
pwd

# Go directly to a specific path (Windows)
cd C:\Users\subramani.v\Documents

# Go directly to a specific path (Linux)
cd /home/user/Documents
```

---

### 4.4 — Create, Copy, Move, and Delete Files

| Action | GUI | CLI (Windows) | CLI (Linux/Mac) |
|--------|-----|--------------|-----------------|
| Create empty file | Right-click → New file | `type nul > file.txt` | `touch file.txt` |
| Copy file | Ctrl+C, Ctrl+V | `copy file.txt dest\` | `cp file.txt dest/` |
| Move file | Cut and Paste | `move file.txt dest\` | `mv file.txt dest/` |
| Delete file | Delete key / Recycle Bin | `del file.txt` | `rm file.txt` |
| Delete folder | Delete folder | `rmdir /s FolderName` | `rm -r FolderName` |

**CLI Examples:**

```bash
# Linux — Create an empty file
touch employees.csv

# Linux — Copy file to another folder
cp employees.csv /home/user/backup/

# Linux — Move file
mv employees.csv /tmp/data/

# Linux — Delete a file
rm employees.csv

# Linux — Delete an entire folder and its contents
rm -r Projects/OldData
```

---

### 4.5 — View File Content

| Action | GUI | CLI (Windows) | CLI (Linux/Mac) |
|--------|-----|--------------|-----------------|
| View file content | Open in Notepad/Editor | `type file.txt` | `cat file.txt` |
| View with scrolling | Scroll in editor | `more file.txt` | `less file.txt` |
| View first 10 lines | Manually scroll top | — | `head file.txt` |
| View last 10 lines | Manually scroll bottom | — | `tail file.txt` |

**CLI Examples:**

```bash
# Print content of a CSV file
cat employees.csv

# View large files page by page
less depart_data.csv

# Show only first 5 lines
head -5 depart_data.csv

# Show only last 5 lines
tail -5 depart_data.csv
```

---

## 5. Hive CLI vs Hive GUI (Hue)

Apache Hive can be accessed via **CLI (Hive Shell)** or **GUI (Apache Hue)**.

### 5.1 Hive CLI

**Launch Hive Shell:**
```bash
hive
```

**Basic Hive CLI Commands:**

```sql
-- Show all databases
show databases;

-- Create a new database
create database hive_db;

-- Switch to a database
use hive_db;

-- Show all tables in current database
show tables;

-- Describe a table (schema)
describe department_data;

-- Describe table with full details (location, format, etc.)
describe formatted department_data;

-- Run a Hive query
select * from department_data limit 10;

-- Enable column headers in output
set hive.cli.print.header = true;

-- Exit Hive shell
exit;
```

---

### 5.2 Hive GUI (Apache Hue)

**Apache Hue** is a web-based interface for running Hive queries without typing shell commands.

```
How to Access Hue (on GCP Dataproc / local cluster):
─────────────────────────────────────────────────────
1. Open browser → go to: http://<cluster-ip>:8888
2. Login with credentials (e.g., admin / admin)
3. Click on "Query Editor" → Select "Hive"
4. Type your HQL query in the editor
5. Click "Run" button (▶)
6. Results appear in a table below
```

**GUI vs CLI Comparison for Hive:**

| Task | CLI Command | GUI (Hue) Action |
|------|-------------|-----------------|
| Show databases | `show databases;` | Left panel → Databases list |
| Run query | Type in shell | Type in editor → Click Run |
| View table data | `select * from table;` | Click table name → Preview |
| Load data | `load data local inpath ...` | Upload file via UI |
| Download results | Export manually | Click Download button |

---

## 6. HDFS CLI Commands

HDFS (Hadoop Distributed File System) is managed via CLI commands.

```bash
# List files in HDFS root
hadoop fs -ls /

# List files in a specific HDFS path
hadoop fs -ls /tmp/input_data/

# Create a directory in HDFS
hadoop fs -mkdir /tmp/my_folder

# Upload a file from local to HDFS
hadoop fs -put /home/user/depart_data.csv /tmp/input_data/

# Download a file from HDFS to local
hadoop fs -get /tmp/input_data/depart_data.csv /home/user/

# View content of a file in HDFS
hadoop fs -cat /tmp/input_data/depart_data.csv

# Delete a file from HDFS
hadoop fs -rm /tmp/input_data/old_file.csv

# Delete a folder from HDFS (recursive)
hadoop fs -rm -r /tmp/old_folder/
```

---

## 7. Quick Reference Cheat Sheet

### Linux/Mac CLI Quick Reference

| Command | Description | Example |
|---------|-------------|---------|
| `pwd` | Show current directory | `pwd` |
| `ls` | List files | `ls -la` |
| `cd` | Change directory | `cd /tmp` |
| `mkdir` | Create directory | `mkdir data` |
| `touch` | Create empty file | `touch notes.txt` |
| `cat` | View file content | `cat data.csv` |
| `cp` | Copy file | `cp a.txt b.txt` |
| `mv` | Move/rename file | `mv old.txt new.txt` |
| `rm` | Delete file | `rm file.txt` |
| `rm -r` | Delete folder | `rm -r folder/` |
| `clear` | Clear terminal screen | `clear` |

### Windows CLI Quick Reference

| Command | Description | Example |
|---------|-------------|---------|
| `dir` | List files | `dir` |
| `cd` | Change / show directory | `cd Projects` |
| `mkdir` | Create folder | `mkdir Data` |
| `copy` | Copy file | `copy a.txt b.txt` |
| `move` | Move file | `move a.txt C:\temp` |
| `del` | Delete file | `del old.txt` |
| `rmdir /s` | Delete folder | `rmdir /s OldFolder` |
| `cls` | Clear screen | `cls` |
| `type` | View file content | `type notes.txt` |

---

## 8. Key Takeaways

> **GUI** → Easy to use, visual, great for beginners, but slower for repetitive tasks.

> **CLI** → Faster, scriptable, powerful for automation, essential for working with Hadoop/Hive/HDFS.

> In **Big Data Engineering**, CLI skills are critical because most cluster tools (HDFS, Hive, Spark) are operated via command line.

