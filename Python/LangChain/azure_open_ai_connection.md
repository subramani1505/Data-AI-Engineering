# Azure OpenAI — Connection Guide & Reference Notes

> 📌 **Purpose of this file:**  
> This document explains everything you need to connect to Azure OpenAI models —  
> what each configuration parameter is, why it's needed, and how to use it correctly.  
> Ideal for beginners and anyone setting up the connection for the first time.

---

## 🔷 What is Azure OpenAI?

**Azure OpenAI Service** is Microsoft Azure's managed cloud offering that gives you access to  
powerful AI language models (like GPT-4, GPT-3.5, Llama, etc.) through a **secure REST API**.

Unlike using OpenAI directly (api.openai.com), Azure OpenAI:
- Runs **inside your Azure subscription** (private, enterprise-grade)
- Has its own **endpoint URL** (not the public OpenAI URL)
- Requires **Azure credentials** (not OpenAI credentials)
- Allows you to **deploy specific models** under a custom deployment name

---

## 🔑 Required Connection Parameters

To connect to any Azure OpenAI model, you need **four key things**:

| # | Parameter | Env Variable | What It Is |
|---|-----------|-------------|------------|
| 1 | **Endpoint** | `AZURE_OPENAI_ENDPOINT` | The base URL of your Azure OpenAI resource |
| 2 | **API Key** | `AZURE_OPENAI_API_KEY` | Secret key to authenticate your requests |
| 3 | **Deployment Name** | `AZURE_OPENAI_DEPLOYMENT_NAME` | The name you gave when deploying a model |
| 4 | **Model Name** | `AZURE_OPENAI_MODEL_NAME` | The actual AI model that was deployed |

---

## 📌 1. Endpoint

### What is it?
The **Endpoint** is the unique base URL of your Azure OpenAI resource.  
Every Azure OpenAI resource has its own URL — it is **not** `https://api.openai.com`.

### Why is it needed?
Azure routes your API calls to your **private, isolated** OpenAI resource  
using this endpoint. Without it, Azure doesn't know which resource to target.

### Format:
```
https://<resource-name>.openai.azure.com/
```
Or for newer Azure AI Foundry resources:
```
https://<resource-name>.services.ai.azure.com/openai/v1/
```

### Example:
```
AZURE_OPENAI_ENDPOINT = https://chatb-mdy1u0cd-eastus.services.ai.azure.com/openai/v1/
```

### Where to find it?
- Go to **Azure Portal** → Your OpenAI Resource → **Keys and Endpoint** section
- Or in **Azure AI Foundry** → Your Project → **Overview** tab

---

## 📌 2. API Key

### What is it?
The **API Key** is a long secret string that acts as your **password** to authenticate  
API calls to Azure OpenAI. It proves you have permission to use the resource.

### Why is it needed?
Azure verifies every incoming API request using this key.  
Without a valid key, all requests will be rejected with a `401 Unauthorized` error.

### Format:
A long alphanumeric string, typically **32–80 characters**.

### Example:
```
AZURE_OPENAI_API_KEY = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  # <-- Replace with your actual key
```

### Where to find it?
- Go to **Azure Portal** → Your OpenAI Resource → **Keys and Endpoint**
- You'll see **Key 1** and **Key 2** (you can use either one)

> ⚠️ **SECURITY WARNING:**  
> - **Never** hardcode the API key directly in your Python scripts.  
> - **Never** commit API keys to Git / GitHub.  
> - Always store them in a **`.env` file** and add `.env` to your `.gitignore`.

---

## 📌 3. Deployment Name

### What is it?
When you deploy a model in Azure OpenAI, you give it a **custom name** — this is  
the **Deployment Name**. It's the name you choose when setting up the model in Azure.

### Why is it needed?
You can deploy **multiple models** in the same Azure resource  
(e.g., GPT-4, GPT-3.5, Llama-3 all at once). The deployment name tells Azure  
**which specific deployment** to send your request to.

### Key point:
> The deployment name is **not necessarily the same as the model name**.  
> You could name a GPT-4 deployment `"my-gpt4-prod"` or keep it as `"gpt-4"`.  
> It's your choice when you create the deployment.

### Example:
```
AZURE_OPENAI_DEPLOYMENT_NAME = Llama-3.3-70B-Instruct
GPT_MODEL_DEPLOYMENT_NAME    = gpt-4.1-mini
```

### Where to find it?
- Go to **Azure AI Foundry** (ai.azure.com) → **Deployments** section  
- Or **Azure Portal** → Your OpenAI resource → **Model Deployments**

---

## 📌 4. Model Name

### What is it?
The **Model Name** is the actual underlying AI model that was deployed.  
This is the official model identifier from Azure/OpenAI (e.g., `gpt-4`, `gpt-35-turbo`, `Llama-3.3-70B-Instruct`).

### Why is it needed?
Some SDKs and libraries (like LangChain) need to know the **actual model name**  
(not just the deployment name) to set the right parameters, token limits,  
and behaviour for that model.

### Relationship with Deployment Name:
```
Deployment Name  ──(points to)──►  Model Name
"gpt-4.1-mini"                     "gpt-4.1-mini"    ← can be same
"Llama-3.3-70B-Instruct"           "Llama-3.3-70B-Instruct"  ← can be same
"my-production-bot"                "gpt-4"           ← can be different
```

