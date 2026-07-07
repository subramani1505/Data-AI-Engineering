# Module 1: CMD (Command Prompt) — A Clear & Short Guide

---

## 1. What is CMD?

**CMD** (Command Prompt / `cmd.exe`) is **Microsoft Windows' built-in command-line shell**.

- It is the oldest and most basic shell on Windows.
- It interprets text commands and asks the Windows OS to execute them.
- Think of it as **the Windows version of Linux's Bash terminal**.

```
You (type a command)
        │
        ▼
  Command Prompt Window   ← The black window you see
        │
        ▼
    cmd.exe (CMD Shell)   ← Reads & interprets the command
        │
        ▼
  Windows Operating System ← Executes the task
        │
        ▼
   CPU / RAM / SSD         ← Hardware does the work
        │
        ▼
   Result displayed back on screen
```

---

## 2. How to Open CMD

| Method | Steps |
|--------|-------|
| **Run dialog** | `Win + R` → type `cmd` → Enter |
| **Start Menu** | Search "Command Prompt" → Click |
| **File Explorer** | Type `cmd` in the address bar → Enter |
| **Right-click (Admin)** | Right-click Start → "Command Prompt (Admin)" |
| **From a folder** | Shift + Right-click inside folder → "Open Command Window here" |

---

## 3. CMD Prompt Explained

```
C:\Users\subramani.v>
│                    │
│                    └── > = ready for input
└────────────────────── current directory (where you are)
```

> When you first open CMD, you are in your **user's home directory** by default.

---

## 4. Essential CMD Commands

### 4.1 — Navigation

| Command | What it Does | Example |
|---------|-------------|---------|
| `cd` | Show current directory | `cd` |
| `cd FolderName` | Go into a folder | `cd Projects` |
| `cd ..` | Go back one level | `cd ..` |
| `cd \` | Go to root (C:\) | `cd \` |
| `dir` | List all files & folders | `dir` |
| `dir /a` | List including hidden files | `dir /a` |
| `cls` | Clear the screen | `cls` |

**Example:**

```cmd
C:\Users\subramani.v> cd Documents
C:\Users\subramani.v\Documents> dir
 Volume in drive C is Windows
 Directory of C:\Users\subramani.v\Documents

07/07/2026  10:00    <DIR>  Subramani_PW
07/07/2026  09:00    <DIR>  Projects
```

---

### 4.2 — Create & Delete

| Command | What it Does | Example |
|---------|-------------|---------|
| `mkdir FolderName` | Create a new folder | `mkdir Hive_Data` |
| `mkdir a\b\c` | Create nested folders | `mkdir Projects\Hive\Data` |
| `del file.txt` | Delete a file | `del old.txt` |
| `rmdir FolderName` | Delete empty folder | `rmdir OldFolder` |
| `rmdir /s FolderName` | Delete folder + all contents | `rmdir /s OldData` |

**Example:**

```cmd
C:\Users\subramani.v> mkdir DataEngineering\Hive
C:\Users\subramani.v> cd DataEngineering\Hive
C:\Users\subramani.v\DataEngineering\Hive> dir
 (empty folder)
```

---

### 4.3 — Copy & Move Files

| Command | What it Does | Example |
|---------|-------------|---------|
| `copy src dest` | Copy a file | `copy data.csv backup\` |
| `xcopy src dest /E` | Copy folder with contents | `xcopy Projects\ Backup\ /E` |
| `move src dest` | Move or rename a file | `move data.csv C:\tmp\` |

**Example:**

```cmd
REM Copy employees.csv to backup folder
copy employees.csv C:\Backup\

REM Move and rename a file
move old_data.csv archive_data.csv
```

---

### 4.4 — View File Content

| Command | What it Does | Example |
|---------|-------------|---------|
| `type file.txt` | Print file content | `type employees.csv` |
| `more file.txt` | View large files with scrolling | `more large_file.txt` |
| `findstr "word" file` | Search for text in a file | `findstr "Sales" data.csv` |

**Example:**

```cmd
C:\Data> type employees.csv
10,Sales,Manager,55000
20,HR,Analyst,48000
30,Engineering,Lead,72000

