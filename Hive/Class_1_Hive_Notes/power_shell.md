# Module 1: PowerShell — A Clear & Short Guide

---

## 1. What is PowerShell?

**PowerShell** is Microsoft's **modern command-line shell and scripting language**.

- It was built to replace CMD for complex administration and automation tasks.
- It works with **objects** (not just plain text like CMD).
- Think of it as the **next generation of CMD** — more powerful, more flexible.

```
You (type a command)
        │
        ▼
  Windows Terminal
        │
  ┌─────┴──────┬──────────────┐
  ▼            ▼              ▼
 CMD      PowerShell     Bash (WSL)
  │            │              │
  └────────────┴──────────────┘
               │
               ▼
     Windows / Linux OS
               │
               ▼
        CPU • RAM • Storage
               │
               ▼
       Result shown on screen
```

---

## 2. Why Was PowerShell Created?

CMD handled simple tasks well:

```cmd
dir    copy    mkdir    del
```

But IT administrators needed to do **much more complex** things:

| Admin Need | CMD | PowerShell |
|------------|-----|-----------|
| Manage 1000+ users | ❌ Very hard | ✅ Easy |
| Configure servers remotely | ❌ Limited | ✅ Built-in |
| Manage Active Directory | ❌ Not possible | ✅ Full support |
| Control Azure / Cloud | ❌ No | ✅ Yes |
| Automate daily tasks | ❌ Basic only | ✅ Advanced scripts |

> **CMD wasn't powerful enough → Microsoft introduced PowerShell.**

---

## 3. How to Open PowerShell

| Method | Steps |
|--------|-------|
| **Run dialog** | `Win + R` → type `powershell` → Enter |
| **Start Menu** | Search "PowerShell" → Click |
| **Right-click Start** | `Win + X` → "Windows PowerShell" |
| **Admin mode** | Search PowerShell → Right-click → "Run as Administrator" |
| **Inside any folder** | Shift + Right-click → "Open PowerShell window here" |

---

## 4. PowerShell Prompt Explained

```
PS C:\Users\subramani.v>
│                        │
│                        └── > = ready for input
└────────────────────────── PS = PowerShell (distinguishes from CMD)
```

---

## 5. The Biggest Difference: Text vs Objects

### CMD — Returns Plain Text:

```cmd
dir
```

```
Output:
Resume.pdf
Photo.png
Data.xlsx
```

Just raw text — you can't easily filter or sort it.

---

### PowerShell — Returns Objects:

```powershell
Get-ChildItem
```

```
Output (each item is an object with properties):
Mode    LastWriteTime   Length  Name
----    -------------   ------  ----
-a----  07/07/2026      1024    Resume.pdf
-a----  07/07/2026      2048    Photo.png
-a----  07/07/2026      512     Data.xlsx
```

Each file is an **object** with properties like `Name`, `Length`, `LastWriteTime`.

> **Real-Life Analogy:**
>
> CMD gives you: `Rahul, Anitha, Ravi` — just names.
>
> PowerShell gives you a **Student Object** with: `Name`, `Roll No`, `Class`, `Age`, `Phone`
>
> Now you can search by Name, filter by Age, sort by Class — much more powerful!

---

## 6. Essential PowerShell Commands

### 6.1 Navigation & Listing

| Task | PowerShell | CMD Equivalent |
|------|-----------|----------------|
| Show current directory | `pwd` or `Get-Location` | `cd` |
| List files | `ls` or `Get-ChildItem` | `dir` |
| List with hidden files | `ls -Force` | `dir /a` |
| Change directory | `cd FolderName` | `cd FolderName` |
| Go back | `cd ..` | `cd ..` |
| Clear screen | `cls` or `Clear-Host` | `cls` |

**Example:**

```powershell
PS C:\> cd Documents
PS C:\Users\subramani.v\Documents> Get-ChildItem

    Directory: C:\Users\subramani.v\Documents

Mode    LastWriteTime   Length  Name
----    -------------   ------  ----
d----   07/07/2026             Subramani_PW
d----   07/07/2026             Projects
```

---

### 6.2 File & Folder Management

| Task | PowerShell | CMD Equivalent |
|------|-----------|----------------|
| Create folder | `mkdir FolderName` or `New-Item -Type Directory` | `mkdir` |
| Create file | `New-Item file.txt` | `type nul > file.txt` |
| Copy file | `Copy-Item src dest` | `copy` |
| Move/Rename | `Move-Item old new` | `move` |
| Delete file | `Remove-Item file.txt` | `del` |
| Delete folder | `Remove-Item -Recurse folder` | `rmdir /s` |

**Example:**

```powershell
# Create a new folder
mkdir Hive_Project

# Create a new file
New-Item -Name "employees.csv" -Type File

# Copy file to backup
Copy-Item employees.csv -Destination C:\Backup\

# Delete a folder and all its contents
Remove-Item -Recurse -Force OldData\
```

---

### 6.3 View File Content

| Task | PowerShell | CMD Equivalent |
|------|-----------|----------------|
| Print file | `Get-Content file.txt` | `type file.txt` |
| First N lines | `Get-Content file.txt -Head 5` | — |
| Last N lines | `Get-Content file.txt -Tail 5` | — |
| Search in file | `Select-String "word" file.txt` | `findstr` |

