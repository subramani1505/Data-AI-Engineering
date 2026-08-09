# LLM Inference Parameters & Configuration — The Complete Engineering Guide

> **Author:** Subramani V  
> **Created:** August 2026  
> **Purpose:** Production-level reference for understanding and configuring LLM inference parameters  
> **Prerequisite:** Understanding of LLM architecture and model selection

---

## Table of Contents

1. [Why Inference Parameters Matter](#why-inference-parameters-matter)
2. [Two Categories of LLM Settings](#two-categories-of-llm-settings)
3. [Category 1: Model Selection Parameters](#category-1-model-selection-parameters)
   - [1. Provider](#1-provider)
   - [2. Model Name](#2-model-name)
   - [3. Context Window](#3-context-window)
4. [Category 2: Inference (Sampling) Parameters](#category-2-inference-sampling-parameters)
   - [4. Temperature](#4-temperature)
   - [5. Top-p (Nucleus Sampling)](#5-top-p-nucleus-sampling)
   - [6. Top-k](#6-top-k)
   - [7. Temperature vs Top-p vs Top-k — How They Work Together](#7-temperature-vs-top-p-vs-top-k--how-they-work-together)
   - [8. Max Output Tokens](#8-max-output-tokens)
   - [9. Stop Sequences](#9-stop-sequences)
   - [10. Seed](#10-seed)
   - [11. Frequency Penalty & Presence Penalty](#11-frequency-penalty--presence-penalty)
   - [12. Response Format / JSON Mode](#12-response-format--json-mode)
5. [The Complete Parameter Reference Table](#the-complete-parameter-reference-table)
6. [Parameter Importance Ranking](#parameter-importance-ranking)
7. [The Mathematics Behind Sampling](#the-mathematics-behind-sampling)
8. [Configuration Recipes for Real Applications](#configuration-recipes-for-real-applications)
9. [Provider-Specific Parameter Support](#provider-specific-parameter-support)
10. [Common Mistakes & Anti-Patterns](#common-mistakes--anti-patterns)
11. [How AI Engineers Tune Parameters in Production](#how-ai-engineers-tune-parameters-in-production)
12. [Quick Reference Card](#quick-reference-card)

---

## Why Inference Parameters Matter

When you initialize an LLM, you write something like:

```python
llm = ChatOpenAI(
    model="gpt-4.1",
    temperature=0.2,
    top_p=0.95,
    max_tokens=1000,
)
```

Many beginners think these are just random settings. **They're not.**

These settings control the behavior of the model and have a **massive impact** on your application's quality, consistency, cost, and user experience.

```
Same Model + Different Parameters = COMPLETELY Different Behavior

┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│  GPT-4.1 with temperature=0.0:                                  │
│  ──────────────────────────────                                  │
│  "The capital of France is Paris."                               │
│  "The capital of France is Paris."                               │
│  "The capital of France is Paris."                               │
│  → Identical every time. Deterministic. Reliable.                │
│                                                                  │
│  GPT-4.1 with temperature=1.5:                                  │
│  ──────────────────────────────                                  │
│  "The capital of France is Paris, a stunning city on the Seine." │
│  "France's capital? That would be the beautiful Paris!"          │
│  "Paris serves as France's vibrant capital city."                │
│  → Different every time. Creative. Varied.                       │
│                                                                  │
│  SAME MODEL. SAME PROMPT. Different parameters.                 │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Two Categories of LLM Settings

The first thing to understand is that there are **two distinct categories** of settings.

```
┌─────────────────────────────────────────────────────────────────┐
│              LLM CONFIGURATION = TWO CATEGORIES                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  CATEGORY 1: MODEL SELECTION                                     │
│  ─────────────────────────────                                   │
│  Decides WHICH BRAIN you are using                               │
│                                                                  │
│  ┌─────────────────────────┐                                     │
│  │ Provider    → OpenAI    │                                     │
│  │ Model       → gpt-4.1  │                                     │
│  │ Context     → 1M tokens │                                     │
│  │ Capabilities→ Vision ✅ │                                     │
│  │ Pricing     → $2/$8    │                                     │
│  └─────────────────────────┘                                     │
│                                                                  │
│  CATEGORY 2: INFERENCE PARAMETERS                                │
│  ─────────────────────────────────                               │
│  Decides HOW THAT BRAIN BEHAVES                                  │
│                                                                  │
│  ┌─────────────────────────┐                                     │
│  │ Temperature → 0.7       │                                     │
│  │ Top-p       → 0.9       │                                     │
│  │ Top-k       → 50        │                                     │
│  │ Max Tokens  → 1000      │                                     │
│  │ Stop Seqs   → ["\n\n"]  │                                     │
│  │ Seed        → 42        │                                     │
│  └─────────────────────────┘                                     │
│                                                                  │
│  The model remains the same.                                     │
│  Its output characteristics change.                              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### The Car Analogy

```
Think of it like driving a car:

   The CAR             = The Model         (GPT-4.1, Claude, LLaMA)
   The ENGINE SIZE     = Model Parameters  (7B, 70B, 405B)
   The FUEL TANK       = Context Window    (128K, 200K, 1M tokens)

   The SPEED           = Temperature       (fast/creative vs slow/careful)
   The STEERING        = Top-p / Top-k     (how many options to consider)
   The DISTANCE LIMIT  = Max Output Tokens (how far you can go)
   The BRAKES          = Stop Sequences    (when to stop)
```

---

## Category 1: Model Selection Parameters

### 1. Provider

The provider is the company or platform that serves the model.

```
┌──────────────────────────────────────────────────────────────────┐
│                    LLM PROVIDERS                                  │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  PROVIDER         MODELS                  NOTABLE FEATURES        │
│  ────────         ──────                  ────────────────        │
│  OpenAI           GPT-4.1, o3, o4-mini    Best tool calling      │
│  Anthropic        Claude Opus/Sonnet/Haiku Best coding, safety   │
│  Google           Gemini 2.5 Pro/Flash    Best multimodal        │
│  Mistral AI       Mistral Large/Small     European, open models  │
│  Meta             LLaMA 3.1 (self-host)   Best open-source       │
│  Cohere           Command R+              RAG-optimized          │
│  Together AI      Various open models     Cheap inference         │
│  Groq             Various open models     Ultra-fast inference    │
│  AWS Bedrock      Multiple providers      Enterprise cloud        │
│  Azure OpenAI     OpenAI models           HIPAA/enterprise        │
│  Google Vertex    Google models            Enterprise cloud       │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

**The provider determines:**

| Factor              | Impact                                               |
|----------------------|------------------------------------------------------|
| API availability     | Which models can you access?                         |
| Pricing              | How much per token?                                  |
| Rate limits          | How many requests per minute?                        |
| Features             | Vision, tool calling, JSON mode, batch API?          |
| Compliance           | HIPAA, SOC 2, GDPR, FedRAMP?                        |
| Data residency       | Where is data processed?                             |
| SLA                  | Uptime guarantees?                                   |
| Latency              | Regional endpoints and speed?                        |

```python
# Choosing a provider — examples

# Option A: OpenAI directly
from openai import OpenAI
client = OpenAI(api_key="sk-...")

# Option B: Azure OpenAI (enterprise, HIPAA-compliant)
from openai import AzureOpenAI
client = AzureOpenAI(
    azure_endpoint="https://my-resource.openai.azure.com",
    api_version="2024-10-21",
    api_key="..."
)

# Option C: Anthropic
from anthropic import Anthropic
client = Anthropic(api_key="sk-ant-...")

# Option D: Google
import google.generativeai as genai
genai.configure(api_key="...")

# Option E: Self-hosted open-source via vLLM
from openai import OpenAI
client = OpenAI(
    base_url="http://localhost:8000/v1",  # vLLM server
    api_key="not-needed"
)
```

**This is like choosing a car manufacturer:**

```
Toyota   → Reliable, affordable        → OpenAI (GPT-4.1-mini)
BMW      → Premium, powerful            → Anthropic (Claude Opus 4)
Tesla    → Innovative, cutting-edge     → Google (Gemini 2.5 Pro)
Honda    → Practical, value             → Mistral
Build    → Full control, effort         → Self-hosted (LLaMA, vLLM)
your own
```

---

### 2. Model Name

The specific model you choose within a provider.

```
Provider: OpenAI
                │
                ├── gpt-4.1          → Flagship (balanced power + speed)
                ├── gpt-4.1-mini     → Fast, cost-effective
                ├── gpt-4.1-nano     → Cheapest, fastest
                ├── gpt-4o           → Multimodal (text + image + audio)
                ├── o3               → Best reasoning (math, science)
                └── o4-mini          → Fast reasoning at lower cost

Provider: Anthropic
                │
                ├── claude-opus-4    → Most capable, deepest reasoning
                ├── claude-sonnet-4  → Best balance (quality + speed)
                └── claude-haiku-3.5 → Fast, budget-friendly

Provider: Google
                │
                ├── gemini-2.5-pro   → Frontier, 1M context, all modalities
                ├── gemini-2.5-flash → Fast, cost-effective, thinking mode
                └── gemini-2.0-flash-lite → Cheapest Google option
```

**Different models have different:**

| Property           | Varies By Model                                      |
|--------------------|------------------------------------------------------|
| Intelligence       | How well it understands and reasons                  |
| Cost               | Price per million tokens                             |
| Speed              | Tokens per second                                    |
| Reasoning ability  | Complex math, coding, planning                       |
| Context size       | How much text it can process at once                 |
| Modalities         | Text only? + Image? + Audio? + Video?                |
| Tool calling       | Can it reliably call functions?                      |

```python
# Model selection in code

# For a customer support chatbot (fast, cheap)
llm = ChatOpenAI(model="gpt-4.1-nano")

# For a coding assistant (strong reasoning)
llm = ChatOpenAI(model="gpt-4.1")

# For complex mathematical proofs
llm = ChatOpenAI(model="o3")

# For analyzing medical images
llm = ChatGoogleGenerativeAI(model="gemini-2.5-pro")
```

---

### 3. Context Window

> **The maximum number of tokens the model can consider in one request — including both input AND output.**

This is one of the most misunderstood concepts.

```
┌──────────────────────────────────────────────────────────────────┐
│                    CONTEXT WINDOW EXPLAINED                       │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Context Window = Input Tokens + Output Tokens                    │
│                                                                   │
│  ┌─────────────────────────────────────────────────┐              │
│  │              CONTEXT WINDOW (128K)               │              │
│  │                                                   │              │
│  │  ┌────────────────────────┬──────────────────┐   │              │
│  │  │    INPUT TOKENS        │  OUTPUT TOKENS    │   │              │
│  │  │    (your prompt,       │  (model's         │   │              │
│  │  │     system message,    │   response)       │   │              │
│  │  │     chat history,      │                   │   │              │
│  │  │     documents)         │                   │   │              │
│  │  └────────────────────────┴──────────────────┘   │              │
│  └─────────────────────────────────────────────────┘              │
│                                                                   │
│  If your input is 127,000 tokens and context is 128K,            │
│  the model can only generate ~1,000 output tokens.               │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

#### The Whiteboard Analogy

```
Think of context as a whiteboard:

Small Whiteboard (4K tokens — old models):
┌──────────────────┐
│ Only a few       │
│ paragraphs fit.  │
│ Limited info.    │
└──────────────────┘

Medium Whiteboard (128K tokens):
┌──────────────────────────────────────────────────────┐
│                                                       │
│  Can hold ~180 pages of text.                        │
│  Entire codebases, long conversations, research.      │
│                                                       │
└──────────────────────────────────────────────────────┘

Giant Whiteboard (1M tokens):
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│  Can hold ~1,500 pages. Multiple books. Entire repositories.        │
│  Can reason over massive amounts of information simultaneously.      │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

#### Context Window Sizes

| Model              | Context Window  | ≈ Pages | ≈ Words     |
|--------------------|-----------------|---------|-------------|
| GPT-3 (2020)       | 2,048 tokens    | ~3      | ~1,500      |
| GPT-3.5 (2022)     | 4,096 tokens    | ~6      | ~3,000      |
| LLaMA 2 (2023)     | 4,096 tokens    | ~6      | ~3,000      |
| Claude 2 (2023)    | 100,000 tokens  | ~140    | ~75,000     |
| GPT-4 Turbo (2024) | 128,000 tokens  | ~180    | ~96,000     |
| LLaMA 3.1 (2024)   | 128,000 tokens  | ~180    | ~96,000     |
| Claude Sonnet 4    | 200,000 tokens  | ~285    | ~150,000    |
| GPT-4.1 (2025)     | 1,047,576 tokens| ~1,500  | ~785,000    |
| Gemini 2.5 Pro     | 1,048,576 tokens| ~1,500  | ~786,000    |

#### What Happens When Input Exceeds the Context Window?

```
Scenario: You have a 200,000 token document.
Model context: 128,000 tokens.

Option 1: TRUNCATION (Bad)
──────────────────────────
   Just cut off at 128K tokens.
   ❌ You lose the rest of the document.

Option 2: CHUNKING + RAG (Good)
───────────────────────────────
   Split document into chunks.
   Retrieve only relevant chunks.
   Send relevant chunks to the model.
   ✅ Cost-effective, works for focused queries.

Option 3: USE A LARGER MODEL (Simple)
─────────────────────────────────────
   Switch to GPT-4.1 (1M context) or Gemini 2.5 Pro (1M).
   Send the whole document.
   ✅ Simple but expensive (you pay for all tokens).

Option 4: MAP-REDUCE (Powerful)
───────────────────────────────
   Split into chunks.
   Summarize each chunk separately.
   Combine summaries.
   ✅ Works for very large documents.
```

---

## Category 2: Inference (Sampling) Parameters

These parameters control **how the model generates its output** — not what it knows, but how it behaves.

### How Text Generation Works (Quick Refresher)

Before we discuss parameters, let's quickly recap how an LLM generates text:

```
Input: "The best programming language is"

Step 1: Model computes LOGITS (raw scores) for every token in vocabulary

   Token          Logit
   ─────          ─────
   Python         8.2
   JavaScript     6.5
   C++            5.1
   Java           4.8
   subjective     3.9
   Go             3.2
   Rust           2.8
   ...            ...
   banana        -5.1

Step 2: Apply TEMPERATURE to logits

Step 3: Convert to PROBABILITIES (softmax)

Step 4: Apply TOP-P / TOP-K filtering

Step 5: SAMPLE one token from the remaining candidates

Step 6: Repeat from Step 1 with the new token appended
```

The inference parameters control **Steps 2, 3, 4, and 5**.

---

### 4. Temperature

> **Controls how random or creative the next-token selection is.**

Temperature is probably the most famous and most important inference parameter.

#### How Temperature Works (Mathematically)

```
Without temperature (or temperature = 1.0):
──────────────────────────────────────────
   P(token_i) = exp(logit_i) / Σ exp(logit_j)
   
   This is standard softmax.

With temperature T:
──────────────────
   P(token_i) = exp(logit_i / T) / Σ exp(logit_j / T)

   The logits are DIVIDED by T before softmax.
```

#### What Temperature Does to the Distribution

Suppose the model produces these logits:

```
Token       Logit     T=0.1     T=0.5     T=1.0     T=1.5     T=2.0
─────       ─────     ─────     ─────     ─────     ─────     ─────
pizza        4.0      99.5%     73.1%     45.9%     34.0%     28.0%
burger       3.5       0.5%     22.1%     26.3%     24.5%     23.2%
pasta        2.5       0.0%      3.6%     13.0%     16.2%     17.3%
sushi        2.0       0.0%      0.9%      6.4%     10.5%     12.7%
rice         1.0       0.0%      0.0%      2.3%      5.6%      7.5%
salad        0.5       0.0%      0.0%      1.4%      3.8%      5.3%
broccoli    -1.0       0.0%      0.0%      0.3%      1.4%      2.3%
```

#### Visual Representation

```
Temperature = 0.0 (or very close to 0):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ pizza (≈100%)
▏ burger, pasta, sushi, etc. (≈0%)

Temperature = 0.5:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ pizza (73%)
━━━━━━━━━━━ burger (22%)
━━ pasta (4%)
▏ sushi, rice (≈1%)

Temperature = 1.0:
━━━━━━━━━━━━━━━━━━━━ pizza (46%)
━━━━━━━━━━━━━ burger (26%)
━━━━━━ pasta (13%)
━━━ sushi (6%)
━ rice (2%)

Temperature = 2.0:
━━━━━━━━━━━━━━ pizza (28%)
━━━━━━━━━━━━ burger (23%)
━━━━━━━━━ pasta (17%)
━━━━━━━ sushi (13%)
━━━━ rice (8%)
━━━ salad (5%)
━ broccoli (2%)

Lower T → More deterministic → Always picks the top choice
Higher T → More random → Spreads probability across many choices
```

#### Temperature = 0 (Special Case)

```
When temperature = 0:
   The model ALWAYS picks the token with the highest probability.
   This is called GREEDY DECODING.
   
   Output is nearly deterministic (same input → same output).
   
   ⚠️ Note: Some providers implement T=0 as "very small T" (e.g., 1e-8),
   so minor variations are still theoretically possible.
```

#### When to Use Each Temperature

```
┌──────────────────────────────────────────────────────────────────────┐
│              TEMPERATURE GUIDE BY APPLICATION                         │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  TEMPERATURE 0.0 — "The Analyst"                                      │
│  ────────────────────────────────                                     │
│  Use when you need EXACT, REPEATABLE, CONSISTENT answers.            │
│                                                                       │
│  ✅ SQL generation        → SELECT * FROM users WHERE...              │
│  ✅ Code generation       → def fibonacci(n): ...                     │
│  ✅ Data extraction       → Extract: name, date, amount               │
│  ✅ Classification        → Sentiment: positive/negative              │
│  ✅ Math problems         → 2 + 2 = 4                                 │
│  ✅ Legal documents       → Precise, no variation                     │
│  ✅ JSON output           → Structured, consistent format             │
│  ✅ Unit test assertions  → Expected outputs must match               │
│                                                                       │
│  TEMPERATURE 0.1 - 0.3 — "The Professional"                          │
│  ────────────────────────────────────────────                         │
│  Mostly consistent, with very slight natural variation.               │
│                                                                       │
│  ✅ Customer support      → Consistent but not robotic                │
│  ✅ Technical writing      → Precise but naturally worded              │
│  ✅ Code review comments  → Helpful but slightly varied               │
│  ✅ Q&A over documents    → Factual with natural phrasing             │
│                                                                       │
│  TEMPERATURE 0.4 - 0.7 — "The Conversationalist"                     │
│  ─────────────────────────────────────────────────                    │
│  Balanced between consistency and creativity.                         │
│                                                                       │
│  ✅ General chatbots      → Natural conversation                      │
│  ✅ Email drafting        → Professional with personality             │
│  ✅ Summarization         → Varied phrasing, same meaning            │
│  ✅ Explanations          → Different ways to explain same concept    │
│                                                                       │
│  TEMPERATURE 0.7 - 1.0 — "The Creative"                              │
│  ────────────────────────────────────────                             │
│  More diverse and creative outputs.                                   │
│                                                                       │
│  ✅ Creative writing      → Stories, poems, dialogues                 │
│  ✅ Brainstorming         → Diverse idea generation                   │
│  ✅ Marketing copy        → Varied taglines and slogans              │
│  ✅ Story generation      → Unpredictable, engaging plots            │
│                                                                       │
│  TEMPERATURE 1.0 - 2.0 — "The Wild Card"                             │
│  ──────────────────────────────────────────                           │
│  Very random. Often incoherent at the high end.                       │
│                                                                       │
│  ⚠️ Experimental          → Exploring unusual ideas                   │
│  ⚠️ Art/poetry            → Unexpected word combinations              │
│  ❌ Most production apps  → Too unpredictable                         │
│  ❌ Factual tasks         → Will produce errors                       │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

#### Temperature in Code

```python
# SQL Generator — must be deterministic
llm = ChatOpenAI(model="gpt-4.1", temperature=0.0)

# Customer Support — consistent but natural
llm = ChatOpenAI(model="gpt-4.1-mini", temperature=0.2)

# General Chatbot — balanced
llm = ChatOpenAI(model="gpt-4.1-mini", temperature=0.5)

# Creative Writing — encourage variety
llm = ChatOpenAI(model="gpt-4.1", temperature=0.9)

# Brainstorming — maximize diversity
llm = ChatOpenAI(model="gpt-4.1", temperature=1.0)
```

---

### 5. Top-p (Nucleus Sampling)

> **Only consider the smallest set of tokens whose cumulative probability reaches p.**

Instead of considering ALL tokens in the vocabulary, top-p **filters** to a dynamic set of the most likely candidates.

#### How Top-p Works

```
Step 1: Sort tokens by probability (after temperature)

   Token       Probability    Cumulative
   ─────       ───────────    ──────────
   pizza        50%            50%
   burger       30%            80%        ← top_p=0.80 cuts here
   pasta        10%            90%
   sushi         5%            95%        ← top_p=0.95 cuts here
   rice          3%            98%
   salad         2%           100%

Step 2: Keep only tokens within the cumulative threshold

   top_p = 0.80 → Keep: {pizza, burger}              → 2 candidates
   top_p = 0.95 → Keep: {pizza, burger, pasta, sushi} → 4 candidates
   top_p = 1.00 → Keep: ALL tokens                    → Full vocabulary

Step 3: Redistribute probabilities among remaining tokens
Step 4: Sample from the filtered set
```

#### Visual Representation

```
top_p = 0.80:
   ✅ pizza  (50%)  ████████████████████████████
   ✅ burger (30%)  █████████████████
   ❌ pasta  (10%)  ──────  (excluded)
   ❌ sushi  (5%)   ───  (excluded)
   ❌ rest          (excluded)
   
   Only pizza and burger compete.
   After redistribution: pizza (62.5%), burger (37.5%)

top_p = 0.95:
   ✅ pizza  (50%)  ████████████████████████████
   ✅ burger (30%)  █████████████████
   ✅ pasta  (10%)  ██████
   ✅ sushi  (5%)   ███
   ❌ rice   (3%)   ──  (excluded)
   ❌ rest          (excluded)
   
   Four tokens compete. More diversity.

top_p = 1.00:
   ✅ ALL tokens are candidates.
   Maximum diversity (equivalent to no filtering).
```

#### When to Use Top-p

```
┌──────────────────────────────────────────────────────────────────┐
│                    TOP-P GUIDE                                    │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  top_p = 0.1 - 0.5:  Very focused. Almost greedy.               │
│                       Few candidates. Safe and predictable.       │
│                       Use for: Code, SQL, classification          │
│                                                                   │
│  top_p = 0.7 - 0.9:  Balanced. Good for most applications.      │
│                       Moderate candidate pool.                    │
│                       Use for: Chatbots, Q&A, summaries           │
│                                                                   │
│  top_p = 0.95:        Slightly diverse. Industry default.        │
│                       Good starting point for most tasks.         │
│                       Use for: General purpose                    │
│                                                                   │
│  top_p = 1.0:         No filtering. Maximum diversity.           │
│                       All tokens are candidates.                  │
│                       Use for: Creative writing, brainstorming    │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

### 6. Top-k

> **Only consider the top k most probable tokens.**

Top-k is simpler than top-p. It sets a **fixed number** of candidates.

```
Suppose the model produces:

   Token       Probability
   ─────       ───────────
   pizza        50%
   burger       30%
   pasta        10%
   sushi         5%
   rice          3%
   salad         2%

top_k = 1:  Only {pizza}                          → Always picks pizza
top_k = 3:  Only {pizza, burger, pasta}            → 3 candidates
top_k = 5:  Only {pizza, burger, pasta, sushi, rice} → 5 candidates
top_k = 50: Top 50 tokens                          → Broad pool
```

#### Top-k Availability

| Provider   | top_k Supported? | Notes                              |
|------------|-------------------|------------------------------------|
| OpenAI     | ❌ No             | Use top_p instead                  |
| Anthropic  | ✅ Yes            | Available as parameter             |
| Google     | ✅ Yes            | Available for Gemini models        |
| Mistral    | ✅ Yes            | Available via API                  |
| Self-hosted| ✅ Yes            | Available in vLLM, llama.cpp, etc. |

```python
# Top-k in Anthropic
response = client.messages.create(
    model="claude-sonnet-4-20250514",
    top_k=40,
    messages=[{"role": "user", "content": "Tell me a story"}]
)

# Top-k in Google Gemini
response = model.generate_content(
    "Tell me a story",
    generation_config={"top_k": 40}
)
```

---

### 7. Temperature vs Top-p vs Top-k — How They Work Together

This is one of the most confusing topics. Let's clarify exactly how these interact.

```
┌──────────────────────────────────────────────────────────────────┐
│     HOW SAMPLING PARAMETERS INTERACT (IN ORDER)                  │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Step 1: Model produces LOGITS (raw scores)                      │
│            │                                                      │
│            ▼                                                      │
│  Step 2: TEMPERATURE is applied                                   │
│           logit_i / T                                             │
│           This RESHAPES the probability distribution              │
│            │                                                      │
│            ▼                                                      │
│  Step 3: SOFTMAX converts to probabilities                       │
│           P(i) = exp(logit_i/T) / Σ exp(logit_j/T)              │
│            │                                                      │
│            ▼                                                      │
│  Step 4: TOP-K filtering (if enabled)                            │
│           Keep only top k tokens                                  │
│           This REMOVES unlikely candidates                        │
│            │                                                      │
│            ▼                                                      │
│  Step 5: TOP-P filtering (if enabled)                            │
│           Keep smallest set with cumulative prob ≥ p              │
│           This FURTHER REMOVES candidates                         │
│            │                                                      │
│            ▼                                                      │
│  Step 6: REDISTRIBUTE probabilities                              │
│           Remaining tokens sum to 100%                            │
│            │                                                      │
│            ▼                                                      │
│  Step 7: SAMPLE one token                                        │
│           Random selection based on final probabilities           │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

#### Key Differences

```
┌────────────────┬──────────────────────┬──────────────────────────────┐
│ Parameter      │ What It Does         │ Analogy                      │
├────────────────┼──────────────────────┼──────────────────────────────┤
│ TEMPERATURE    │ Changes the SHAPE    │ Adjusting the steepness      │
│                │ of the probability   │ of a hill — steep (T=0.1)    │
│                │ distribution         │ or flat (T=2.0)              │
├────────────────┼──────────────────────┼──────────────────────────────┤
│ TOP-P          │ FILTERS to a         │ Only allowing the top        │
│                │ dynamic set of       │ runners who collectively     │
│                │ candidates           │ cover P% of the win          │
│                │ (adaptive cutoff)    │ probability into the race    │
├────────────────┼──────────────────────┼──────────────────────────────┤
│ TOP-K          │ FILTERS to a         │ Only allowing the top K      │
│                │ fixed number of      │ runners into the race,       │
│                │ candidates           │ regardless of their odds     │
└────────────────┴──────────────────────┴──────────────────────────────┘
```

#### The Race Analogy (All Three Together)

```
Imagine a running race with 50,000 runners (= vocabulary size):

1. TEMPERATURE changes how big the speed gaps are between runners:
   Low T  → The leader is WAY ahead. Almost no competition.
   High T → Everyone runs at similar speeds. Anyone could win.

2. TOP-K eliminates all but the top K runners:
   top_k=10 → Only 10 fastest runners remain.

3. TOP-P eliminates runners until the remaining ones
   cover P% of the total winning probability:
   top_p=0.9 → Keep runners until 90% chance is covered.

4. SAMPLE the winner from whoever is left.
```

#### Best Practices for Combining Parameters

```
┌──────────────────────────────────────────────────────────────────┐
│              RECOMMENDED COMBINATIONS                             │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  OPTION A: Temperature only (simplest)                           │
│  ─────────────────────────────────────                           │
│  temperature = 0.0 to 1.0                                        │
│  top_p = 1.0 (disabled)                                          │
│  top_k = not set                                                 │
│  → Good for: Most applications                                   │
│                                                                   │
│  OPTION B: Top-p only                                            │
│  ──────────────────                                              │
│  temperature = 1.0 (neutral)                                     │
│  top_p = 0.5 to 0.95                                             │
│  top_k = not set                                                 │
│  → Good for: When you want to control candidate pool directly    │
│                                                                   │
│  OPTION C: Temperature + Top-p (common in production)            │
│  ────────────────────────────────────────────────────            │
│  temperature = 0.2 to 0.8                                        │
│  top_p = 0.9 to 0.95                                             │
│  → Good for: Fine-grained control                                │
│                                                                   │
│  ⚠️ AVOID: Extreme changes to BOTH simultaneously               │
│  ──────────────────────────────────────────────────              │
│  temperature = 1.5 + top_p = 0.3                                 │
│  → The effects can cancel out or create unpredictable behavior   │
│                                                                   │
│  Many providers recommend: "Alter temperature OR top_p,          │
│  but not both dramatically."                                     │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

### 8. Max Output Tokens

> **Limits how many tokens the model can generate in its response.**

```
┌──────────────────────────────────────────────────────────────────┐
│              MAX OUTPUT TOKENS EXPLAINED                          │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  max_output_tokens = 200:                                        │
│  ─────────────────────────                                       │
│  The model's response will be at most ~200 tokens (~150 words).  │
│  If it reaches 200 tokens, it STOPS mid-sentence.               │
│                                                                   │
│  max_output_tokens = 4000:                                       │
│  ──────────────────────────                                      │
│  The model can produce long, detailed responses.                 │
│  Up to ~3,000 words.                                             │
│                                                                   │
│  max_output_tokens = 16384:                                      │
│  ───────────────────────────                                     │
│  Maximum for many models. Very long outputs possible.            │
│  Use for: Full code files, long reports, detailed analysis.      │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

#### Maximum Output Limits by Model

| Model              | Max Output Tokens | ≈ Words    |
|--------------------|-------------------|------------|
| GPT-4.1            | 32,768            | ~24,500    |
| GPT-4.1-mini       | 16,384            | ~12,300    |
| Claude Sonnet 4    | 16,000            | ~12,000    |
| Claude Opus 4      | 32,000            | ~24,000    |
| Gemini 2.5 Pro     | 65,536            | ~49,000    |
| Gemini 2.5 Flash   | 65,536            | ~49,000    |
| LLaMA 3.1          | Configurable      | Depends    |

#### Why Max Output Tokens Matters

```
1. COST CONTROL
   ────────────
   You pay for output tokens. Limiting output limits cost.
   
   Example: 
   max_tokens=100  → ~$0.0008 per response (GPT-4.1)
   max_tokens=4000 → ~$0.032 per response (GPT-4.1)
   40× difference!

2. RESPONSE LENGTH
   ────────────────
   Too short → model cuts off important information.
   Too long  → user gets overwhelmed with unnecessary detail.
   
3. UI CONSTRAINTS
   ───────────────
   Chat bubble → 200-500 tokens is comfortable.
   Report generation → 2000-4000 tokens may be needed.
   Code generation → 4000-16000 tokens for full files.

4. PREVENTING RUNAWAY GENERATION
   ──────────────────────────────
   Without a limit, a model might generate endlessly
   (especially with high temperature).
```

#### Setting Max Output Tokens in Code

```python
# Short, concise answers (FAQ bot)
llm = ChatOpenAI(
    model="gpt-4.1-mini",
    max_tokens=300
)

# Detailed analysis (research assistant)
llm = ChatOpenAI(
    model="gpt-4.1",
    max_tokens=4000
)

# Full code generation (coding assistant)
llm = ChatOpenAI(
    model="gpt-4.1",
    max_tokens=16384
)

# Structured extraction (short JSON output)
llm = ChatOpenAI(
    model="gpt-4.1-nano",
    max_tokens=500
)
```

---

### 9. Stop Sequences

> **Strings that, when generated, cause the model to immediately stop producing output.**

```
┌──────────────────────────────────────────────────────────────────┐
│              STOP SEQUENCES EXPLAINED                             │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Without stop sequence:                                           │
│  ──────────────────────                                          │
│  Model generates until max_tokens is reached or <EOS> token.     │
│                                                                   │
│  With stop sequence ["END"]:                                     │
│  ────────────────────────────                                    │
│  Model generates until it produces "END", then STOPS.            │
│  The stop sequence itself is NOT included in the output.         │
│                                                                   │
│  Example:                                                         │
│  Prompt: "Generate a SQL query. End with END."                   │
│  Output: "SELECT * FROM users WHERE age > 25; "                  │
│  (The model stopped when it was about to generate "END")         │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

#### Common Use Cases

```
1. STRUCTURED PROMPTS
   ───────────────────
   stop=["Question:", "###"]
   
   Prompt: "Answer the following question.\nQuestion: What is AI?\nAnswer:"
   Model: "AI is artificial intelligence...\n"
   STOPS before generating the next "Question:"

2. CODE GENERATION
   ────────────────
   stop=["```"]
   
   Makes the model stop after closing a code block.

3. CONVERSATION BOUNDARIES
   ────────────────────────
   stop=["User:", "Human:", "<|end|>"]
   
   Prevents the model from simulating the user's next message.

4. JSON EXTRACTION
   ────────────────
   stop=["}"]  (careful with nested objects)
   
   Stops after closing the JSON object.
```

#### Stop Sequences in Code

```python
# OpenAI
response = client.chat.completions.create(
    model="gpt-4.1",
    messages=[{"role": "user", "content": prompt}],
    stop=["###", "END", "\n\n\n"]  # Up to 4 stop sequences
)

# Anthropic
response = client.messages.create(
    model="claude-sonnet-4-20250514",
    messages=[{"role": "user", "content": prompt}],
    stop_sequences=["###", "END"]
)

# LangChain
llm = ChatOpenAI(
    model="gpt-4.1",
    stop=["###"]
)
```

---

### 10. Seed

> **Makes the model's output more reproducible by setting a random seed.**

```
┌──────────────────────────────────────────────────────────────────┐
│              SEED PARAMETER                                       │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Without seed:                                                    │
│  ─────────────                                                   │
│  Same prompt, same parameters → DIFFERENT outputs each time.     │
│  (Because sampling is random)                                    │
│                                                                   │
│  With seed=42:                                                    │
│  ──────────────                                                  │
│  Same prompt, same parameters, same seed → SAME output.          │
│  (More reproducible, though not always 100% guaranteed)          │
│                                                                   │
│  ⚠️ Important caveats:                                            │
│  ─────────────────────                                           │
│  ● Not all providers support seed                                │
│  ● Even with seed, results may vary slightly due to              │
│    hardware differences, model updates, or batching              │
│  ● OpenAI provides a system_fingerprint to track model versions  │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

#### When to Use Seed

```
✅ Useful for:
   ● Unit testing LLM outputs
   ● Debugging — reproduce exact same response
   ● A/B testing — ensure same starting conditions
   ● Regression testing — detect if model behavior changed
   ● Research — reproducible experiments

❌ NOT useful for:
   ● Production chat (you want some variety)
   ● Creative applications
   ● When you WANT different outputs
```

#### Seed in Code

```python
# OpenAI — reproducible output
response = client.chat.completions.create(
    model="gpt-4.1",
    messages=[{"role": "user", "content": "Explain AI"}],
    seed=42,
    temperature=0.0  # Combine with T=0 for maximum reproducibility
)

# Check the system fingerprint (tells you if the model version changed)
print(response.system_fingerprint)
# "fp_abc123"  ← If this changes, outputs might differ even with same seed
```

---

### 11. Frequency Penalty & Presence Penalty

> **Control how much the model avoids repeating tokens.**

These are available primarily on OpenAI models.

```
┌──────────────────────────────────────────────────────────────────┐
│       FREQUENCY PENALTY vs PRESENCE PENALTY                       │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  FREQUENCY PENALTY (range: -2.0 to 2.0)                          │
│  ──────────────────────────────────────                          │
│  Reduces the likelihood of a token proportional to               │
│  HOW MANY TIMES it has already appeared.                         │
│                                                                   │
│  The more times "the" appears → the more it's penalized.         │
│                                                                   │
│  Modified logit = logit - frequency_penalty × count(token)       │
│                                                                   │
│  0.0  → No penalty (default)                                     │
│  0.5  → Mild discouragement of repetition                        │
│  1.0  → Strong discouragement                                    │
│  2.0  → Very strong (may cause unnatural text)                   │
│                                                                   │
│  ────────────────────────────────────────────────────────────    │
│                                                                   │
│  PRESENCE PENALTY (range: -2.0 to 2.0)                           │
│  ─────────────────────────────────────                           │
│  Reduces the likelihood of a token based on                      │
│  WHETHER it has appeared AT ALL (binary).                         │
│                                                                   │
│  If "pizza" has appeared once or 100 times →                     │
│  the penalty is the SAME.                                        │
│                                                                   │
│  Modified logit = logit - presence_penalty × (1 if appeared)     │
│                                                                   │
│  0.0  → No penalty (default)                                     │
│  0.5  → Mild encouragement of new topics                         │
│  1.0  → Strongly encourages new topics                           │
│  2.0  → Very strongly pushes for novelty                         │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

#### When to Use Penalties

```
Use FREQUENCY PENALTY when:
────────────────────────────
● Model keeps repeating the same phrases
● Output has redundant sentences
● You want more vocabulary diversity within a response

Use PRESENCE PENALTY when:
──────────────────────────
● You want the model to explore new topics
● Conversations are getting stuck on the same subject
● You want brainstorming to cover diverse ideas
```

```python
# Reduce repetition in creative writing
response = client.chat.completions.create(
    model="gpt-4.1",
    messages=[{"role": "user", "content": "Write a long essay about AI"}],
    frequency_penalty=0.5,  # Discourage word repetition
    presence_penalty=0.3    # Encourage topic diversity
)
```

---

### 12. Response Format / JSON Mode

> **Force the model to output valid JSON.**

```
┌──────────────────────────────────────────────────────────────────┐
│              STRUCTURED OUTPUT MODES                              │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  DEFAULT MODE:                                                    │
│  ─────────────                                                   │
│  Model outputs free-form text.                                    │
│  May or may not be valid JSON even if you ask for it.            │
│                                                                   │
│  JSON MODE:                                                       │
│  ──────────                                                      │
│  Model is FORCED to output valid JSON.                           │
│  Will not produce plain text or markdown.                         │
│                                                                   │
│  JSON SCHEMA MODE (Structured Outputs):                          │
│  ───────────────────────────────────────                         │
│  Model output MUST conform to a specific JSON schema.            │
│  Guarantees exact field names, types, and structure.              │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

```python
# OpenAI JSON Mode
response = client.chat.completions.create(
    model="gpt-4.1",
    messages=[
        {"role": "system", "content": "Output valid JSON."},
        {"role": "user", "content": "Extract: name, email, phone from this text..."}
    ],
    response_format={"type": "json_object"}
)

# OpenAI Structured Outputs (JSON Schema)
response = client.chat.completions.create(
    model="gpt-4.1",
    messages=[{"role": "user", "content": "Extract invoice details..."}],
    response_format={
        "type": "json_schema",
        "json_schema": {
            "name": "invoice",
            "schema": {
                "type": "object",
                "properties": {
                    "vendor": {"type": "string"},
                    "date": {"type": "string"},
                    "amount": {"type": "number"},
                    "line_items": {
                        "type": "array",
                        "items": {
                            "type": "object",
                            "properties": {
                                "description": {"type": "string"},
                                "quantity": {"type": "integer"},
                                "price": {"type": "number"}
                            }
                        }
                    }
                },
                "required": ["vendor", "date", "amount"]
            }
        }
    }
)
```

---

## The Complete Parameter Reference Table

```
┌──────────────────────┬─────────────┬──────────────┬───────────────────────────────┐
│ Parameter            │ Range       │ Default      │ What It Controls              │
├──────────────────────┼─────────────┼──────────────┼───────────────────────────────┤
│ model                │ String      │ (required)   │ Which model to use            │
│ temperature          │ 0.0 - 2.0   │ 1.0          │ Randomness / creativity       │
│ top_p                │ 0.0 - 1.0   │ 1.0          │ Cumulative probability cutoff │
│ top_k                │ 1 - vocab   │ Model-specific│ Fixed candidate count         │
│ max_tokens           │ 1 - max     │ Model-specific│ Maximum output length         │
│ stop                 │ String[]    │ None         │ Stop generation triggers      │
│ seed                 │ Integer     │ None         │ Reproducibility               │
│ frequency_penalty    │ -2.0 - 2.0  │ 0.0          │ Penalize repeated tokens      │
│ presence_penalty     │ -2.0 - 2.0  │ 0.0          │ Encourage new topics          │
│ response_format      │ Object      │ text         │ Force JSON / schema output    │
│ n                    │ 1 - 128     │ 1            │ Number of completions         │
│ logprobs             │ Boolean     │ false        │ Return token log probs        │
│ stream               │ Boolean     │ false        │ Stream response tokens        │
└──────────────────────┴─────────────┴──────────────┴───────────────────────────────┘
```

---

## Parameter Importance Ranking

For most AI applications, parameters matter in this order:

```
┌──────────────────────────────────────────────────────────────────┐
│              PARAMETER IMPORTANCE (Most → Least)                 │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ⭐⭐⭐⭐⭐  MODEL                                                    │
│           Biggest impact on capability.                           │
│           GPT-4.1 vs GPT-4.1-nano is a MASSIVE difference.      │
│                                                                   │
│  ⭐⭐⭐⭐⭐  CONTEXT WINDOW                                           │
│           Determines how much information the model can see.     │
│           4K vs 1M is the difference between a sentence          │
│           and an entire book.                                     │
│                                                                   │
│  ⭐⭐⭐⭐   TEMPERATURE                                               │
│           Controls consistency vs creativity.                     │
│           T=0 vs T=1.0 can completely change output character.   │
│                                                                   │
│  ⭐⭐⭐⭐   MAX OUTPUT TOKENS                                         │
│           Controls response length AND cost.                     │
│           Setting this too low → truncated responses.            │
│           Setting this too high → wasted money.                  │
│                                                                   │
│  ⭐⭐⭐    TOP-P                                                      │
│           Fine-tunes diversity beyond temperature.               │
│           Most engineers leave at 0.95 or 1.0.                   │
│                                                                   │
│  ⭐⭐⭐    RESPONSE FORMAT (JSON MODE)                                │
│           Critical for structured data extraction.               │
│           Without it, parsing outputs is unreliable.             │
│                                                                   │
│  ⭐⭐     STOP SEQUENCES                                             │
│           Useful for structured prompts and agents.              │
│           Not needed for simple chat applications.               │
│                                                                   │
│  ⭐⭐     FREQUENCY / PRESENCE PENALTY                               │
│           Helps with repetitive outputs.                         │
│           Rarely needed with modern models.                      │
│                                                                   │
│  ⭐      SEED                                                        │
│           Mainly for testing and debugging.                      │
│           Not used in production serving.                        │
│                                                                   │
│  ⭐      TOP-K                                                       │
│           Not available on OpenAI.                               │
│           Rarely tuned — top-p is usually preferred.             │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## The Mathematics Behind Sampling

For those who want to understand the exact math:

### Step-by-Step Sampling Process

```
Given vocabulary V = {token_1, token_2, ..., token_N}
where N = vocabulary size (e.g., 128,256 for LLaMA 3.1)

Step 1: MODEL produces logits
──────────────────────────────
   logits = [z_1, z_2, ..., z_N]

   These are raw, unnormalized scores.
   Higher logit = model thinks this token is more likely.


Step 2: TEMPERATURE scaling
───────────────────────────
   scaled_logits[i] = logits[i] / T

   If T < 1: Amplifies differences (peaks get peakier)
   If T > 1: Compresses differences (distribution flattens)
   If T = 1: No change


Step 3: SOFTMAX (convert to probabilities)
──────────────────────────────────────────
   P(token_i) = exp(scaled_logits[i]) / Σ_j exp(scaled_logits[j])

   Now all probabilities sum to 1.0


Step 4: TOP-K filtering (if enabled)
─────────────────────────────────────
   Sort tokens by probability (descending).
   Keep only the top K tokens.
   Set probability of all other tokens to 0.


Step 5: TOP-P filtering (if enabled)
─────────────────────────────────────
   Sort remaining tokens by probability (descending).
   Accumulate probabilities from top.
   Keep tokens until cumulative probability ≥ p.
   Set probability of all other tokens to 0.


Step 6: RENORMALIZATION
───────────────────────
   Redistribute probabilities so remaining tokens sum to 1.0.

   P'(token_i) = P(token_i) / Σ_remaining P(token_j)


Step 7: SAMPLING
────────────────
   Draw one token from the renormalized distribution.
   
   (If T ≈ 0, this is effectively argmax — greedy decoding)
```

### Worked Example

```
Vocabulary (simplified): {pizza, burger, pasta, sushi, rice}
Logits:                   [4.0,   3.5,    2.5,   2.0,   1.0]

═══════════════════════════════════════════════════════════════

Step 2: Temperature = 0.5
   scaled = [8.0, 7.0, 5.0, 4.0, 2.0]

Step 3: Softmax
   P = [73.1%, 22.1%, 3.6%, 0.9%, 0.0%]
   (approximately)

Step 4: Top-k = 3
   Keep: {pizza: 73.1%, burger: 22.1%, pasta: 3.6%}
   Remove: {sushi: 0%, rice: 0%}

Step 5: Top-p = 0.90
   Cumulative: pizza=73.1%, pizza+burger=95.2% ≥ 90%
   Keep: {pizza: 73.1%, burger: 22.1%}
   Remove: {pasta: 0%}

Step 6: Renormalize
   Total = 73.1 + 22.1 = 95.2
   pizza: 73.1/95.2 = 76.8%
   burger: 22.1/95.2 = 23.2%

Step 7: Sample
   Roll random number [0, 1)
   If < 0.768 → "pizza"
   If ≥ 0.768 → "burger"

═══════════════════════════════════════════════════════════════
```

---

## Configuration Recipes for Real Applications

### Recipe 1: SQL Generator

```python
# GOAL: Deterministic, correct SQL queries

llm = ChatOpenAI(
    model="gpt-4.1",          # Strong reasoning for complex queries
    temperature=0.0,           # ZERO randomness — same query every time
    top_p=1.0,                 # No filtering (T=0 already handles it)
    max_tokens=500,            # SQL queries are typically short
    stop=["```", ";;\n"],      # Stop after the query ends
    seed=42,                   # Reproducible for testing
    response_format={"type": "json_object"}  # If wrapping SQL in JSON
)
```

```
Why these settings:
● T=0    → Same input always produces same SQL
● Low max → SQL is short, save money
● Seed   → Can unit-test outputs reliably
```

---

### Recipe 2: Creative Story Generator

```python
# GOAL: Diverse, engaging, creative stories

llm = ChatOpenAI(
    model="gpt-4.1",          # Good language quality
    temperature=0.9,           # High creativity
    top_p=0.95,                # Allow diverse word choices
    max_tokens=3000,           # Stories need room
    frequency_penalty=0.3,     # Reduce word repetition
    presence_penalty=0.3,      # Encourage exploring new themes
)
```

```
Why these settings:
● T=0.9     → Diverse and creative word choices
● top_p=0.95 → Broad candidate pool
● Penalties  → Prevent repetitive prose
● High max   → Stories need length
```

---

### Recipe 3: Customer Support Chatbot

```python
# GOAL: Consistent, concise, helpful answers

llm = ChatOpenAI(
    model="gpt-4.1-mini",     # Cost-effective for high volume
    temperature=0.2,           # Mostly consistent, slightly natural
    top_p=1.0,                 # Let temperature handle diversity
    max_tokens=400,            # Keep responses concise
)
```

```
Why these settings:
● Mini model  → 50K requests/day needs to be cheap
● T=0.2       → Consistent but not robotic
● Low max     → Users want quick answers, not essays
```

---

### Recipe 4: AI Coding Assistant

```python
# GOAL: Reliable code generation with explanations

llm = ChatOpenAI(
    model="gpt-4.1",          # Strong coding ability
    temperature=0.1,           # Near-deterministic for code
    top_p=0.95,                # Slight diversity for explanations
    max_tokens=4000,           # Code + explanation needs room
    stop=["```\n\n"],          # Stop after code block if needed
)
```

```
Why these settings:
● T=0.1   → Code must be correct and consistent
● High max → Full function/class generation needs space
● top_p   → Allows some variety in explanations
```

---

### Recipe 5: Data Extraction (Invoices, Receipts)

```python
# GOAL: Precise field extraction into JSON

llm = ChatOpenAI(
    model="gpt-4.1-mini",     # Good extraction, reasonable cost
    temperature=0.0,           # Must be deterministic
    max_tokens=500,            # JSON output is compact
    response_format={
        "type": "json_schema",
        "json_schema": {
            "name": "invoice_extraction",
            "schema": {
                "type": "object",
                "properties": {
                    "vendor": {"type": "string"},
                    "date": {"type": "string"},
                    "total": {"type": "number"},
                    "items": {"type": "array", "items": {"type": "object"}}
                },
                "required": ["vendor", "date", "total"]
            }
        }
    }
)
```

```
Why these settings:
● T=0          → Same invoice always extracts same fields
● JSON schema  → Guarantees valid, parseable output
● Low max      → Extraction output is small
```

---

### Recipe 6: Research Assistant (Long Documents)

```python
# GOAL: Analyze long papers, provide detailed answers

llm = ChatOpenAI(
    model="gpt-4.1",          # 1M context for long documents
    temperature=0.3,           # Factual but naturally phrased
    top_p=0.9,                 # Moderate diversity
    max_tokens=4000,           # Detailed analysis needs room
)
```

```
Why these settings:
● GPT-4.1  → 1M context handles entire papers
● T=0.3    → Factual responses with slight variation
● High max → Research answers are often detailed
```

---

### Recipe 7: AI Agent (Tool Calling)

```python
# GOAL: Reliable decision-making and tool calling

llm = ChatOpenAI(
    model="gpt-4.1",          # Strong tool calling support
    temperature=0.0,           # Deterministic tool selection
    max_tokens=1000,           # Tool calls are typically short
)

# Agent uses this LLM to decide WHICH tool to call
# and with WHAT arguments

# Example tool calls the agent might make:
# {"tool": "search_web", "query": "latest AI news"}
# {"tool": "send_email", "to": "user@example.com", "body": "..."}
```

```
Why these settings:
● T=0    → Tool selection must be reliable and consistent
● GPT-4.1 → Best-in-class function calling
● Low max → Tool call JSON is compact
```

---

### Recipe 8: Multi-Language Translation

```python
# GOAL: Accurate translation with natural phrasing

llm = ChatOpenAI(
    model="gpt-4.1",          # Strong multilingual
    temperature=0.3,           # Mostly accurate, slightly natural
    max_tokens=2000,           # Translations can be long
)
```

---

### Recipe 9: Meeting Summarizer

```python
# GOAL: Concise, actionable meeting summaries

llm = ChatOpenAI(
    model="gpt-4.1-mini",     # Fast and cost-effective
    temperature=0.2,           # Consistent summaries
    max_tokens=800,            # Summaries should be concise
)
```

---

### Recipe 10: Brainstorming / Idea Generator

```python
# GOAL: Maximum creativity and diverse ideas

llm = ChatOpenAI(
    model="gpt-4.1",          # Good at creative tasks
    temperature=1.0,           # Maximum useful creativity
    top_p=0.95,                # Wide candidate pool
    max_tokens=2000,           # Room for multiple ideas
    frequency_penalty=0.5,     # Strongly discourage repetition
    presence_penalty=0.5,      # Strongly encourage new topics
)
```

---

## Provider-Specific Parameter Support

Not all providers support all parameters:

```
┌─────────────────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
│ Parameter           │ OpenAI   │ Anthropic│ Google   │ Mistral  │ vLLM     │
├─────────────────────┼──────────┼──────────┼──────────┼──────────┼──────────┤
│ temperature         │ ✅        │ ✅        │ ✅        │ ✅        │ ✅        │
│ top_p               │ ✅        │ ✅        │ ✅        │ ✅        │ ✅        │
│ top_k               │ ❌        │ ✅        │ ✅        │ ✅        │ ✅        │
│ max_tokens          │ ✅        │ ✅        │ ✅        │ ✅        │ ✅        │
│ stop                │ ✅ (4 max)│ ✅        │ ✅        │ ✅        │ ✅        │
│ seed                │ ✅        │ ❌        │ ✅        │ ✅        │ ✅        │
│ frequency_penalty   │ ✅        │ ❌        │ ✅        │ ❌        │ ✅        │
│ presence_penalty    │ ✅        │ ❌        │ ✅        │ ❌        │ ✅        │
│ response_format     │ ✅ JSON   │ ❌ (tool) │ ✅        │ ✅        │ ✅        │
│ structured_outputs  │ ✅ Schema │ ❌ (tool) │ ✅        │ Partial  │ ✅        │
│ logprobs            │ ✅        │ ❌        │ ❌        │ ❌        │ ✅        │
│ n (multiple outputs)│ ✅        │ ❌        │ ✅        │ ❌        │ ✅        │
│ stream              │ ✅        │ ✅        │ ✅        │ ✅        │ ✅        │
└─────────────────────┴──────────┴──────────┴──────────┴──────────┴──────────┘

Note: Anthropic achieves structured output via tool_use with a defined schema,
not via a dedicated response_format parameter.
```

---

## Common Mistakes & Anti-Patterns

```
┌──────────────────────────────────────────────────────────────────┐
│              TOP 10 PARAMETER CONFIGURATION MISTAKES              │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ❌ MISTAKE 1: Using temperature=1.0 for factual tasks           │
│     Fix: Use T=0.0 for SQL, code, data extraction, classification│
│                                                                   │
│  ❌ MISTAKE 2: Not setting max_tokens                            │
│     Fix: Always set it. Too high = wasted cost.                  │
│          Too low = truncated responses.                           │
│                                                                   │
│  ❌ MISTAKE 3: Setting temperature AND top_p to extreme values   │
│     Fix: Tune one OR the other. Not both aggressively.           │
│                                                                   │
│  ❌ MISTAKE 4: Using the same configuration for all tasks        │
│     Fix: SQL ≠ chatbot ≠ creative writing. Each needs           │
│          different parameters.                                    │
│                                                                   │
│  ❌ MISTAKE 5: Ignoring the difference between max_tokens        │
│     and context window                                           │
│     Fix: Context window = input + output total.                  │
│          max_tokens = output only.                               │
│                                                                   │
│  ❌ MISTAKE 6: Not using JSON mode for structured extraction     │
│     Fix: Use response_format={"type": "json_object"} when you   │
│          need parseable JSON output.                             │
│                                                                   │
│  ❌ MISTAKE 7: Assuming seed guarantees identical outputs        │
│     Fix: Seed improves reproducibility but doesn't guarantee it. │
│          Model updates and infrastructure changes can cause      │
│          differences.                                            │
│                                                                   │
│  ❌ MISTAKE 8: Using high temperature for agents/tool calling    │
│     Fix: Agents need T=0 for reliable tool selection.            │
│          Random tool calls = broken workflows.                   │
│                                                                   │
│  ❌ MISTAKE 9: Never testing different parameter combinations    │
│     Fix: Run the same 50 prompts with 3-4 configurations.       │
│          Measure accuracy, quality, cost. Then choose.           │
│                                                                   │
│  ❌ MISTAKE 10: Copying settings from tutorials without thinking │
│     Fix: Tutorials use generic settings. YOUR application has    │
│          specific requirements. Start from a recipe, then tune.  │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## How AI Engineers Tune Parameters in Production

### The Tuning Process

```
Step 1: Start with a sensible default
          │
          │  (Use a recipe from this document)
          ▼
Step 2: Create an evaluation dataset
          │
          │  50-100 representative prompts with expected outputs
          ▼
Step 3: Run baseline experiment
          │
          │  Record accuracy, quality, latency, cost
          ▼
Step 4: Vary ONE parameter at a time
          │
          │  Temperature: try 0.0, 0.2, 0.5, 0.7, 1.0
          │  Max tokens: try 200, 500, 1000, 2000
          │  Top-p: try 0.8, 0.9, 0.95, 1.0
          ▼
Step 5: Compare results
          │
          │  Which configuration gives best accuracy at acceptable cost?
          ▼
Step 6: Deploy winning configuration
          │
          ▼
Step 7: Monitor in production
          │
          │  Track quality, cost, user satisfaction
          │  Re-tune when model updates or requirements change
          ▼
        Iterate
```

### The Decision Order

```
When configuring an LLM for a new application:

1. Choose PROVIDER       → Where will this run?
2. Choose MODEL          → What capability do I need?
3. Check CONTEXT WINDOW  → Is it big enough for my inputs?
4. Set MAX OUTPUT TOKENS → How long should responses be?
5. Set TEMPERATURE       → How consistent vs creative?
6. Optionally tune TOP-P → Fine-grained diversity control
7. Add STOP SEQUENCES    → If using structured prompts
8. Enable JSON MODE      → If output must be structured
9. Set SEED              → If testing reproducibility
10. Evaluate with REAL PROMPTS → Does it actually work well?
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────────┐
│              LLM PARAMETER QUICK REFERENCE                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  TEMPERATURE:                                                        │
│    0.0  → Deterministic (code, SQL, extraction, classification)     │
│    0.2  → Consistent (customer support, Q&A, agents)                │
│    0.5  → Balanced (general chat, summaries)                        │
│    0.8  → Creative (stories, marketing, brainstorming)              │
│    1.0+ → Experimental (art, poetry — often too random)             │
│                                                                      │
│  TOP-P:                                                              │
│    0.5  → Very focused (few candidates)                             │
│    0.9  → Balanced (good default)                                   │
│    0.95 → Slightly diverse (industry default)                       │
│    1.0  → No filtering (let temperature handle it)                  │
│                                                                      │
│  MAX TOKENS:                                                         │
│    100-300    → Short answers, classifications                      │
│    500-1000   → Standard responses, explanations                    │
│    2000-4000  → Detailed analysis, code generation                  │
│    8000-16000 → Full reports, entire code files                     │
│                                                                      │
│  GOLDEN RULES:                                                       │
│    ● There is no universal "best" configuration                     │
│    ● Match parameters to YOUR application's goals                   │
│    ● Tune ONE parameter at a time                                   │
│    ● Always test with real prompts before deploying                 │
│    ● Temperature and top_p: modify one, not both aggressively       │
│    ● T=0 for anything that needs consistency                        │
│    ● JSON mode for anything that needs structure                    │
│                                                                      │
│  COST TIP:                                                           │
│    ● You pay for output tokens → set max_tokens wisely              │
│    ● Lower max_tokens = lower maximum cost per request              │
│    ● The model often generates fewer tokens than the max            │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Connecting to Your Learning Roadmap

```
✅ COMPLETED: Transformer Architecture
✅ COMPLETED: Complete LLM Development Pipeline
✅ COMPLETED: LLM Model Selection
✅ COMPLETED: LLM Inference Parameters & Configuration (this document)

NEXT RECOMMENDED TOPICS:
────────────────────────

1. Prompt Engineering
   └─ System prompts, few-shot, chain-of-thought
   └─ How prompt design interacts with temperature/top-p
   └─ Prompt templates and structured prompting

2. RAG (Retrieval-Augmented Generation)
   └─ Vector databases (Pinecone, Chroma, Weaviate)
   └─ Embedding models and chunking strategies
   └─ When to use RAG vs long context

3. LangChain & LangGraph
   └─ Chains, agents, tools
   └─ Memory and conversation management
   └─ Graph-based agent workflows

4. Agents & Tool Calling
   └─ Function calling patterns
   └─ Multi-step agent workflows
   └─ ReAct, Plan-and-Execute patterns

5. Evaluation & Monitoring
   └─ LLM-as-judge evaluation
   └─ Production monitoring and observability
   └─ A/B testing LLM configurations
```

---

> **Remember:** Model selection chooses the brain. Inference parameters tune how that brain thinks. Both are engineering decisions that should be driven by your application's specific requirements, not by defaults or guesswork.

---

*Document Version: 1.0 | Last Updated: August 2026*