C:\Data> findstr "Engineering" employees.csv
30,Engineering,Lead,72000
```

---

### 4.5 — System & Utility Commands

| Command | What it Does | Example |
|---------|-------------|---------|
| `echo text` | Print text to screen | `echo Hello World` |
| `echo %VARIABLE%` | Print an environment variable | `echo %USERNAME%` |
| `set` | List all environment variables | `set` |
| `date` | Show or set the date | `date` |
| `time` | Show or set the time | `time` |
| `hostname` | Show computer name | `hostname` |
| `ipconfig` | Show network/IP info | `ipconfig` |
| `ping address` | Test connectivity | `ping google.com` |
| `tasklist` | List running processes | `tasklist` |
| `taskkill /PID id` | Kill a process by ID | `taskkill /PID 1234` |
| `exit` | Close CMD window | `exit` |

**Example:**

```cmd
C:\> echo %USERNAME%
subramani.v

C:\> ipconfig
Windows IP Configuration
   IPv4 Address: 192.168.1.10
   Subnet Mask:  255.255.255.0

C:\> ping google.com
Pinging google.com [142.250.67.78]...
Reply from 142.250.67.78: bytes=32 time=15ms TTL=118
```

---

## 5. CMD vs PowerShell vs Linux Bash

| Feature | CMD | PowerShell | Linux Bash |
|---------|-----|------------|------------|
| OS | Windows | Windows | Linux / Mac |
| Scripting | Basic (`.bat`) | Advanced (`.ps1`) | Full (`.sh`) |
| Commands | Simple, limited | Powerful, object-based | Rich & flexible |
| Linux commands | ❌ Not supported | Partial support | ✅ Native |
| Use in Big Data | Rarely | Sometimes | ✅ Primary tool |
| Automation | Limited | Strong | Very strong |

> **For Big Data (Hive, HDFS, Spark)** — Linux Bash is used, not CMD.
> CMD is mainly useful for **Windows file management and basic scripting**.

---

## 6. CMD vs GUI — Side by Side

| Task | GUI (Windows Explorer) | CMD |
|------|----------------------|-----|
| Open a folder | Double-click | `cd FolderName` |
| Create a folder | Right-click → New Folder | `mkdir FolderName` |
| Copy a file | Ctrl+C → Ctrl+V | `copy file.txt dest\` |
| Delete a file | Delete key | `del file.txt` |
| List files | Open folder | `dir` |
| Find a file | Search bar | `dir /s filename` |
| Rename file | Right-click → Rename | `ren old.txt new.txt` |

---

## 7. Batch Scripting — Automate CMD Commands

A **batch file** (`.bat`) is a script that runs multiple CMD commands automatically.

**Example — `setup.bat`:**

```bat
@echo off
echo === Starting Setup ===

REM Create folder structure
mkdir DataEngineering\Hive\raw_data
echo Folders created

REM Copy data files
copy C:\Downloads\employees.csv DataEngineering\Hive\raw_data\
echo Files copied

echo === Setup Complete ===
pause
```

**Run it:**
```cmd
setup.bat

REM Output:
REM === Starting Setup ===
REM Folders created
REM Files copied
REM === Setup Complete ===
```

---

## 8. Quick Reference Cheat Sheet

| Command | Description | Example |
|---------|-------------|---------|
| `cd` | Show / change directory | `cd Projects` |
| `dir` | List files | `dir` |
| `mkdir` | Create folder | `mkdir Data` |
| `rmdir /s` | Delete folder | `rmdir /s OldData` |
| `del` | Delete file | `del old.txt` |
| `copy` | Copy file | `copy a.txt b.txt` |
| `move` | Move/rename file | `move a.txt C:\tmp` |
| `ren` | Rename file | `ren old.txt new.txt` |
| `type` | View file content | `type data.csv` |
| `findstr` | Search in file | `findstr "Sales" data.csv` |
| `echo` | Print text | `echo %USERNAME%` |
| `cls` | Clear screen | `cls` |
| `ipconfig` | Show network info | `ipconfig` |
| `ping` | Test connection | `ping google.com` |
| `tasklist` | Show processes | `tasklist` |
| `taskkill` | Kill process | `taskkill /PID 1234` |
| `exit` | Close CMD | `exit` |

---

## 9. Key Takeaways

> **CMD** = Windows' basic command-line shell — good for file management and simple automation.

> **CMD vs Shell**: CMD is a shell too — but it only works on Windows, and is less powerful than Bash or PowerShell.

> **For Big Data**: You will mostly use Linux Bash (not CMD), since Hadoop, Hive, and Spark run on Linux clusters.

> **Batch files (`.bat`)** = CMD's way of scripting and automating tasks.
