# Module 1: SSH (Secure Shell) — A Clear & Short Guide

---

## 1. What is SSH?

**SSH (Secure Shell)** is a **network protocol** that lets you securely connect to and control a **remote computer** over the internet.

- You type commands on **your local machine** → they execute on the **remote server**.
- All communication is **encrypted** — no one can intercept your commands or data.
- It is the standard way to connect to cloud servers, Hadoop clusters, and Linux VMs.

```
Your Local Machine                     Remote Server
(Windows / Mac / Linux)                (GCP / AWS / Azure / Hadoop Cluster)

┌───────────────────────┐              ┌──────────────────────────────┐
│  Terminal / SSH Client│──── SSH ────►│  SSH Server (port 22)        │
│  (you type commands)  │  (encrypted) │  Bash Shell opens here       │
└───────────────────────┘              └──────────────────────────────┘
```

> **In simple words**: SSH lets you "sit in front of" a remote server from anywhere in the world, using just a terminal.

---

## 2. SSH vs Other Connection Methods

| Method | Security | Speed | Use Case |
|--------|----------|-------|----------|
| **SSH** | ✅ Fully encrypted | ✅ Lightweight | Linux servers, cloud clusters |
| **RDP** (Remote Desktop) | Moderate | Heavy (sends full GUI) | Windows remote desktop |
| **VNC** | Lower | Heavy (sends full GUI) | Visual remote access |
| **Telnet** | ❌ No encryption | Lightweight | ❌ Outdated, insecure |

> **SSH is the standard for Big Data** — it's fast, secure, and works on all Linux servers.

---

## 3. How SSH Works — Step by Step

```
Step 1: You run:  ssh username@server_ip
Step 2: Your SSH client contacts the server on port 22
Step 3: Server sends its public key to verify its identity
Step 4: Authentication happens (password OR SSH key)
Step 5: If successful → a Bash shell opens on the remote server
Step 6: Every command you type now runs ON the remote server
Step 7: Results are sent back encrypted to your terminal
Step 8: You type "exit" → connection closes
```

---

## 4. Two Ways to Authenticate with SSH

### Method 1: Password Authentication (Simple but Less Secure)

```bash
ssh username@server_ip
# It will ask: "username@server_ip's password:"
# Type your password → press Enter
```

### Method 2: SSH Key Authentication (Recommended — More Secure)

SSH keys work in pairs:
- **Private Key** → stays on YOUR machine (never share this)
- **Public Key** → placed on the REMOTE server

```
Your Machine          →        Remote Server
┌─────────────┐                ┌──────────────────────┐
│ Private Key │                │ Public Key stored in  │
│ (~/.ssh/id_rsa)│             │ ~/.ssh/authorized_keys│
└─────────────┘                └──────────────────────┘
         │                                │
         └─── They match? ✅ Login granted ──┘
```

---

## 5. Generating SSH Keys

```bash
# Generate a new SSH key pair
ssh-keygen -t rsa -b 2048

# You'll be asked:
# Enter file to save the key: (~/.ssh/id_rsa)   → press Enter
# Enter passphrase:                               → press Enter (or add one for extra security)

# Two files will be created:
# ~/.ssh/id_rsa       ← Private Key (keep this safe, NEVER share)
# ~/.ssh/id_rsa.pub   ← Public Key  (this goes on the server)

# View your public key
cat ~/.ssh/id_rsa.pub
# Output: ssh-rsa AAAAB3NzaC1yc2EAAAA... subramani@ubuntu
```

---

## 6. Basic SSH Commands

### 6.1 — Connect to a Remote Server

```bash
# Basic connection (password login)
ssh username@ip_address

# Example
ssh subramani@34.123.45.67

# Connect using an SSH key file
ssh -i ~/.ssh/id_rsa username@ip_address

# Example (GCP Dataproc cluster)
ssh -i ~/.ssh/gcp_key subramani@34.123.45.67

# Connect on a custom port (default is 22)
ssh -p 2222 username@ip_address
```

---

### 6.2 — Run a Single Command Without Opening a Full Session

```bash
# Run one command on the remote server and return immediately
ssh username@ip_address "command"

# Examples:
ssh subramani@34.123.45.67 "ls /tmp/input_data/"
ssh subramani@34.123.45.67 "hadoop fs -ls /"
ssh subramani@34.123.45.67 "hive -e 'show databases;'"
```

---

### 6.3 — Transfer Files with SCP (Secure Copy)

**SCP** uses SSH to securely copy files between local and remote machines.

```bash
# Syntax
scp [source] [destination]

# Upload: local → remote
scp employees.csv subramani@34.123.45.67:/tmp/input_data/

# Upload with SSH key
scp -i ~/.ssh/gcp_key employees.csv subramani@34.123.45.67:/tmp/input_data/

# Download: remote → local
scp subramani@34.123.45.67:/tmp/output/result.csv ~/Downloads/

# Upload an entire folder (recursive)
scp -r Projects/ subramani@34.123.45.67:/home/subramani/
```

