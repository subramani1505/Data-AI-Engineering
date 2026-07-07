# Module 1: Azure Cloud Shell — A Clear & Short Guide

---

## 1. What is Azure Cloud Shell?

**Azure Cloud Shell** is a **free, browser-based terminal** provided by Microsoft Azure.

- It runs directly inside your **web browser** — no installation needed.
- You can choose between **Bash** or **PowerShell** as your shell.
- Pre-installed with tools like `az` (Azure CLI), `kubectl`, `terraform`, `git`, `python`, `dotnet`, and more.
- It is the fastest way to manage Azure resources without setting up anything locally.

```
Your Browser (Chrome / Firefox / Edge)
        │
        │   Opens Azure Portal
        ▼
┌──────────────────────────────────┐
│        Azure Portal              │
│    portal.azure.com              │
│                                  │
│   [ >_ Cloud Shell ] button  🖥️  │  ← Click this button (top bar)
└────────────────┬─────────────────┘
                 │
                 ▼
┌──────────────────────────────────┐
│      Azure Cloud Shell           │
│  Choose: Bash  OR  PowerShell    │
│                                  │
│  subramani@Azure:~$  _           │  ← You type Bash commands here
│  PS /home/subramani>  _          │  ← OR PowerShell commands here
└──────────────────────────────────┘
```

> **In simple words**: A full Linux (Bash) or Windows (PowerShell) terminal inside your browser — connected directly to your Azure account.

---

## 2. Key Features of Azure Cloud Shell

| Feature | Details |
|---------|---------|
| **Shell Options** | Bash (Linux) **or** PowerShell (Windows) — you choose |
| **OS** | Linux container (for Bash) |
| **Storage** | 5 GB persistent storage via Azure File Share |
| **Free** | ✅ Free to use (Azure Storage has a small cost ~$0.10/month) |
| **Pre-installed Tools** | `az`, `kubectl`, `terraform`, `git`, `python3`, `node`, `dotnet`, `ansible` |
| **Access** | Browser only — no installation needed |
| **Timeout** | Disconnects after ~20 min of inactivity |
| **Editor** | Built-in Monaco editor (same engine as VS Code) |

---

## 3. How to Open Azure Cloud Shell

### Method 1 — From Azure Portal:

```
1. Go to: https://portal.azure.com
2. Log in with your Microsoft / Azure account
3. Click the ">_" (Cloud Shell) icon in the top navigation bar
4. First time: It asks you to create a storage account (for 5 GB persistence)
5. Choose "Bash" or "PowerShell"
6. Terminal panel opens at the bottom of the page
```

### Method 2 — Direct URL:

```
Go to: https://shell.azure.com
→ Opens Cloud Shell in a full browser tab
```

### Method 3 — From VS Code:

```
Install the "Azure Account" extension in VS Code
→ Sign in to Azure
→ Open Command Palette → "Azure: Open Bash in Cloud Shell"
```

---

## 4. Cloud Shell Prompt Explained

### Bash Mode:

```bash
subramani@Azure:~$
│           │    │ │
│           │    │ └── $ = normal user
│           │    └──── ~ = home directory
│           └────────── "Azure" = machine identifier
└────────────────────── your Azure username (shortened)
```

### PowerShell Mode:

```powershell
PS /home/subramani>
│   │              │
│   │              └── > = ready for input
│   └──────────────── current directory
└──────────────────── PS = PowerShell indicator
```

---

## 5. Azure CLI — The Core Tool (`az`)

**`az`** is the main command-line tool for managing all Azure resources from the shell.

### 5.1 — Account & Subscription

```bash
# Check which Azure account you're logged into
az account show

# List all your subscriptions
az account list --output table

# Switch to a different subscription
az account set --subscription "My Subscription Name"

# Show current subscription
az account get-access-token --output table
```

---

### 5.2 — Resource Groups

```bash
# List all resource groups
az group list --output table

# Create a new resource group
az group create --name my-resource-group --location eastus

# Delete a resource group (and all its resources)
az group delete --name my-resource-group --yes
```

