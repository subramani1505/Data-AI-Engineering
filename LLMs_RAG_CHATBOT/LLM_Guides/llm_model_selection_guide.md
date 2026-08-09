# LLM Model Selection Guide — How AI Engineers Choose the Right Model

> **Author:** Subramani V  
> **Created:** August 2026  
> **Purpose:** Production-level reference for selecting the right LLM for any AI application  
> **Prerequisite:** Understanding of LLM architecture and the LLM development pipeline

---

## Table of Contents

1. [Why Model Selection Matters](#why-model-selection-matters)
2. [The Vehicle Analogy](#the-vehicle-analogy)
3. [The Model Selection Process](#the-model-selection-process)
4. [The 10 Major Selection Parameters](#the-10-major-selection-parameters)
   - [1. Accuracy](#1-accuracy)
   - [2. Reasoning Ability](#2-reasoning-ability)
   - [3. Context Window](#3-context-window)
   - [4. Cost](#4-cost)
   - [5. Latency (Speed)](#5-latency-speed)
   - [6. Model Size](#6-model-size)
   - [7. Domain Knowledge](#7-domain-knowledge)
   - [8. Multimodal Support](#8-multimodal-support)
   - [9. Tool Calling & Structured Output](#9-tool-calling--structured-output)
   - [10. Deployment Constraints](#10-deployment-constraints)
5. [Complete Model Landscape (2024–2026)](#complete-model-landscape-20242026)
6. [Head-to-Head Model Comparison](#head-to-head-model-comparison)
7. [Benchmark Guide — What the Scores Mean](#benchmark-guide--what-the-scores-mean)
8. [Cost Analysis — Real Numbers](#cost-analysis--real-numbers)
9. [Real-World Case Studies](#real-world-case-studies)
10. [The Decision Matrix Framework](#the-decision-matrix-framework)
11. [Open Source vs Closed Source — When to Use Which](#open-source-vs-closed-source--when-to-use-which)
12. [Quantization & Model Size Trade-offs](#quantization--model-size-trade-offs)
13. [Multi-Model Architectures](#multi-model-architectures)
14. [Common Mistakes in Model Selection](#common-mistakes-in-model-selection)
15. [Quick Reference Decision Flowchart](#quick-reference-decision-flowchart)

---

## Why Model Selection Matters

Many AI engineers learn LangChain, LangGraph, RAG, and Agents — but they don't know **why** they choose one model over another.

```
❌ Wrong Thinking:
   "GPT-4 is the best, so I'll always use GPT-4."

✅ Right Thinking:
   "What does my application need? Which model fits those needs
    at the best cost-performance trade-off?"
```

As an AI Engineer, you should think of an LLM the way you think of a **database** or a **programming language** — you choose it because it fits the requirements, not because it's the most popular.

### The Consequences of Wrong Model Selection

```
Choose a model that's TOO POWERFUL:
─────────────────────────────────
   ● Wasted money (10× or 100× higher cost)
   ● Slower responses than necessary
   ● Overengineered solution
   ● Budget burns through quickly

Choose a model that's TOO WEAK:
──────────────────────────────
   ● Poor accuracy → users lose trust
   ● Can't handle required context length
   ● Missing capabilities (no tool calling, no vision)
   ● Constant errors that require human review

Choose a model with WRONG CONSTRAINTS:
────────────────────────────────────
   ● Data privacy violation (sending sensitive data to cloud API)
   ● Regulatory non-compliance
   ● Vendor lock-in
   ● Uncontrollable costs at scale
```

---

## The Vehicle Analogy

Choosing an LLM is exactly like choosing a vehicle.

```
┌──────────────────────────────────────────────────────────────┐
│              CHOOSING A VEHICLE                               │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│   🚲 Bicycle        → Deliver food nearby                    │
│   🚗 Sedan          → Family trip                             │
│   🚛 Truck          → Construction materials                  │
│   🏎️ Sports Car     → Racing                                  │
│   🚌 Bus            → Transport 50 people                     │
│   ✈️ Airplane       → Cross continents                        │
│                                                               │
│   None is "best." Each is best for a particular job.          │
│                                                               │
├──────────────────────────────────────────────────────────────┤
│              CHOOSING AN LLM                                  │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│   🤖 Small Model (1-3B)   → Simple classification, extraction│
│   🤖 Medium Model (7-13B) → General chat, summarization      │
│   🤖 Large Model (70B+)   → Complex reasoning, coding        │
│   🤖 Frontier Model       → Research, critical decisions     │
│   🤖 Specialized Model    → Domain-specific tasks             │
│   🤖 Multimodal Model     → Vision + text workflows          │
│                                                               │
│   None is "best." Each is best for a particular job.          │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

---

## The Model Selection Process

Model selection is NOT the first step. It's one of the **last** steps in system design.

```
Step 1: Business Problem
          │
          │  "What problem are we solving?"
          ▼
Step 2: Functional Requirements
          │
          │  "What should the system do?"
          ▼
Step 3: Technical Requirements
          │
          │  "What accuracy, speed, cost, and scale do we need?"
          ▼
Step 4: Constraint Analysis
          │
          │  "Can data leave the company?"
          │  "What's the budget?"
          │  "What infrastructure do we have?"
          ▼
Step 5: Shortlist Candidate Models
          │
          │  "Which 3-5 models could work?"
          ▼
Step 6: Evaluate on YOUR Data
          │
          │  "Run candidates on real examples"
          │  "Measure accuracy, latency, cost"
          ▼
Step 7: Choose the Best Trade-off
          │
          │  "Not the best model — the best FIT"
          ▼
Step 8: Monitor in Production
          │
          │  "Is it still the right choice?"
          │  "New models released?"
          ▼
        Iterate
```

### The Key Questions to Ask

```
┌────────────────────────────────────────────────────────────────┐
│           MODEL SELECTION QUESTIONNAIRE                        │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  1. What problem are we solving?                               │
│     → Classification? Generation? Extraction? Reasoning?       │
│                                                                │
│  2. What accuracy is needed?                                   │
│     → Life-critical (medical)? Business-critical? Nice-to-have?│
│                                                                │
│  3. How much will it cost?                                     │
│     → Budget per month? Cost per 1M tokens? Users × requests?  │
│                                                                │
│  4. How fast should it respond?                                │
│     → Real-time (<1s)? Interactive (<5s)? Batch (minutes)?     │
│                                                                │
│  5. Will it use tools?                                         │
│     → API calls? Database queries? Web search?                 │
│                                                                │
│  6. Will it use RAG?                                           │
│     → How many chunks? How large? What retrieval strategy?     │
│                                                                │
│  7. Can data leave the company?                                │
│     → Cloud OK? On-premises required? Air-gapped?              │
│                                                                │
│  8. How many users?                                            │
│     → 10? 1,000? 1,000,000? Concurrent requests?              │
│                                                                │
│  9. What modalities are needed?                                │
│     → Text only? Images? Audio? Video? PDFs?                   │
│                                                                │
│  10. What's the input/output pattern?                          │
│      → Short Q&A? Long document analysis? Code generation?     │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## The 10 Major Selection Parameters

```
                        Choose an LLM
                             │
        ┌────────┬───────┬───┴───┬────────┬──────────┐
        │        │       │       │        │          │
   Accuracy  Reasoning Context  Cost   Latency   Model Size
        │        │       │       │        │          │
        │        │       │       │        │          │
   Domain    Multimodal  Tool  Deployment
   Knowledge  Support  Calling Constraints
```

---

### 1. Accuracy

> **"How correct are the answers?"**

This is the **most important** parameter for most applications.

```
┌──────────────────────────────────────────────────────────────┐
│                    ACCURACY SPECTRUM                           │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  CRITICAL (must be near-perfect):                             │
│  ─────────────────────────────                                │
│  🏥 Medical diagnosis                                         │
│  ⚖️  Legal analysis                                            │
│  💰 Financial advice                                           │
│  🔬 Scientific research                                       │
│  🛡️ Security analysis                                         │
│                                                               │
│  HIGH (should be very good):                                  │
│  ────────────────────────                                     │
│  💻 Code generation                                            │
│  📊 Data extraction                                            │
│  📝 Technical writing                                          │
│  🎓 Education/tutoring                                         │
│                                                               │
│  MODERATE (good enough is fine):                              │
│  ────────────────────────────                                 │
│  💬 Customer support chatbot                                   │
│  📱 Social media captions                                      │
│  ✉️  Email drafts                                               │
│  🎨 Creative writing                                           │
│  📋 Meeting summaries                                          │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

#### The Accuracy-Cost Trade-off

```
Accuracy
   │
   │         ● Frontier Models (GPT-4.1, Claude Opus, Gemini Ultra)
   │        ╱
   │       ╱
   │      ●  Large Models (GPT-4.1-mini, Claude Sonnet, LLaMA 3.1 70B)
   │     ╱
   │    ╱
   │   ●  Medium Models (GPT-4.1-nano, LLaMA 3.1 8B, Mistral 7B)
   │  ╱
   │ ╱
   │●  Small Models (Phi-3-mini, Gemma 2B, TinyLlama)
   │
   └──────────────────────────────────────────── Cost
   Low                                          High
```

#### Rule

```
Higher-risk applications → Higher accuracy models → Higher cost (justified)
Lower-risk applications → Good-enough models    → Lower cost (optimized)
```

---

### 2. Reasoning Ability

> **"Can the model think through complex, multi-step problems?"**

Not all tasks need deep reasoning.

```
LOW REASONING NEEDED:                    HIGH REASONING NEEDED:
──────────────────────                   ──────────────────────
● Translate a sentence                   ● Solve a math proof
● Summarize an email                     ● Debug complex code
● Extract a name from text               ● Plan a multi-step workflow
● Classify sentiment                     ● Analyze a legal contract
● Generate a greeting                    ● Design a system architecture
● Auto-complete text                     ● Write an algorithm
● Format data                            ● Reason about cause and effect
```

#### Reasoning Tiers

```
┌───────────────────────────────────────────────────────────────────┐
│                    REASONING CAPABILITY TIERS                      │
├───────────────────────────────────────────────────────────────────┤
│                                                                    │
│  TIER 1 — Frontier Reasoning:                                      │
│  ──────────────────────────                                        │
│  Models: o3, o4-mini, Claude Opus 4 (thinking), Gemini 2.5 Pro    │
│  Capabilities:                                                     │
│    ● Multi-step mathematical proofs                                │
│    ● Complex code generation + debugging                           │
│    ● Agentic planning and execution                                │
│    ● Scientific reasoning                                          │
│    ● Long chains of logical deduction                              │
│                                                                    │
│  TIER 2 — Strong Reasoning:                                        │
│  ────────────────────────                                          │
│  Models: GPT-4.1, Claude Sonnet 4, Gemini 2.5 Flash               │
│  Capabilities:                                                     │
│    ● General coding tasks                                          │
│    ● Moderate math problems                                        │
│    ● Instruction following with nuance                             │
│    ● Multi-step Q&A                                                │
│                                                                    │
│  TIER 3 — Basic Reasoning:                                         │
│  ───────────────────────                                           │
│  Models: GPT-4.1-mini, LLaMA 3.1 8B, Mistral 7B, Phi-3           │
│  Capabilities:                                                     │
│    ● Simple coding tasks                                           │
│    ● Straightforward Q&A                                           │
│    ● Summarization                                                 │
│    ● Classification                                                │
│                                                                    │
│  TIER 4 — Pattern Matching (Minimal Reasoning):                    │
│  ──────────────────────────────────────────────                    │
│  Models: GPT-4.1-nano, Gemma 2B, TinyLlama                        │
│  Capabilities:                                                     │
│    ● Simple extraction                                             │
│    ● Basic text completion                                         │
│    ● Keyword-based responses                                       │
│    ● Template filling                                              │
│                                                                    │
└───────────────────────────────────────────────────────────────────┘
```

---

### 3. Context Window

> **"How much information can the model consider in one request?"**

The context window determines the maximum amount of text (measured in tokens) the model can process at once — including both the input you send AND the output it generates.

```
Context Window Size Comparison:

Model                    Context Window     Approximate Equivalent
──────────────────────   ──────────────     ───────────────────────
GPT-4.1                  1,047,576 tokens   ~1,500 pages
Gemini 2.5 Pro           1,048,576 tokens   ~1,500 pages
Claude Opus 4 / Sonnet 4 200,000 tokens     ~300 pages
LLaMA 3.1 (all sizes)    128,000 tokens     ~180 pages
Mistral Large            128,000 tokens     ~180 pages
GPT-4o                   128,000 tokens     ~180 pages
Mistral 7B               32,000 tokens      ~45 pages
LLaMA 2                  4,096 tokens       ~6 pages
GPT-3                    2,048 tokens       ~3 pages

1 page ≈ 500-700 tokens (English)
```

#### When Context Window Matters

```
SHORT CONTEXT IS FINE:                    LONG CONTEXT IS CRITICAL:
──────────────────────                    ────────────────────────
● Single question Q&A                    ● Analyzing legal contracts (100+ pages)
● Simple chatbot (few turns)             ● Processing entire codebases
● One-paragraph summarization            ● Long chat history (1000+ messages)
● Classification tasks                   ● Research paper analysis
● Simple extraction                      ● Book summarization
                                          ● Multi-document RAG with many chunks
                                          ● Repository-level code understanding
```

#### Context Window vs RAG

```
When you need to process information beyond the context window:

Option 1: Use a model with a larger context window
   Pro:  Simple — just send everything
   Con:  Expensive (you pay for every token)
   Con:  Accuracy can degrade for very long contexts ("lost in the middle")

Option 2: Use RAG (Retrieval-Augmented Generation)
   Pro:  Cost-effective (only retrieve relevant chunks)
   Pro:  Can access unlimited knowledge base
   Con:  Retrieval quality affects output quality
   Con:  More complex architecture

Option 3: Both (Recommended for production)
   Use RAG to retrieve the most relevant chunks
   Then use a model with sufficient context to process them
```

---

### 4. Cost

> **"How much does each API call / token / request cost?"**

For production systems serving thousands or millions of users, cost is often the **deciding factor**.

#### Pricing Models

```
┌──────────────────────────────────────────────────────────────────┐
│                      LLM PRICING MODELS                          │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  1. PAY-PER-TOKEN (API-based)                                     │
│     ──────────────────────────                                    │
│     You pay per input token + per output token                    │
│     Example: $2.00 / 1M input tokens + $8.00 / 1M output tokens  │
│     Used by: OpenAI, Anthropic, Google, Mistral                   │
│                                                                   │
│  2. SUBSCRIPTION (Platform-based)                                 │
│     ────────────────────────────                                  │
│     Fixed monthly fee for usage                                   │
│     Example: $20/month for ChatGPT Plus                           │
│     Used by: ChatGPT, Claude Pro                                  │
│                                                                   │
│  3. SELF-HOSTED (Infrastructure-based)                            │
│     ─────────────────────────────────                             │
│     You pay for GPU compute, not tokens                           │
│     Example: $2-3/hour per A100 GPU                               │
│     Used by: Companies running open-source models                 │
│                                                                   │
│  4. FREE TIER / OPEN SOURCE                                       │
│     ──────────────────────────                                    │
│     Model weights are free; you pay for compute                   │
│     Example: LLaMA, Mistral, Gemma                                │
│     Used by: Startups, research labs, cost-sensitive applications  │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

#### API Pricing Comparison (Per 1M Tokens — Approximate, Mid-2026)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    COST PER 1M TOKENS (USD)                              │
│         (Prices are approximate and change frequently)                   │
├──────────────────────────┬──────────────────┬───────────────────────────┤
│  Model                   │  Input (per 1M)  │  Output (per 1M)          │
├──────────────────────────┼──────────────────┼───────────────────────────┤
│                          │                  │                           │
│  FRONTIER (Most Capable) │                  │                           │
│  ────────────────────    │                  │                           │
│  GPT-4.1                 │  $2.00           │  $8.00                    │
│  Claude Opus 4           │  $15.00          │  $75.00                   │
│  Claude Sonnet 4         │  $3.00           │  $15.00                   │
│  Gemini 2.5 Pro          │  $1.25 - $2.50   │  $10.00                   │
│  o3                      │  $10.00          │  $40.00                   │
│                          │                  │                           │
│  MID-TIER (Balanced)     │                  │                           │
│  ──────────────────      │                  │                           │
│  GPT-4.1-mini            │  $0.40           │  $1.60                    │
│  Gemini 2.5 Flash        │  $0.15 - $0.30   │  $0.60 - $3.50           │
│  Claude Haiku 3.5        │  $0.80           │  $4.00                    │
│  o4-mini                 │  $1.10           │  $4.40                    │
│                          │                  │                           │
│  BUDGET (Cost-Optimized) │                  │                           │
│  ──────────────────────  │                  │                           │
│  GPT-4.1-nano            │  $0.10           │  $0.40                    │
│  Gemini 2.0 Flash-Lite   │  $0.075          │  $0.30                    │
│  Mistral Small           │  $0.10           │  $0.30                    │
│                          │                  │                           │
│  SELF-HOSTED (Open)      │                  │                           │
│  ──────────────────      │                  │                           │
│  LLaMA 3.1 8B            │  Compute only    │  ~$0.05-0.10 effective   │
│  LLaMA 3.1 70B           │  Compute only    │  ~$0.30-0.80 effective   │
│  Mistral 7B              │  Compute only    │  ~$0.05-0.10 effective   │
│                          │                  │                           │
└──────────────────────────┴──────────────────┴───────────────────────────┘

Note: Prices change frequently. Always check provider pricing pages for current rates.
```

#### Cost Calculation Example

```
Scenario: Customer Support Chatbot
──────────────────────────────────

Users:            10,000/day
Average tokens:   800 input + 400 output per conversation
Monthly volume:   ~300,000 conversations

Monthly Token Usage:
   Input:  300,000 × 800  = 240M tokens
   Output: 300,000 × 400  = 120M tokens

┌──────────────────────┬──────────────────┬────────────────────┐
│ Model                │ Monthly Cost     │ Annual Cost        │
├──────────────────────┼──────────────────┼────────────────────┤
│ Claude Opus 4        │ $12,600          │ $151,200           │
│ GPT-4.1              │ $1,440           │ $17,280            │
│ Claude Sonnet 4      │ $2,520           │ $30,240            │
│ GPT-4.1-mini         │ $288             │ $3,456             │
│ GPT-4.1-nano         │ $72              │ $864               │
│ Gemini 2.0 Flash-Lite│ $54              │ $648               │
│ Self-hosted LLaMA 8B │ ~$150 (GPU cost) │ ~$1,800            │
└──────────────────────┴──────────────────┴────────────────────┘

The difference between the most expensive and cheapest option
is over 200× — for the SAME application.
```

---

### 5. Latency (Speed)

> **"How quickly does the model respond?"**

```
┌──────────────────────────────────────────────────────────────────┐
│                    LATENCY REQUIREMENTS                           │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  REAL-TIME (< 1 second)                                           │
│  ─────────────────────                                            │
│  ● Auto-complete / typeahead                                      │
│  ● Inline code suggestions                                       │
│  ● Voice assistant (speech-to-text-to-LLM-to-speech)             │
│  ● Gaming NPC dialogue                                            │
│                                                                   │
│  INTERACTIVE (1-5 seconds)                                        │
│  ──────────────────────                                           │
│  ● Chatbots (customer support, general chat)                      │
│  ● Search augmentation                                            │
│  ● Document Q&A                                                   │
│  ● Code generation (short snippets)                               │
│                                                                   │
│  NEAR-REAL-TIME (5-30 seconds)                                    │
│  ─────────────────────────────                                    │
│  ● Complex code generation                                        │
│  ● Research assistance                                            │
│  ● Detailed analysis                                               │
│  ● Report generation                                               │
│                                                                   │
│  BATCH (minutes to hours)                                         │
│  ────────────────────────                                         │
│  ● Document processing pipelines                                  │
│  ● Data labeling                                                  │
│  ● Bulk content generation                                        │
│  ● Model evaluation                                               │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

#### Latency Factors

```
Total Latency = Network Latency + Time to First Token + Token Generation Time

Where:
   Network Latency        = ~20-100ms (depends on geography and provider)
   Time to First Token     = ~100ms-5s (depends on model size and prompt length)
   Token Generation Time  = Tokens × (1 / tokens_per_second)

Example:
   Model: GPT-4.1-mini generating 200 tokens
   Network: 50ms
   TTFT: 200ms
   Speed: 100 tok/s → 200/100 = 2s
   Total: 50 + 200 + 2000 = 2.25 seconds
```

#### Speed Comparison

```
Approximate Tokens Per Second (Output, Via API):

Model                     Speed (tok/s)     TTFT
───────────────────────   ────────────     ─────────
GPT-4.1-nano              ~150-200         ~100ms
Gemini 2.0 Flash-Lite     ~150-200         ~100ms
GPT-4.1-mini              ~100-150         ~200ms
Gemini 2.5 Flash          ~100-180         ~150ms
GPT-4.1                   ~60-100          ~300ms
Claude Sonnet 4           ~60-100          ~300ms
Claude Opus 4             ~30-60           ~500ms+
o3 / o4-mini (reasoning)  ~20-50           ~1-10s+

Note: Reasoning models (o3, o4-mini) have highly variable latency
because they "think" before responding.
```

---

### 6. Model Size

> **"How big is the model?"**

Model size is measured in **billions of parameters (B)**.

```
Model Size Spectrum:

  1-3B        7-13B         30-70B          100B+          400B+
   │            │              │               │              │
   ▼            ▼              ▼               ▼              ▼
  Tiny        Small          Medium          Large         Frontier
   │            │              │               │              │
   │            │              │               │              │
  ● Fast      ● Balanced    ● Powerful      ● Very         ● Maximum
  ● Cheap     ● Good for    ● Strong          capable       capability
  ● Edge/       general       reasoning     ● Expensive    ● Highest
    mobile      tasks       ● Multi-GPU     ● Multi-GPU      cost
  ● Limited   ● Single       required        required      ● Data
    capability  GPU OK                                       center

Examples:
  Phi-3-mini  Mistral 7B   LLaMA 3.1 70B  Mistral Large  LLaMA 3.1 405B
  Gemma 2B    LLaMA 3.1 8B Qwen 2.5 72B   Claude Opus    GPT-4 (MoE)
  TinyLlama   Gemma 7B     Mixtral 8×7B
```

#### The Size-Capability Curve

```
Capability
   │
   │                                          ● 405B
   │                                     ●  70B
   │                               ●  30B
   │                         ●  13B
   │                    ●  7B
   │              ●  3B
   │         ●  1B
   │
   └──────────────────────────────────────────── Parameters
   
   Observation: Capability grows with size, but with diminishing returns.
   
   Important nuance:
   A well-trained 7B model (2026) can outperform a poorly-trained 70B model (2023).
   Architecture and training data quality matter as much as raw size.
```

#### Size vs Hardware Requirements

| Model Size | Inference Memory (FP16) | Minimum GPU                  | Quantized (INT4) |
|------------|-------------------------|------------------------------|-------------------|
| 1-3B       | 2-6 GB                  | Any modern GPU / CPU         | 1-2 GB            |
| 7B         | 14 GB                   | RTX 4090 / A100              | 4 GB              |
| 13B        | 26 GB                   | A100 40GB                    | 7 GB              |
| 34B        | 68 GB                   | A100 80GB or 2× A100        | 18 GB             |
| 70B        | 140 GB                  | 2× A100 80GB                | 35 GB             |
| 405B       | 810 GB                  | 8-10× A100 80GB             | ~200 GB           |

---

### 7. Domain Knowledge

> **"Does the model need specialized expertise?"**

```
GENERAL-PURPOSE MODELS:                  DOMAIN-SPECIALIZED MODELS:
──────────────────────                   ────────────────────────
Good at many things                      Excellent at one domain
Trained on broad internet data           Fine-tuned on domain-specific data
May lack depth in specific areas         Deep knowledge in their specialty

Example:                                 Example:
GPT-4.1 for general chat                Med-PaLM for medical Q&A
```

#### Domain-Specific Models and Approaches

```
┌───────────────────────────────────────────────────────────────────┐
│                    DOMAIN-SPECIFIC OPTIONS                         │
├───────────────────────────────────────────────────────────────────┤
│                                                                    │
│  🏥 MEDICAL                                                        │
│     Models: Med-PaLM 2, BioMistral, PMC-LLaMA                    │
│     Approach: Fine-tune on medical literature + clinical notes     │
│     Concern: Accuracy is life-critical → needs rigorous validation │
│                                                                    │
│  ⚖️ LEGAL                                                          │
│     Models: SaulLM, Legal-BERT                                     │
│     Approach: Fine-tune on case law + statutes + contracts         │
│     Concern: Hallucinations can cause legal liability              │
│                                                                    │
│  💰 FINANCE                                                        │
│     Models: BloombergGPT, FinGPT, FinMA                           │
│     Approach: Fine-tune on financial reports + market data          │
│     Concern: Regulatory compliance + data sensitivity              │
│                                                                    │
│  💻 CODING                                                         │
│     Models: CodeLlama, StarCoder 2, DeepSeek-Coder-V2             │
│     Approach: Trained primarily on code + documentation            │
│     Concern: Code correctness + security vulnerabilities           │
│                                                                    │
│  🔬 SCIENCE                                                        │
│     Models: Galactica, SciBERT                                     │
│     Approach: Trained on scientific papers + textbooks              │
│     Concern: Citation accuracy + reasoning validity                │
│                                                                    │
│  🌐 MULTILINGUAL                                                   │
│     Models: BLOOM, Qwen, Aya                                      │
│     Approach: Balanced training across many languages               │
│     Concern: Equal quality across languages                        │
│                                                                    │
└───────────────────────────────────────────────────────────────────┘
```

#### When to Use Domain-Specific vs General Models

```
Use GENERAL model when:
─────────────────────
● Application covers multiple domains
● Domain-specific model doesn't exist
● General model performance is "good enough"
● You'll add domain knowledge via RAG instead

Use DOMAIN-SPECIFIC model when:
──────────────────────────────
● Accuracy in that domain is critical
● General models consistently fail on domain tasks
● You have domain-specific training data
● The performance gap justifies the specialization cost
```

---

### 8. Multimodal Support

> **"Does the application need to understand images, audio, or video?"**

```
┌──────────────────────────────────────────────────────────────────┐
│                    MODALITY REQUIREMENTS                          │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  TEXT ONLY                                                        │
│  ─────────                                                        │
│  ● Chatbots (text-based)                                          │
│  ● Document summarization                                         │
│  ● Code generation                                                │
│  ● Email drafting                                                 │
│  → Any text-only model works                                      │
│                                                                   │
│  TEXT + IMAGE (Vision)                                             │
│  ────────────────────                                             │
│  ● Invoice / receipt extraction                                   │
│  ● Medical image analysis (X-rays, scans)                         │
│  ● Chart / graph understanding                                    │
│  ● UI screenshot analysis                                         │
│  ● Product image description                                      │
│  → Need: GPT-4.1, Claude Sonnet 4, Gemini 2.5, LLaVA            │
│                                                                   │
│  TEXT + AUDIO                                                     │
│  ────────────                                                     │
│  ● Voice assistants                                               │
│  ● Meeting transcription + analysis                               │
│  ● Podcast summarization                                          │
│  → Need: Gemini 2.5, GPT-4o (native audio), Whisper + LLM       │
│                                                                   │
│  TEXT + VIDEO                                                     │
│  ────────────                                                     │
│  ● Video content analysis                                         │
│  ● Security camera analysis                                       │
│  ● Video summarization                                            │
│  → Need: Gemini 2.5 Pro (native video), or frame extraction + VLM│
│                                                                   │
│  FULL MULTIMODAL (Text + Image + Audio + Video)                   │
│  ──────────────────────────────────────────────                   │
│  → Need: Gemini 2.5 Pro, GPT-4o (most modalities)                │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

#### Multimodal Model Comparison

| Model            | Text | Image Input | Image Gen | Audio Input | Video Input |
|------------------|------|-------------|-----------|-------------|-------------|
| GPT-4.1          | ✅    | ✅           | ❌        | ❌          | ❌          |
| GPT-4o           | ✅    | ✅           | ✅        | ✅          | ❌          |
| Claude Sonnet 4  | ✅    | ✅           | ❌        | ❌          | ❌          |
| Gemini 2.5 Pro   | ✅    | ✅           | ✅        | ✅          | ✅          |
| Gemini 2.5 Flash | ✅    | ✅           | ✅        | ✅          | ✅          |
| LLaMA 3.1        | ✅    | ❌           | ❌        | ❌          | ❌          |
| LLaVA            | ✅    | ✅           | ❌        | ❌          | ❌          |
| Qwen 2.5 VL      | ✅    | ✅           | ❌        | ❌          | ✅          |

---

### 9. Tool Calling & Structured Output

> **"Does the model need to call APIs, execute functions, or output structured data?"**

```
TEXT ONLY (No Tools):                    TOOL CALLING NEEDED:
───────────────────                      ─────────────────────
● Answer questions                       ● Book a flight → Call booking API
● Write content                          ● Search the web → Call search API
● Translate text                         ● Query database → Execute SQL
● Summarize documents                    ● Send email → Call email API
                                          ● Check weather → Call weather API
                                          ● Execute code → Call interpreter
```

#### Tool Calling Capability by Model

```
EXCELLENT Tool Calling:
──────────────────────
● GPT-4.1, GPT-4.1-mini     → Industry-leading function calling
● Claude Sonnet 4, Opus 4   → Reliable tool use with complex workflows
● Gemini 2.5 Pro/Flash      → Strong function calling

GOOD Tool Calling:
────────────────
● Mistral Large              → Solid function calling support
● LLaMA 3.1 70B+            → Good with fine-tuning
● Qwen 2.5                  → Competitive tool calling

LIMITED Tool Calling:
──────────────────
● Small open-source models   → Often requires specific fine-tuning
● Older models               → May not support structured tool calling natively
```

#### Structured Output (JSON Mode)

Many applications need the model to output **structured data**, not free text:

```
UNSTRUCTURED OUTPUT:                     STRUCTURED OUTPUT (JSON):
────────────────────                     ──────────────────────────
"The invoice is from Acme Corp,          {
dated January 15, 2026, for                "vendor": "Acme Corp",
$1,234.56 for consulting services."        "date": "2026-01-15",
                                           "amount": 1234.56,
                                           "description": "consulting"
                                         }
```

| Model           | JSON Mode | Function Calling | Parallel Tools |
|-----------------|-----------|------------------|----------------|
| GPT-4.1         | ✅ Native  | ✅ Excellent      | ✅              |
| GPT-4.1-mini    | ✅ Native  | ✅ Excellent      | ✅              |
| Claude Sonnet 4 | ✅ Native  | ✅ Strong         | ✅              |
| Gemini 2.5 Pro  | ✅ Native  | ✅ Strong         | ✅              |
| Mistral Large   | ✅ Native  | ✅ Good           | ✅              |
| LLaMA 3.1 70B   | Via prompt | Via fine-tuning   | Limited        |

---

### 10. Deployment Constraints

> **"Where and how will the model run?"**

This parameter is often **the most restrictive** — it can eliminate entire categories of models.

```
┌──────────────────────────────────────────────────────────────────┐
│                DEPLOYMENT CONSTRAINT ANALYSIS                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  CLOUD API (Easiest)                                              │
│  ─────────────────                                                │
│  ✅ No infrastructure to manage                                    │
│  ✅ Pay per use                                                    │
│  ✅ Access to frontier models                                      │
│  ❌ Data leaves your environment                                   │
│  ❌ Vendor dependency                                              │
│  ❌ Rate limits                                                    │
│  → Use: OpenAI, Anthropic, Google, Mistral APIs                   │
│                                                                   │
│  PRIVATE CLOUD / VPC                                              │
│  ──────────────────                                               │
│  ✅ Data stays in your cloud account                               │
│  ✅ Custom scaling                                                 │
│  ❌ More complex setup                                             │
│  ❌ Higher base cost                                               │
│  → Use: Azure OpenAI, AWS Bedrock, Google Vertex AI               │
│                                                                   │
│  ON-PREMISES (Self-Hosted)                                        │
│  ─────────────────────────                                        │
│  ✅ Complete data control                                          │
│  ✅ No external dependencies                                      │
│  ✅ Regulatory compliance                                          │
│  ❌ Requires GPU infrastructure                                    │
│  ❌ Team must manage model serving                                 │
│  ❌ Limited to open-source models                                  │
│  → Use: LLaMA, Mistral, Qwen, Gemma with vLLM/TGI               │
│                                                                   │
│  EDGE / ON-DEVICE                                                 │
│  ────────────────                                                 │
│  ✅ Runs offline                                                   │
│  ✅ Zero latency (no network)                                      │
│  ✅ Complete privacy                                               │
│  ❌ Very limited model size (1-3B max)                             │
│  ❌ Reduced capability                                             │
│  → Use: Phi-3-mini, Gemma 2B, TinyLlama, quantized small models  │
│                                                                   │
│  AIR-GAPPED (No Internet)                                         │
│  ────────────────────────                                         │
│  ✅ Maximum security                                               │
│  ❌ Cannot use any cloud API                                       │
│  ❌ Must self-host everything                                      │
│  → Use: Open-source models deployed on isolated infrastructure    │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

#### Industry-Specific Constraints

| Industry      | Typical Constraint                          | Cloud OK? | Recommended Approach          |
|---------------|---------------------------------------------|-----------|-------------------------------|
| Healthcare    | HIPAA compliance, patient data protection   | With BAA  | Azure OpenAI / Self-hosted    |
| Finance       | SOC 2, data residency requirements          | With audit| Private cloud / Self-hosted   |
| Government    | FedRAMP, classified data                    | GovCloud  | Self-hosted / Air-gapped      |
| Defense       | Air-gapped, classified information          | No        | Self-hosted open-source       |
| Legal         | Client privilege, confidentiality           | Varies    | Private cloud / Self-hosted   |
| Education     | Student data protection (FERPA)             | With DPA  | Cloud with agreements         |
| Startup       | No constraints, speed matters               | Yes       | Cloud API (fastest to deploy) |

---

## Complete Model Landscape (2024–2026)

### Closed-Source (API-Based) Models

```
┌───────────────────────────────────────────────────────────────────────┐
│                    CLOSED-SOURCE MODEL LANDSCAPE                      │
├───────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  OPENAI                                                                │
│  ──────                                                                │
│  ● GPT-4.1              → Flagship, long context (1M), great coding   │
│  ● GPT-4.1-mini         → Balanced cost-performance                   │
│  ● GPT-4.1-nano         → Cheapest, fastest, lightweight tasks        │
│  ● GPT-4o               → Multimodal (text + image + audio)           │
│  ● o3                   → Best reasoning (math, science, coding)      │
│  ● o4-mini              → Fast reasoning at lower cost                │
│                                                                        │
│  ANTHROPIC                                                             │
│  ─────────                                                             │
│  ● Claude Opus 4        → Most capable, complex reasoning             │
│  ● Claude Sonnet 4      → Best balance of quality and speed           │
│  ● Claude Haiku 3.5     → Fast and cost-effective                     │
│                                                                        │
│  GOOGLE                                                                │
│  ──────                                                                │
│  ● Gemini 2.5 Pro       → Best multimodal, 1M context, strong reason. │
│  ● Gemini 2.5 Flash     → Fast, cost-effective, thinking mode         │
│  ● Gemini 2.0 Flash-Lite→ Cheapest Google option                      │
│                                                                        │
│  MISTRAL                                                               │
│  ───────                                                               │
│  ● Mistral Large        → Competitive frontier model                  │
│  ● Mistral Medium       → Balanced option                             │
│  ● Mistral Small        → Budget-friendly                             │
│                                                                        │
└───────────────────────────────────────────────────────────────────────┘
```

### Open-Source (Self-Hostable) Models

```
┌───────────────────────────────────────────────────────────────────────┐
│                    OPEN-SOURCE MODEL LANDSCAPE                        │
├───────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  META                                                                  │
│  ────                                                                  │
│  ● LLaMA 3.1 8B         → Best small open model, 128K context        │
│  ● LLaMA 3.1 70B        → Strong competitor to closed models          │
│  ● LLaMA 3.1 405B       → Most capable open model                    │
│  ● CodeLlama 70B        → Specialized for code                        │
│                                                                        │
│  MISTRAL AI                                                            │
│  ──────────                                                            │
│  ● Mistral 7B           → Excellent for its size                      │
│  ● Mixtral 8×7B         → MoE architecture, great efficiency          │
│  ● Mistral Nemo 12B     → Strong small model                          │
│                                                                        │
│  GOOGLE                                                                │
│  ──────                                                                │
│  ● Gemma 2 2B           → Tiny but capable, edge-friendly             │
│  ● Gemma 2 9B           → Strong small model                          │
│  ● Gemma 2 27B          → Competitive medium model                    │
│                                                                        │
│  ALIBABA                                                               │
│  ───────                                                               │
│  ● Qwen 2.5 7B          → Strong multilingual model                   │
│  ● Qwen 2.5 72B         → Frontier-competitive open model            │
│  ● Qwen 2.5 Coder       → Specialized for code                       │
│                                                                        │
│  DEEPSEEK                                                              │
│  ────────                                                              │
│  ● DeepSeek-V3 (671B MoE) → Cost-efficient training, open weights    │
│  ● DeepSeek-R1           → Strong reasoning model                     │
│  ● DeepSeek-Coder-V2     → Top coding model                          │
│                                                                        │
│  MICROSOFT                                                             │
│  ─────────                                                             │
│  ● Phi-3-mini (3.8B)    → Surprisingly capable for size               │
│  ● Phi-3-medium (14B)   → Strong medium model                         │
│                                                                        │
│  OTHER NOTABLE                                                         │
│  ────────────                                                          │
│  ● Yi-1.5 34B (01.AI)   → Strong Chinese+English model               │
│  ● Command R+ (Cohere)  → RAG-optimized, 128K context                │
│  ● Aya 23 (Cohere)      → 23-language multilingual model              │
│                                                                        │
└───────────────────────────────────────────────────────────────────────┘
```

---

## Head-to-Head Model Comparison

### By Use Case — Which Model to Choose

```
┌────────────────────────────────────────────────────────────────────────┐
│              RECOMMENDED MODELS BY USE CASE                            │
├────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  GENERAL CHATBOT:                                                       │
│    Budget:    GPT-4.1-nano, Gemini 2.0 Flash-Lite                      │
│    Balanced:  GPT-4.1-mini, Claude Haiku 3.5, Gemini 2.5 Flash        │
│    Premium:   GPT-4.1, Claude Sonnet 4                                 │
│    Self-host: LLaMA 3.1 8B (budget) / 70B (premium)                   │
│                                                                         │
│  CODE GENERATION:                                                       │
│    Best:      Claude Sonnet 4, GPT-4.1, o3                            │
│    Balanced:  GPT-4.1-mini, Gemini 2.5 Flash                          │
│    Self-host: DeepSeek-Coder-V2, CodeLlama 70B, Qwen 2.5 Coder       │
│                                                                         │
│  COMPLEX REASONING / MATH:                                              │
│    Best:      o3, Claude Opus 4 (thinking), Gemini 2.5 Pro (thinking) │
│    Balanced:  o4-mini, Gemini 2.5 Flash (thinking)                     │
│    Self-host: DeepSeek-R1, Qwen 2.5 72B                               │
│                                                                         │
│  RAG / DOCUMENT Q&A:                                                    │
│    Best:      Gemini 2.5 Pro (1M context), GPT-4.1 (1M context)       │
│    Balanced:  Claude Sonnet 4 (200K), GPT-4.1-mini                     │
│    Self-host: Command R+ (128K, RAG-optimized), LLaMA 3.1 70B         │
│                                                                         │
│  AGENTIC WORKFLOWS:                                                     │
│    Best:      Claude Sonnet 4, GPT-4.1, o3 (for planning)             │
│    Balanced:  GPT-4.1-mini, Gemini 2.5 Flash                          │
│    Self-host: LLaMA 3.1 70B (with tool-calling fine-tuning)           │
│                                                                         │
│  MULTIMODAL (Image/Video Understanding):                                │
│    Best:      Gemini 2.5 Pro (all modalities including video)          │
│    Balanced:  GPT-4o (text + image + audio), Claude Sonnet 4 (vision) │
│    Self-host: Qwen 2.5 VL, LLaVA                                      │
│                                                                         │
│  DATA EXTRACTION / STRUCTURED OUTPUT:                                   │
│    Best:      GPT-4.1 (strongest JSON mode), Claude Sonnet 4           │
│    Balanced:  GPT-4.1-mini, Gemini 2.5 Flash                          │
│    Self-host: Mistral 7B (with fine-tuning), LLaMA 3.1 8B             │
│                                                                         │
│  EDGE / ON-DEVICE:                                                      │
│    Best:      Phi-3-mini (3.8B), Gemma 2 2B                           │
│    Quantized: LLaMA 3.1 8B (GGUF Q4), Mistral 7B (GGUF Q4)           │
│                                                                         │
│  MULTILINGUAL:                                                          │
│    Best:      Gemini 2.5 Pro, GPT-4.1 (broad coverage)                │
│    Balanced:  Qwen 2.5 (especially CJK languages)                     │
│    Self-host: BLOOM, Aya 23, Qwen 2.5                                 │
│                                                                         │
└────────────────────────────────────────────────────────────────────────┘
```

---

## Benchmark Guide — What the Scores Mean

### Major Benchmarks Explained

```
┌──────────────────────────────────────────────────────────────────────┐
│                    KEY LLM BENCHMARKS                                 │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  MMLU (Massive Multitask Language Understanding)                      │
│  ──────────────────────────────────────────────                       │
│  What: 57 subjects — history, math, law, medicine, etc.              │
│  Measures: Broad knowledge and reasoning                              │
│  Format: Multiple choice (4 options)                                  │
│  Scale: 0-100% (random = 25%)                                        │
│  Example: "What is the capital of Mongolia?" A) B) C) D)             │
│                                                                       │
│  MMLU-Pro                                                             │
│  ────────                                                             │
│  What: Harder version of MMLU with 10 answer choices                 │
│  Measures: More rigorous knowledge and reasoning                      │
│  Scale: 0-100% (random = 10%)                                        │
│                                                                       │
│  HumanEval / HumanEval+                                              │
│  ──────────────────────                                               │
│  What: 164 Python programming problems                                │
│  Measures: Code generation ability                                    │
│  Format: Generate function that passes test cases                     │
│  Scale: pass@1 (% solved on first attempt)                           │
│                                                                       │
│  MATH (Mathematics)                                                   │
│  ─────────────────                                                    │
│  What: 12,500 competition-level math problems                        │
│  Measures: Mathematical reasoning                                     │
│  Scale: 0-100%                                                        │
│                                                                       │
│  GSM8K (Grade School Math)                                            │
│  ────────────────────────                                             │
│  What: 8,500 grade-school-level word problems                        │
│  Measures: Basic mathematical reasoning                               │
│  Scale: 0-100%                                                        │
│                                                                       │
│  GPQA (Graduate-Level Q&A)                                            │
│  ─────────────────────────                                            │
│  What: PhD-level science questions                                    │
│  Measures: Expert-level scientific reasoning                          │
│  Scale: 0-100%                                                        │
│                                                                       │
│  MT-Bench                                                             │
│  ────────                                                             │
│  What: Multi-turn conversation benchmark                              │
│  Measures: Instruction following, conversation quality                │
│  Format: GPT-4 judges responses on 1-10 scale                       │
│                                                                       │
│  Arena ELO (Chatbot Arena / LMSYS)                                    │
│  ──────────────────────────────                                       │
│  What: Human blind comparison of model responses                     │
│  Measures: Overall "vibes" — how much humans prefer this model       │
│  Format: ELO rating (like chess ratings)                              │
│  Scale: ~800-1400 (higher = better)                                   │
│                                                                       │
│  SWE-Bench (Software Engineering)                                     │
│  ───────────────────────────────                                      │
│  What: Real GitHub issues to solve                                    │
│  Measures: Ability to fix real bugs in real codebases                 │
│  Scale: % of issues resolved                                          │
│                                                                       │
│  IFEval (Instruction Following)                                       │
│  ───────────────────────────                                          │
│  What: Precise instruction-following tasks                            │
│  Measures: Can the model follow specific formatting instructions?    │
│  Scale: 0-100%                                                        │
│                                                                       │
│  MGSM (Multilingual Grade School Math)                                │
│  ─────────────────────────────────────                                │
│  What: Math problems in 10 languages                                  │
│  Measures: Multilingual mathematical reasoning                        │
│  Scale: 0-100%                                                        │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

### How to Read Benchmark Results

```
⚠️ IMPORTANT: Benchmarks are USEFUL but NOT SUFFICIENT

Things benchmarks DON'T tell you:
──────────────────────────────────
● How the model performs on YOUR specific data
● Real-world latency under load
● How well it handles edge cases in your domain
● Cost-effectiveness for your volume
● How reliably it follows your specific instructions
● Long-term consistency across thousands of requests

The RIGHT approach:
───────────────────
1. Use benchmarks to CREATE a shortlist (3-5 models)
2. Test shortlisted models on YOUR data
3. Measure accuracy, latency, and cost on YOUR workload
4. Choose based on YOUR results, not public benchmarks
```

---

## Cost Analysis — Real Numbers

### Scenario Comparisons

#### Scenario A: Low-Volume Internal Tool (100 requests/day)

```
Daily: 100 requests × 1,500 tokens avg = 150,000 tokens/day
Monthly: ~4.5M tokens

┌────────────────────┬──────────────┬─────────────────────────────┐
│ Model              │ Monthly Cost │ Recommendation              │
├────────────────────┼──────────────┼─────────────────────────────┤
│ Claude Opus 4      │ ~$340        │ Overkill unless critical    │
│ GPT-4.1            │ ~$36         │ ✅ Good choice for quality    │
│ GPT-4.1-mini       │ ~$7          │ ✅ Best value for most tasks  │
│ GPT-4.1-nano       │ ~$2          │ If accuracy is sufficient   │
│ Self-hosted 8B     │ ~$50-100     │ Only if data privacy needed │
└────────────────────┴──────────────┴─────────────────────────────┘

At 100 requests/day, cost is almost irrelevant.
Optimize for QUALITY.
```

#### Scenario B: Customer-Facing Chatbot (50,000 requests/day)

```
Daily: 50,000 requests × 2,000 tokens avg = 100M tokens/day
Monthly: ~3B tokens

┌────────────────────┬──────────────┬─────────────────────────────┐
│ Model              │ Monthly Cost │ Recommendation              │
├────────────────────┼──────────────┼─────────────────────────────┤
│ Claude Opus 4      │ ~$135,000    │ ❌ Way too expensive          │
│ GPT-4.1            │ ~$15,000     │ Only if quality is critical │
│ Claude Sonnet 4    │ ~$27,000     │ Premium quality option      │
│ GPT-4.1-mini       │ ~$3,000      │ ✅ Sweet spot                │
│ GPT-4.1-nano       │ ~$750        │ ✅ If quality is sufficient   │
│ Gemini 2.0 FL-Lite │ ~$560        │ ✅ Budget champion            │
│ Self-hosted 70B    │ ~$3,000-5,000│ If data privacy needed      │
│ Self-hosted 8B     │ ~$500-1,000  │ ✅ Best for cost + privacy    │
└────────────────────┴──────────────┴─────────────────────────────┘

At 50K requests/day, cost is a TOP priority.
Use the cheapest model that meets your accuracy bar.
```

#### Scenario C: Enterprise Document Processing (1M documents/month)

```
Monthly: 1M docs × 5,000 tokens avg = 5B tokens
(Batch processing, latency less critical)

┌────────────────────┬──────────────┬─────────────────────────────┐
│ Model              │ Monthly Cost │ Recommendation              │
├────────────────────┼──────────────┼─────────────────────────────┤
│ GPT-4.1            │ ~$25,000     │ High quality extraction     │
│ GPT-4.1-mini       │ ~$5,000      │ ✅ Balanced                   │
│ GPT-4.1-nano       │ ~$1,250      │ ✅ Cost-effective             │
│ Self-hosted 70B    │ ~$5,000-8,000│ ✅ Best for data privacy      │
│ Self-hosted 8B     │ ~$800-1,500  │ If accuracy is sufficient   │
│ Batch API (50% off)│ Half the above│ ✅ Use batch if no rush      │
└────────────────────┴──────────────┴─────────────────────────────┘

For batch processing: Use Batch APIs (OpenAI, Anthropic offer
50% discounts for non-real-time processing).
```

---

## Real-World Case Studies

### Case Study 1: Customer Support Chatbot

```
┌──────────────────────────────────────────────────────────────────┐
│              CASE STUDY: CUSTOMER SUPPORT CHATBOT                 │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Business: E-commerce company                                     │
│  Users: 100,000/day                                               │
│  Queries: Order status, returns, product info, FAQ                │
│                                                                   │
│  REQUIREMENTS:                                                    │
│  ─────────────                                                    │
│  Accuracy:      ★★★☆☆  (Good enough — human escalation exists)   │
│  Reasoning:     ★★☆☆☆  (Simple queries, no complex logic)        │
│  Context:       ★★☆☆☆  (Short conversations, 2-5 turns)          │
│  Cost:          ★★★★★  (100K users/day = must be cheap)           │
│  Speed:         ★★★★★  (Users expect <2 second responses)         │
│  Tool Calling:  ★★★☆☆  (Need to query order database)            │
│  Multimodal:    ★☆☆☆☆  (Text only)                               │
│  Privacy:       ★★☆☆☆  (No sensitive data in queries)            │
│                                                                   │
│  SHORTLIST:                                                       │
│  ──────────                                                       │
│  ● GPT-4.1-nano      → Cheapest, fastest                         │
│  ● GPT-4.1-mini      → Slightly better quality                   │
│  ● Gemini 2.0 FL-Lite → Very cheap alternative                   │
│                                                                   │
│  DECISION: GPT-4.1-nano with RAG for product knowledge base      │
│                                                                   │
│  WHY:                                                             │
│  ────                                                             │
│  ● $0.10/1M input = ~$300/month for 100K users                   │
│  ● Fast enough for real-time chat                                 │
│  ● Supports tool calling for order lookup                         │
│  ● RAG compensates for limited reasoning                          │
│  ● Human escalation handles edge cases                            │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### Case Study 2: Medical Research Assistant

```
┌──────────────────────────────────────────────────────────────────┐
│              CASE STUDY: MEDICAL RESEARCH ASSISTANT                │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Business: Hospital research department                           │
│  Users: 50 researchers                                            │
│  Tasks: Analyze papers, suggest diagnoses, drug interactions      │
│                                                                   │
│  REQUIREMENTS:                                                    │
│  ─────────────                                                    │
│  Accuracy:      ★★★★★  (Medical errors = life-threatening)       │
│  Reasoning:     ★★★★★  (Complex medical reasoning)               │
│  Context:       ★★★★★  (Long research papers, patient histories) │
│  Cost:          ★★☆☆☆  (50 users, cost is secondary)             │
│  Speed:         ★★★☆☆  (Researchers can wait 10-20 seconds)      │
│  Tool Calling:  ★★★☆☆  (Query medical databases)                 │
│  Multimodal:    ★★★★☆  (X-rays, CT scans, lab reports)           │
│  Privacy:       ★★★★★  (HIPAA — patient data is sacred)          │
│                                                                   │
│  SHORTLIST:                                                       │
│  ──────────                                                       │
│  ● Claude Opus 4       → Best reasoning                          │
│  ● Gemini 2.5 Pro      → 1M context + multimodal                 │
│  ● GPT-4.1 (Azure)     → HIPAA-compliant via Azure               │
│                                                                   │
│  DECISION: GPT-4.1 via Azure OpenAI + RAG on medical literature  │
│                                                                   │
│  WHY:                                                             │
│  ────                                                             │
│  ● Azure OpenAI provides HIPAA BAA (Business Associate Agreement)│
│  ● Strong accuracy on medical benchmarks                          │
│  ● 1M context handles long papers                                 │
│  ● Vision for medical images via GPT-4o or separate pipeline      │
│  ● 50 users → cost is ~$500-1000/month (affordable)              │
│  ● RAG provides up-to-date medical knowledge                     │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### Case Study 3: Code Generation Assistant

```
┌──────────────────────────────────────────────────────────────────┐
│              CASE STUDY: CODE GENERATION ASSISTANT                 │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Business: Software company (500 developers)                      │
│  Tasks: Code generation, debugging, code review, refactoring      │
│                                                                   │
│  REQUIREMENTS:                                                    │
│  ─────────────                                                    │
│  Accuracy:      ★★★★★  (Wrong code = bugs in production)         │
│  Reasoning:     ★★★★★  (Complex algorithms, system design)       │
│  Context:       ★★★★☆  (Need to understand large codebases)      │
│  Cost:          ★★★☆☆  (Moderate — ROI justifies investment)     │
│  Speed:         ★★★★☆  (Developers want fast suggestions)         │
│  Tool Calling:  ★★★★☆  (Execute code, read files, run tests)     │
│  Multimodal:    ★☆☆☆☆  (Text/code only)                          │
│  Privacy:       ★★★★☆  (Proprietary source code)                  │
│                                                                   │
│  SHORTLIST:                                                       │
│  ──────────                                                       │
│  ● Claude Sonnet 4     → Best coding benchmark scores             │
│  ● GPT-4.1             → Strong coding + 1M context               │
│  ● o3 / o4-mini        → Best for complex algorithmic problems    │
│  ● DeepSeek-Coder-V2   → Self-hosted option                      │
│                                                                   │
│  DECISION: Claude Sonnet 4 (primary) + o4-mini (complex tasks)   │
│                                                                   │
│  WHY:                                                             │
│  ────                                                             │
│  ● Claude Sonnet 4 leads SWE-Bench (real-world coding)           │
│  ● o4-mini for algorithmic challenges and complex debugging       │
│  ● 200K context sufficient for most code tasks                    │
│  ● Tool calling for code execution and testing                    │
│  ● Multi-model approach optimizes cost vs quality                 │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### Case Study 4: Invoice Processing System

```
┌──────────────────────────────────────────────────────────────────┐
│              CASE STUDY: INVOICE PROCESSING SYSTEM                 │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Business: Accounting firm                                        │
│  Volume: 50,000 invoices/month                                    │
│  Task: Extract fields → validate → store in database              │
│                                                                   │
│  PIPELINE:                                                        │
│  ─────────                                                        │
│  Invoice PDF → OCR/Vision → LLM → Extract JSON → Validate → DB  │
│                                                                   │
│  REQUIREMENTS:                                                    │
│  ─────────────                                                    │
│  Accuracy:         ★★★★★  (Financial data must be exact)          │
│  Reasoning:        ★★☆☆☆  (Extraction, not complex reasoning)    │
│  Context:          ★★☆☆☆  (Invoices are short documents)         │
│  Cost:             ★★★★☆  (50K invoices × every month)            │
│  Speed:            ★★★☆☆  (Batch processing OK)                  │
│  Multimodal:       ★★★★★  (PDF/Image understanding)              │
│  Structured Output:★★★★★  (Must output valid JSON)               │
│  Privacy:          ★★★★☆  (Financial data)                        │
│                                                                   │
│  DECISION: GPT-4.1-mini (vision mode) + JSON schema enforcement  │
│                                                                   │
│  WHY:                                                             │
│  ────                                                             │
│  ● Vision mode handles PDFs directly (no separate OCR needed)    │
│  ● Native JSON mode ensures structured output                     │
│  ● Batch API gives 50% cost reduction                             │
│  ● High extraction accuracy on financial documents               │
│  ● 50K invoices × ~1000 tokens ≈ 50M tokens → ~$100/month       │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### Case Study 5: Defense/Government Classified System

```
┌──────────────────────────────────────────────────────────────────┐
│              CASE STUDY: CLASSIFIED INTELLIGENCE ANALYSIS          │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Organization: Government intelligence agency                     │
│  Constraint: Air-gapped network (NO internet)                     │
│  Task: Analyze classified documents, generate summaries           │
│                                                                   │
│  REQUIREMENTS:                                                    │
│  ─────────────                                                    │
│  Accuracy:      ★★★★★                                             │
│  Privacy:       ★★★★★  (Classified data — no cloud possible)      │
│  Context:       ★★★★☆  (Long intelligence reports)                │
│  Self-hosted:   MANDATORY                                         │
│  Open-source:   MANDATORY (need to audit model weights)           │
│                                                                   │
│  ONLY OPTION: Self-hosted open-source model                       │
│                                                                   │
│  DECISION: LLaMA 3.1 70B (self-hosted, air-gapped)              │
│                                                                   │
│  WHY:                                                             │
│  ────                                                             │
│  ● Open-source → can be audited for security                     │
│  ● 70B is strong enough for analysis and summarization           │
│  ● 128K context handles long reports                             │
│  ● Can run on dedicated GPU cluster within classified network     │
│  ● No data leaves the secure environment                          │
│  ● Fine-tuned on domain-specific documents for better accuracy   │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## The Decision Matrix Framework

Use this framework to evaluate candidate models systematically.

### Step 1: Rate Your Requirements

```
For your specific application, rate each parameter:

Parameter           Weight        Score (1-5)    Notes
────────────────    ──────        ───────────    ─────
Accuracy            [         ]   [         ]    [                    ]
Reasoning           [         ]   [         ]    [                    ]
Context Window      [         ]   [         ]    [                    ]
Cost                [         ]   [         ]    [                    ]
Latency             [         ]   [         ]    [                    ]
Tool Calling        [         ]   [         ]    [                    ]
Structured Output   [         ]   [         ]    [                    ]
Multimodal          [         ]   [         ]    [                    ]
Domain Knowledge    [         ]   [         ]    [                    ]
Privacy/Deployment  [         ]   [         ]    [                    ]

Weight: Critical (3×) | Important (2×) | Nice-to-have (1×)
```

### Step 2: Score Candidate Models

```
Example for a Customer Support Chatbot:

Parameter        Weight  GPT-4.1-nano  GPT-4.1-mini  Claude Haiku  LLaMA 8B
──────────────   ──────  ────────────  ────────────  ───────────  ────────
Accuracy         2×      3 (6)         4 (8)         4 (8)        3 (6)
Reasoning        1×      2 (2)         3 (3)         3 (3)        2 (2)
Context          1×      3 (3)         4 (4)         3 (3)        4 (4)
Cost             3×      5 (15)        4 (12)        3 (9)        5 (15)
Latency          3×      5 (15)        4 (12)        4 (12)       4 (12)
Tool Calling     2×      4 (8)         5 (10)        3 (6)        2 (4)
Structured Out   2×      4 (8)         5 (10)        4 (8)        2 (4)
Multimodal       0×      — (0)         — (0)         — (0)        — (0)
Privacy          1×      3 (3)         3 (3)         3 (3)        5 (5)
                         ──────        ──────        ──────       ──────
TOTAL                     60            62            52           52

Winner: GPT-4.1-mini (highest weighted score)
```

### Step 3: Validate with Real Testing

```
DO NOT rely solely on the matrix.

Test your top 2-3 candidates on:
─────────────────────────────────

1. 50-100 representative queries from YOUR application
2. Edge cases and adversarial inputs
3. Measure:
   ● Accuracy (% correct)
   ● Latency (p50, p95, p99)
   ● Cost (actual tokens consumed)
   ● Failure modes (when does it break?)
   ● Output quality (human evaluation)

4. Run for at least 1 week in shadow mode before committing
```

---

## Open Source vs Closed Source — When to Use Which

```
┌──────────────────────────────────────────────────────────────────┐
│           OPEN SOURCE vs CLOSED SOURCE DECISION GUIDE             │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  USE CLOSED-SOURCE (API) WHEN:                                    │
│  ─────────────────────────────                                    │
│  ✅ You want the absolute best accuracy                            │
│  ✅ You don't have GPU infrastructure                              │
│  ✅ You need to ship fast (days, not weeks)                        │
│  ✅ Cloud deployment is acceptable                                 │
│  ✅ You want managed scaling and reliability                       │
│  ✅ Budget allows API costs                                        │
│  ✅ You need frontier capabilities (o3-level reasoning)            │
│                                                                   │
│  Examples: OpenAI API, Anthropic API, Google Gemini API            │
│                                                                   │
│  ─────────────────────────────────────────────────────────────── │
│                                                                   │
│  USE OPEN-SOURCE (SELF-HOSTED) WHEN:                              │
│  ─────────────────────────────────                                │
│  ✅ Data CANNOT leave your environment                             │
│  ✅ You need to fine-tune on proprietary data                      │
│  ✅ You want to avoid vendor lock-in                               │
│  ✅ High volume makes API costs prohibitive                        │
│  ✅ You need full control over the model                           │
│  ✅ Regulatory requirements mandate self-hosting                   │
│  ✅ You want to modify model behavior deeply                       │
│  ✅ You have GPU infrastructure (or budget for it)                 │
│                                                                   │
│  Examples: LLaMA, Mistral, Gemma, Qwen via vLLM/TGI              │
│                                                                   │
│  ─────────────────────────────────────────────────────────────── │
│                                                                   │
│  USE BOTH (HYBRID) WHEN:                                          │
│  ──────────────────────                                           │
│  ✅ Different tasks need different models                          │
│  ✅ Use expensive model for hard tasks, cheap for easy             │
│  ✅ Self-host for sensitive data, API for non-sensitive            │
│  ✅ Gradual migration from API to self-hosted                      │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## Quantization & Model Size Trade-offs

### When to Use Quantized Models

```
Full Precision (FP16/BF16):
─────────────────────────
● Maximum accuracy
● Maximum memory usage
● Use when: accuracy is critical and you have enough GPU memory

INT8 Quantization:
─────────────────
● ~1-2% quality loss
● 50% memory reduction
● Use when: you need to fit a larger model on fewer GPUs

INT4 Quantization (GPTQ / AWQ / GGUF):
──────────────────────────────────────
● ~3-5% quality loss (varies by model and method)
● 75% memory reduction
● Use when: running on consumer hardware or edge devices

Example Trade-off:

                 LLaMA 3.1 70B (FP16)     LLaMA 3.1 70B (INT4)
Memory:          140 GB                    35 GB
GPUs:            2× A100 80GB             1× A100 80GB
Speed:           Baseline                  Slightly faster
Quality:         100%                      ~95-97%
```

### The Counter-Intuitive Truth

```
Often, a SMALLER model at FULL precision outperforms
a LARGER model at HEAVY quantization.

Example:
   LLaMA 3.1 8B (FP16)  may beat  LLaMA 3.1 70B (INT2)
   
But usually:
   LLaMA 3.1 70B (INT4)  beats  LLaMA 3.1 8B (FP16)
   
Rule of thumb:
   INT4 quantization is the sweet spot for most production deployments.
   Going below INT4 (e.g., INT2) usually degrades quality too much.
```

---

## Multi-Model Architectures

In production, many AI systems use **multiple models** for different tasks.

### The Model Router Pattern

```
┌──────────────────────────────────────────────────────────────────┐
│                    MODEL ROUTER ARCHITECTURE                      │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│   User Request                                                    │
│        │                                                          │
│        ▼                                                          │
│   ┌──────────────────┐                                            │
│   │  Complexity       │                                            │
│   │  Classifier       │  ← Small/fast model or heuristic          │
│   └──────┬───────────┘                                            │
│          │                                                        │
│     ┌────┼────────────┐                                           │
│     │    │            │                                           │
│     ▼    ▼            ▼                                           │
│   Simple  Medium    Complex                                       │
│     │      │          │                                           │
│     ▼      ▼          ▼                                           │
│   Nano   Mini      Frontier                                      │
│   Model  Model     Model                                         │
│   ($)    ($$)      ($$$$$)                                        │
│     │      │          │                                           │
│     └──────┴──────────┘                                           │
│            │                                                      │
│            ▼                                                      │
│        Response                                                   │
│                                                                   │
│   Result: 80% of requests go to cheap model                      │
│           15% go to mid-tier model                                │
│           5% go to frontier model                                 │
│           → 70-80% cost reduction vs always using frontier        │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### The Cascade Pattern

```
Try the cheapest model first.
If confidence is low, escalate to a better model.

   User Query
       │
       ▼
   ┌─────────────┐
   │ GPT-4.1-nano │  ← Try cheap model first
   └──────┬──────┘
          │
     Confidence > 0.9?
      │           │
     YES          NO
      │           │
      ▼           ▼
   Return    ┌─────────────┐
   Response  │ GPT-4.1-mini │  ← Try mid-tier
             └──────┬──────┘
                    │
               Confidence > 0.85?
                │           │
               YES          NO
                │           │
                ▼           ▼
             Return    ┌──────────┐
             Response  │  GPT-4.1  │  ← Use frontier
                       └──────────┘
```

### The Specialist Pattern

```
Different models for different task types:

   User Request → Task Classifier
                       │
          ┌────────────┼─────────────┐
          │            │             │
          ▼            ▼             ▼
     Code Task     Chat Task    Analysis Task
          │            │             │
          ▼            ▼             ▼
     Claude        GPT-4.1        Gemini
     Sonnet 4      -mini          2.5 Pro
     (best code)   (fast chat)   (long context)
```

---

## Common Mistakes in Model Selection

```
┌──────────────────────────────────────────────────────────────────┐
│              TOP 10 MODEL SELECTION MISTAKES                      │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ❌ MISTAKE 1: "Always use the most powerful model"               │
│     Fix: Match model capability to task complexity                │
│                                                                   │
│  ❌ MISTAKE 2: "Trust benchmark scores blindly"                   │
│     Fix: Test on YOUR data — benchmarks ≠ your use case          │
│                                                                   │
│  ❌ MISTAKE 3: "Ignore cost until it's too late"                  │
│     Fix: Calculate costs at target scale BEFORE choosing          │
│                                                                   │
│  ❌ MISTAKE 4: "Choose one model and never revisit"               │
│     Fix: Re-evaluate quarterly — new models release constantly   │
│                                                                   │
│  ❌ MISTAKE 5: "Open source is always cheaper"                    │
│     Fix: Account for GPU costs, DevOps time, maintenance         │
│                                                                   │
│  ❌ MISTAKE 6: "More parameters always = better"                  │
│     Fix: A well-trained 8B can beat a poorly-trained 70B         │
│                                                                   │
│  ❌ MISTAKE 7: "Ignore latency requirements"                      │
│     Fix: Users abandon slow experiences — speed matters          │
│                                                                   │
│  ❌ MISTAKE 8: "Forget about deployment constraints"              │
│     Fix: Check data privacy, compliance, and infra FIRST         │
│                                                                   │
│  ❌ MISTAKE 9: "Use the same model for every task"                │
│     Fix: Multi-model architectures can save 70-80% in costs      │
│                                                                   │
│  ❌ MISTAKE 10: "Skip evaluation — just ship it"                  │
│     Fix: Always measure accuracy, latency, cost before launch    │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## Quick Reference Decision Flowchart

```
START: What type of application are you building?
  │
  ├── Can data leave your environment?
  │    │
  │    ├── NO → Must self-host
  │    │        │
  │    │        ├── Need strong reasoning? → LLaMA 3.1 70B / Qwen 72B
  │    │        ├── Budget/edge?           → LLaMA 3.1 8B / Mistral 7B / Phi-3
  │    │        └── Maximum capability?    → LLaMA 3.1 405B / DeepSeek-V3
  │    │
  │    └── YES → Can use cloud APIs
  │             │
  │             ├── What's your budget?
  │             │    │
  │             │    ├── Minimal ($) 
  │             │    │   → GPT-4.1-nano / Gemini 2.0 Flash-Lite
  │             │    │
  │             │    ├── Moderate ($$)
  │             │    │   → GPT-4.1-mini / Gemini 2.5 Flash / Claude Haiku
  │             │    │
  │             │    ├── Significant ($$$)
  │             │    │   → GPT-4.1 / Claude Sonnet 4 / Gemini 2.5 Pro
  │             │    │
  │             │    └── Unlimited ($$$$)
  │             │        → Claude Opus 4 / o3 / Gemini 2.5 Pro
  │             │
  │             ├── Need multimodal?
  │             │    │
  │             │    ├── Image understanding → GPT-4.1 / Claude Sonnet 4 / Gemini
  │             │    ├── Audio               → Gemini 2.5 / GPT-4o
  │             │    ├── Video               → Gemini 2.5 Pro
  │             │    └── Text only           → Any model
  │             │
  │             ├── Need complex reasoning?
  │             │    │
  │             │    ├── YES → o3 / Claude Opus 4 / Gemini 2.5 Pro (thinking)
  │             │    └── NO  → GPT-4.1-mini / Gemini 2.5 Flash / Claude Haiku
  │             │
  │             └── Need tool calling?
  │                  │
  │                  ├── Heavy tool use → GPT-4.1 / Claude Sonnet 4
  │                  └── Minimal       → Any mid-tier model
  │
  └── FINAL STEP: Test top 2-3 candidates on YOUR data
                   before making a final decision.
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────────┐
│                  MODEL SELECTION QUICK REFERENCE                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  CHEAPEST:          GPT-4.1-nano, Gemini 2.0 Flash-Lite             │
│  FASTEST:           GPT-4.1-nano, Gemini 2.0 Flash-Lite             │
│  BEST REASONING:    o3, Claude Opus 4 (thinking), Gemini 2.5 Pro   │
│  BEST CODING:       Claude Sonnet 4, GPT-4.1, o3                   │
│  BEST MULTIMODAL:   Gemini 2.5 Pro (all modalities)                │
│  BEST LONG CONTEXT: Gemini 2.5 Pro (1M), GPT-4.1 (1M)             │
│  BEST TOOL CALLING: GPT-4.1, Claude Sonnet 4                       │
│  BEST SELF-HOSTED:  LLaMA 3.1 70B, Qwen 2.5 72B                   │
│  BEST EDGE/MOBILE:  Phi-3-mini, Gemma 2 2B                         │
│  BEST VALUE:        GPT-4.1-mini, Gemini 2.5 Flash                 │
│  BEST MULTILINGUAL: Gemini 2.5 Pro, Qwen 2.5                       │
│  BEST FOR RAG:      Command R+, GPT-4.1, Gemini 2.5 Pro            │
│                                                                      │
│  GOLDEN RULE: The best model is not the most powerful.              │
│               It's the one that fits YOUR requirements.              │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Connecting to Your Learning Roadmap

```
✅ COMPLETED: Transformer Architecture
✅ COMPLETED: Complete LLM Development Pipeline
✅ COMPLETED: LLM Model Selection (this document)

NEXT RECOMMENDED TOPICS:
────────────────────────

1. LLM Evaluation & Benchmarking
   └─ How to evaluate models on your own data
   └─ Building evaluation pipelines
   └─ Automated vs human evaluation

2. Tokenization Deep Dive
   └─ How tokenization affects cost and quality
   └─ Token counting and optimization

3. Prompt Engineering
   └─ How to get the best results from any model
   └─ System prompts, few-shot, chain-of-thought

4. RAG (Retrieval-Augmented Generation)
   └─ When to use RAG vs long context
   └─ Vector databases and retrieval strategies

5. Fine-Tuning vs Prompting vs RAG
   └─ When to fine-tune, when to prompt, when to RAG
   └─ Cost-benefit analysis of each approach

6. LangChain / LangGraph
   └─ Building applications with model selection in mind
   └─ Multi-model architectures

7. Agents
   └─ Tool calling and agentic workflows
   └─ Model requirements for reliable agents
```

---

> **Remember:** Knowing which model to choose — and why — is what separates an **API user** from an **AI Engineer**. This skill becomes more valuable as the number of available models continues to grow.

---

*Document Version: 1.0 | Last Updated: August 2026*  
*Note: Model pricing and capabilities change frequently. Always verify current data before making production decisions.*