### Example:
```
AZURE_OPENAI_MODEL_NAME = Llama-3.3-70B-Instruct
```

### Where to find it?
- In the **Azure AI Foundry** → Deployments page, it lists the model version used.
- It is also mentioned in the Azure OpenAI **Model Catalog**.

---

## 🔧 How to Set Up Your `.env` File

Create a file named **`.env`** in your project root and add the following:

```env
# Azure OpenAI — Connection Settings
AZURE_OPENAI_ENDPOINT         = https://<your-resource-name>.openai.azure.com/
AZURE_OPENAI_API_KEY          = <your-api-key-here>
AZURE_OPENAI_DEPLOYMENT_NAME  = <your-deployment-name>
AZURE_OPENAI_MODEL_NAME       = <actual-model-name>
```

> 📁 Add `.env` to your `.gitignore` file to keep secrets safe!

---

## 🐍 How to Load `.env` in Python

Install the required library:
```bash
pip install python-dotenv
```

Load it in your Python script:
```python
import os
from dotenv import load_dotenv

# Load all variables from .env into environment
load_dotenv()

# Read each variable
endpoint        = os.getenv("AZURE_OPENAI_ENDPOINT")
api_key         = os.getenv("AZURE_OPENAI_API_KEY")
deployment_name = os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME")
model_name      = os.getenv("AZURE_OPENAI_MODEL_NAME")
```

---

## 🔗 Connecting with the `openai` Python SDK

```python
from openai import AzureOpenAI
from dotenv import load_dotenv
import os

load_dotenv()

# Create the Azure OpenAI client
client = AzureOpenAI(
    azure_endpoint = os.getenv("AZURE_OPENAI_ENDPOINT"),
    api_key        = os.getenv("AZURE_OPENAI_API_KEY"),
    api_version    = "2024-02-01"   # Use the appropriate API version
)

# Make a chat completion request
response = client.chat.completions.create(
    model    = os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME"),  # deployment name here
    messages = [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user",   "content": "Hello! What can you do?"}
    ]
)

print(response.choices[0].message.content)
```

---

## 🦜 Connecting with LangChain (`AzureChatOpenAI`)

```python
from langchain_openai import AzureChatOpenAI
from dotenv import load_dotenv
import os

load_dotenv()

# Create the LangChain Azure OpenAI LLM
llm = AzureChatOpenAI(
    azure_endpoint            = os.getenv("AZURE_OPENAI_ENDPOINT"),
    api_key                   = os.getenv("AZURE_OPENAI_API_KEY"),
    azure_deployment          = os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME"),
    model                     = os.getenv("AZURE_OPENAI_MODEL_NAME"),
    api_version               = "2024-02-01",
    temperature               = 0.7,
    max_tokens                = 1000
)

# Invoke the model
response = llm.invoke("What is Azure OpenAI?")
print(response.content)
```

---

## 📋 API Version

Azure OpenAI also requires an **`api_version`** parameter in code.  
This tells the SDK which version of the Azure OpenAI REST API to use.

| Version | Status | Notes |
|---------|--------|-------|
| `2024-02-01` | Stable | Recommended for production |
| `2024-05-01-preview` | Preview | Access to newer features |
| `2025-01-01-preview` | Latest Preview | Cutting-edge features |

> You find the latest supported versions in the  
> [Azure OpenAI API Reference Docs](https://learn.microsoft.com/en-us/azure/ai-services/openai/reference)

---

## 🗺️ Full Connection Flow — Visual Summary

```
Your Python Script
        │
        │  reads
        ▼
    .env file
  ┌─────────────────────────────────────────────────┐
  │  ENDPOINT         → Where to send the request   │
  │  API KEY          → Proves your identity         │
  │  DEPLOYMENT NAME  → Which model deployment       │
  │  MODEL NAME       → Actual model (for SDK hints) │
  └─────────────────────────────────────────────────┘
        │
        │  HTTP POST request
        ▼
  Azure OpenAI Resource (in Azure Cloud)
        │
        │  routes to
        ▼
  Your Deployed Model (e.g., GPT-4, Llama-3.3)
        │
        │  returns
        ▼
  AI Response → Your Script
```

---

## ❓ Common Errors & Fixes

| Error | Likely Cause | Fix |
|-------|-------------|-----|
| `401 Unauthorized` | Wrong or missing API Key | Double-check your API key in `.env` |
| `404 Not Found` | Wrong deployment name | Verify deployment name in Azure AI Foundry |
| `ResourceNotFound` | Wrong endpoint URL | Copy the exact endpoint from Azure Portal |
| `InvalidRequest` | Wrong API version | Use a supported `api_version` string |
| `RateLimitExceeded` | Too many requests | Add retry logic or reduce request rate |

---

## 📚 Useful Links

- [Azure OpenAI Service Docs](https://learn.microsoft.com/en-us/azure/ai-services/openai/)
- [Azure AI Foundry Portal](https://ai.azure.com)
- [Azure Portal](https://portal.azure.com)
- [LangChain AzureChatOpenAI Docs](https://python.langchain.com/docs/integrations/chat/azure_chat_openai/)
- [OpenAI Python SDK — Azure](https://github.com/openai/openai-python#microsoft-azure-openai)

---

*Last Updated: June 2026 | Author: Subramani*