---

### 5.3 — Virtual Machines (VMs)

```bash
# List all VMs
az vm list --output table

# Start a VM
az vm start --resource-group my-rg --name my-vm

# Stop a VM
az vm stop --resource-group my-rg --name my-vm

# SSH into a Linux VM from Cloud Shell
ssh subramani@<vm-public-ip>

# Get the public IP of a VM
az vm show -d --resource-group my-rg --name my-vm --query publicIps -o tsv
```

---

### 5.4 — Azure Blob Storage (`az storage`)

Azure Blob Storage is Azure's cloud file storage — similar to GCP's GCS.

```bash
# List all storage accounts
az storage account list --output table

# List containers (like folders) in a storage account
az storage container list --account-name mystorageaccount

# Upload a file to Azure Blob Storage
az storage blob upload \
    --account-name mystorageaccount \
    --container-name mycontainer \
    --name employees.csv \
    --file employees.csv

# Download a file from Azure Blob Storage
az storage blob download \
    --account-name mystorageaccount \
    --container-name mycontainer \
    --name employees.csv \
    --file ~/downloaded_employees.csv

# List files in a container
az storage blob list \
    --account-name mystorageaccount \
    --container-name mycontainer \
    --output table

# Delete a file from Blob Storage
az storage blob delete \
    --account-name mystorageaccount \
    --container-name mycontainer \
    --name old_file.csv
```

---

### 5.5 — Azure HDInsight (Hadoop/Hive on Azure)

Azure HDInsight is Azure's managed Hadoop/Hive service — similar to GCP Dataproc.

```bash
# List all HDInsight clusters
az hdinsight list --output table

# SSH into the HDInsight cluster head node
ssh sshuser@my-cluster-ssh.azurehdinsight.net

# Once inside the cluster — run Hive
hive

# Run HDFS commands on the cluster
hadoop fs -ls /
hadoop fs -put ~/employees.csv /tmp/input_data/

# Submit a Hive job from Cloud Shell (without SSH)
az hdinsight script-action execute \
    --resource-group my-rg \
    --cluster-name my-cluster \
    --name "run-hive" \
    --script-uri "https://storage/scripts/hive_query.sh"
```

---

### 5.6 — Azure Kubernetes Service (AKS)

```bash
# Get credentials for your Kubernetes cluster
az aks get-credentials --resource-group my-rg --name my-aks

# List all pods
kubectl get pods

# List all services
kubectl get services
```

---

## 6. PowerShell Mode — Azure Commands

If you choose PowerShell in Cloud Shell, you can use the **Az PowerShell module**:

```powershell
# List all resource groups
Get-AzResourceGroup

# List all VMs
Get-AzVM

# Start a VM
Start-AzVM -ResourceGroupName "my-rg" -Name "my-vm"

# Stop a VM
Stop-AzVM -ResourceGroupName "my-rg" -Name "my-vm" -Force

# List storage accounts
Get-AzStorageAccount

# Get subscription info
Get-AzSubscription
```

---

## 7. Cloud Shell Editor (GUI)

Azure Cloud Shell includes a built-in **Monaco editor** (same engine as VS Code).

```
How to open:
1. In Cloud Shell terminal, type: code filename.py
   → Editor opens in the same browser tab

   OR click the "{}" editor icon at the top of Cloud Shell

Features:
- File browser panel on the left
- Syntax highlighting for Python, Bash, JSON, YAML, etc.
- Edit and save files without leaving the browser
- Integrated with Azure File Share storage
```

---

## 8. Azure Cloud Shell vs GCP Cloud Shell vs Local Terminal