**Example:**

```powershell
# View CSV file
Get-Content employees.csv

# View first 3 lines
Get-Content employees.csv -Head 3

# Search for "Engineering"
Select-String "Engineering" employees.csv
# Output: employees.csv:3:30,Engineering,Lead,72000
```

---

### 6.4 Process Management

| Task | PowerShell | CMD Equivalent |
|------|-----------|----------------|
| List processes | `Get-Process` | `tasklist` |
| Find specific process | `Get-Process chrome` | `tasklist \| findstr chrome` |
| Kill a process | `Stop-Process -Name chrome` | `taskkill /IM chrome.exe` |
| Kill by ID | `Stop-Process -Id 1234` | `taskkill /PID 1234` |

**Example:**

```powershell
# List all running processes
Get-Process

# Find only Chrome processes (object-based filtering — much easier than CMD)
Get-Process chrome

# Output:
# Handles NPM(K) PM(K) WS(K) CPU(s)  Id ProcessName
# ------- ------ ----- ----- ------  -- -----------
# 350       45  98564  ...   10.5  4321 chrome

# Kill Chrome
Stop-Process -Name chrome
```

---

### 6.5 System & Network

| Task | PowerShell | CMD Equivalent |
|------|-----------|----------------|
| Show IP info | `Get-NetIPAddress` | `ipconfig` |
| Test connection | `Test-Connection google.com` | `ping google.com` |
| Show env variable | `$env:USERNAME` | `echo %USERNAME%` |
| Show all env vars | `Get-ChildItem Env:` | `set` |
| Get date/time | `Get-Date` | `date` / `time` |

**Example:**

```powershell
# Test network connectivity
Test-Connection google.com -Count 3

# Output:
# Source  Destination  Bytes  Time(ms)
# ------  -----------  -----  --------
# PC01    google.com   32     15
# PC01    google.com   32     13

# Show current username
$env:USERNAME
# Output: subramani.v

# Get current date and time
Get-Date
# Output: Monday, July 07, 2026 4:55:00 PM
```

---

## 7. PowerShell Scripting — Automate Tasks

PowerShell scripts have a `.ps1` extension.

**Example — `setup.ps1`:**

```powershell
# setup.ps1 — Automates folder and file setup

Write-Host "=== Starting Setup ===" -ForegroundColor Cyan

# Create folder structure
New-Item -ItemType Directory -Force -Path "DataEngineering\Hive\raw_data"
Write-Host "Folders created" -ForegroundColor Green

# Copy files
Copy-Item "C:\Downloads\employees.csv" -Destination "DataEngineering\Hive\raw_data\"
Write-Host "Files copied" -ForegroundColor Green

Write-Host "=== Setup Complete ===" -ForegroundColor Cyan
```

**Run it:**

```powershell
# Run the script
.\setup.ps1

# Output (in color):
# === Starting Setup ===
# Folders created
# Files copied
# === Setup Complete ===
```

---

## 8. CMD vs PowerShell — Full Comparison

| Feature | CMD | PowerShell |
|---------|-----|-----------|
| Released | 1987 | 2006 |
| Output type | Plain text | **Objects** |
| Scripting | `.bat` files (basic) | `.ps1` files (advanced) |
| Linux commands | ❌ No | Partial (`ls`, `pwd`, `cat`) |
| Cloud/Azure support | ❌ No | ✅ Yes |
| Pipeline filtering | Hard (text only) | Easy (filter by property) |
| Error handling | Limited | Full `try/catch` support |
| Use in Big Data | ❌ Rarely | ✅ Sometimes (Windows clusters) |
| Recommended for | Basic tasks | Administration & automation |

---

## 9. Quick Reference Cheat Sheet

| Command | Description | Example |
|---------|-------------|---------|
| `pwd` | Show current path | `pwd` |
| `ls` / `Get-ChildItem` | List files | `ls -Force` |
| `cd` | Change directory | `cd Projects` |
| `mkdir` | Create folder | `mkdir Data` |
| `New-Item` | Create file/folder | `New-Item file.txt` |
| `Copy-Item` | Copy file | `Copy-Item a.csv C:\Backup\` |
| `Move-Item` | Move/rename | `Move-Item old.txt new.txt` |
| `Remove-Item` | Delete file/folder | `Remove-Item -Recurse folder` |
| `Get-Content` | View file | `Get-Content data.csv` |
| `Select-String` | Search in file | `Select-String "Sales" data.csv` |
| `Get-Process` | List processes | `Get-Process chrome` |
| `Stop-Process` | Kill process | `Stop-Process -Name chrome` |
| `Test-Connection` | Ping / network test | `Test-Connection google.com` |
| `Get-Date` | Current date/time | `Get-Date` |
| `$env:USERNAME` | Environment variable | `$env:USERNAME` |
| `cls` | Clear screen | `cls` |

---

## 10. Key Takeaways

> **PowerShell** = Modern Windows shell that works with **objects**, not just text.

> **CMD vs PowerShell**: CMD is simpler; PowerShell is more powerful and supports scripting, cloud, and automation.

> **Objects matter**: PowerShell lets you filter, sort, and work with structured data — CMD cannot.

> **For Big Data**: Linux Bash is the primary tool, but PowerShell is useful on Windows machines for file management, SSH connections, and Azure cloud operations.