---

### 6.4 — SSH Config File (Shortcut for Frequent Connections)

Instead of typing long commands every time, set up an SSH config file.

**Create / edit `~/.ssh/config`:**

```
Host gcp-cluster
    HostName 34.123.45.67
    User subramani
    IdentityFile ~/.ssh/gcp_key

Host aws-server
    HostName 54.200.12.34
    User ec2-user
    IdentityFile ~/.ssh/aws_key.pem
```

**Now connect with just:**

```bash
# Instead of: ssh -i ~/.ssh/gcp_key subramani@34.123.45.67
ssh gcp-cluster

# Instead of: ssh -i ~/.ssh/aws_key.pem ec2-user@54.200.12.34
ssh aws-server
```

---

## 7. SSH in GUI — Alternatives

| Tool | OS | Description |
|------|----|-------------|
| **PuTTY** | Windows | Popular GUI SSH client |
| **MobaXterm** | Windows | Advanced SSH client with file browser |
| **VS Code Remote SSH** | All | SSH into a server directly from VS Code |
| **GCP Console** | Browser | Click "SSH" button on VM page — opens browser terminal |
| **AWS CloudShell** | Browser | Browser-based SSH terminal |

### GUI vs CLI SSH:

| Task | GUI (PuTTY / GCP Console) | CLI (Terminal) |
|------|--------------------------|---------------|
| Connect to server | Fill in IP → Click Open | `ssh user@ip` |
| Transfer file | Drag and drop (MobaXterm) | `scp file user@ip:/path` |
| Manage SSH keys | Import key file via UI | `ssh-keygen`, `~/.ssh/config` |
| Automation | ❌ Not possible | ✅ Script with shell |

---

## 8. SSH for Big Data — Real Workflow

**Typical Data Engineer Workflow using SSH:**

```bash
# Step 1: Generate SSH key (one time only)
ssh-keygen -t rsa -b 2048

# Step 2: Connect to GCP Dataproc Hadoop cluster
ssh -i ~/.ssh/gcp_key subramani@34.123.45.67

# Step 3: You are now ON the cluster — upload data to HDFS
hadoop fs -put ~/employees.csv /tmp/input_data/

# Step 4: Run Hive queries on the cluster
hive -e "SELECT dept_name, AVG(salary) FROM department_data GROUP BY dept_name;"

# Step 5: Download results back to your local machine
exit   # first exit the SSH session

scp -i ~/.ssh/gcp_key subramani@34.123.45.67:/tmp/output/result.csv ~/Desktop/
```

---

## 9. Common SSH Errors & Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `Connection refused` | Server not running or wrong port | Check server is on, use `-p` for custom port |
| `Permission denied (publickey)` | Wrong key file or key not on server | Use `-i correct_key.pem` |
| `Host key verification failed` | Server's fingerprint changed | Remove old entry: `ssh-keygen -R ip_address` |
| `Timeout` | Firewall blocking port 22 | Open port 22 in server's firewall rules |
| `WARNING: UNPROTECTED PRIVATE KEY FILE!` | Key file has wrong permissions | Fix with: `chmod 400 ~/.ssh/id_rsa` |

**Fix key file permission warning:**

```bash
chmod 400 ~/.ssh/id_rsa
# This sets key to read-only for owner — SSH requires this
```

---

## 10. Quick Reference Cheat Sheet

| Command | Description | Example |
|---------|-------------|---------|
| `ssh user@ip` | Connect to remote server | `ssh subramani@34.123.45.67` |
| `ssh -i key user@ip` | Connect with SSH key | `ssh -i ~/.ssh/gcp_key user@ip` |
| `ssh -p port user@ip` | Connect on custom port | `ssh -p 2222 user@ip` |
| `ssh user@ip "cmd"` | Run one command remotely | `ssh user@ip "ls /tmp"` |
| `exit` | Close SSH session | `exit` |
| `scp file user@ip:/path` | Upload file to server | `scp data.csv user@ip:/tmp/` |
| `scp user@ip:/path file` | Download file from server | `scp user@ip:/tmp/out.csv ~/` |
| `scp -r folder user@ip:/path` | Upload entire folder | `scp -r Projects/ user@ip:~/` |
| `ssh-keygen -t rsa` | Generate SSH key pair | `ssh-keygen -t rsa -b 2048` |
| `cat ~/.ssh/id_rsa.pub` | View public key | (copy this to server) |
| `chmod 400 key.pem` | Fix key permissions | `chmod 400 ~/.ssh/id_rsa` |

---

## 11. Key Takeaways

> **SSH** = Secure, encrypted way to control a remote server from your terminal.

> **Two auth methods**: Password (simple) vs SSH Keys (recommended — more secure).

> **SCP** = SSH-based file transfer — upload/download files between local & remote.

> **For Big Data**: SSH is how you connect to GCP, AWS, Hadoop, and Spark clusters — a daily tool for Data Engineers.

> **SSH Config file** (`~/.ssh/config`) saves shortcuts so you don't type long commands every time.