| Feature | Azure Cloud Shell | GCP Cloud Shell | Local Terminal |
|---------|------------------|-----------------|----------------|
| Provider | Microsoft Azure | Google Cloud | Your machine |
| Browser-based | ✅ Yes | ✅ Yes | ❌ No |
| Shell options | Bash **or** PowerShell | Bash only | Any |
| Main CLI tool | `az` | `gcloud` | — |
| Storage | 5 GB (Azure File Share) | 5 GB | Local disk |
| Free | ✅ (tiny storage cost) | ✅ Free | ✅ Free |
| Pre-installed tools | `az`, `kubectl`, `terraform` | `gcloud`, `gsutil`, `bq` | Manual install |
| Best for | Azure resource management | GCP resource management | General use |

---

## 9. Real-World Workflow Example

**Data Engineer Workflow using Azure Cloud Shell:**

```bash
# Step 1: Open Cloud Shell from portal.azure.com → Click ">_" icon

# Step 2: Set active subscription
az account set --subscription "My Azure Subscription"

# Step 3: Create a storage container for data
az storage container create \
    --name hive-raw-data \
    --account-name mystorageaccount

# Step 4: Upload data to Azure Blob Storage
az storage blob upload \
    --account-name mystorageaccount \
    --container-name hive-raw-data \
    --name employees.csv \
    --file employees.csv

# Step 5: SSH into HDInsight cluster
ssh sshuser@my-cluster-ssh.azurehdinsight.net

# Step 6: Run Hive on the cluster
hive -e "SELECT dept_name, AVG(salary) FROM department_data GROUP BY dept_name;"

# Step 7: Exit cluster, download results
exit

az storage blob download \
    --account-name mystorageaccount \
    --container-name hive-raw-data \
    --name result.csv \
    --file ~/result.csv

# Step 8: View result
cat result.csv
```

---

## 10. Useful Cloud Shell Tips

| Tip | How |
|-----|-----|
| **Switch between Bash and PowerShell** | Click shell name in top bar → Select the other |
| **Open in full browser tab** | Click "Open in fullscreen" icon |
| **Upload a file** | Click upload icon in toolbar (or drag & drop) |
| **Download a file** | `download filename` (Cloud Shell command) |
| **Install extra tools** | `sudo apt-get install tool-name` (Bash) |
| **Persistent files** | Only files in `~/clouddrive` and `~` persist between sessions |
| **Run Python scripts** | `python3 script.py` |
| **Keep session alive** | Cloud Shell disconnects after 20 min idle |

---

## 11. Quick Reference Cheat Sheet

| Command | Description | Example |
|---------|-------------|---------|
| `az account show` | Show current account/subscription | — |
| `az account list` | List all subscriptions | `--output table` |
| `az account set` | Switch subscription | `--subscription "name"` |
| `az group list` | List resource groups | `--output table` |
| `az group create` | Create resource group | `--name rg --location eastus` |
| `az vm list` | List VMs | `--output table` |
| `az vm start` | Start a VM | `--resource-group rg --name vm` |
| `az vm stop` | Stop a VM | `--resource-group rg --name vm` |
| `az storage blob upload` | Upload to Blob Storage | `--file data.csv` |
| `az storage blob download` | Download from Blob | `--name file.csv` |
| `az storage blob list` | List blobs in container | `--output table` |
| `az hdinsight list` | List HDInsight clusters | `--output table` |
| `kubectl get pods` | List Kubernetes pods | — |
| `code filename` | Open file in editor | `code script.py` |
| `download filename` | Download file to local | `download result.csv` |

---

## 12. Key Takeaways

> **Azure Cloud Shell** = Free browser-based terminal for managing all Azure resources.

> **Two shell options**: Bash (Linux) for scripting & automation, PowerShell for Windows-style administration.

> **`az`** = The main CLI tool to control everything in Azure (VMs, storage, Kubernetes, HDInsight).

> **Azure Blob Storage** = Azure's file storage system — use `az storage blob` commands to manage files.

> **HDInsight** = Azure's managed Hadoop/Hive service — SSH into it from Cloud Shell, then run HDFS and Hive.

> **For Data Engineers**: Cloud Shell is your control center for Azure — manage clusters, upload data, run queries, all from the browser.
