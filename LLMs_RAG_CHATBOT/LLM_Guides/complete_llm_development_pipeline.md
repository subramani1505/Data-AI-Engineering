# The Complete LLM Development Pipeline — From Raw Data to Production AI

> **Author:** Subramani V  
> **Created:** August 2026  
> **Purpose:** Production-level reference document for understanding how Large Language Models are built end-to-end  
> **Prerequisite:** Basic understanding of Transformer architecture

---

## Table of Contents

1. [Pipeline Overview](#pipeline-overview)
2. [Phase 1 — Data Collection](#phase-1--data-collection)
3. [Phase 2 — Data Cleaning & Preprocessing](#phase-2--data-cleaning--preprocessing)
4. [Phase 3 — Tokenization](#phase-3--tokenization)
5. [Phase 4 — Vocabulary Creation](#phase-4--vocabulary-creation)
6. [Phase 5 — Embedding Layer](#phase-5--embedding-layer)
7. [Phase 6 — Positional Encoding](#phase-6--positional-encoding)
8. [Phase 7 — Transformer Decoder Architecture](#phase-7--transformer-decoder-architecture)
9. [Phase 8 — Next-Token Prediction & Decoding](#phase-8--next-token-prediction--decoding)
10. [Phase 9 — Loss Function](#phase-9--loss-function)
11. [Phase 10 — Backpropagation](#phase-10--backpropagation)
12. [Phase 11 — Optimizer](#phase-11--optimizer)
13. [Phase 12 — GPU & Distributed Training](#phase-12--gpu--distributed-training)
14. [Phase 13 — The Pretrained Model](#phase-13--the-pretrained-model)
15. [Phase 14 — Fine-Tuning](#phase-14--fine-tuning)
16. [Phase 15 — Alignment (RLHF, DPO, SFT)](#phase-15--alignment-rlhf-dpo-sft)
17. [Phase 16 — Deployment & Inference](#phase-16--deployment--inference)
18. [Complete Technology Stack Reference](#complete-technology-stack-reference)
19. [Real-World Model Specifications](#real-world-model-specifications)
20. [Learning Roadmap & Next Steps](#learning-roadmap--next-steps)

---

## Pipeline Overview

Building an LLM is not just "training a neural network." It is a **multi-stage engineering process** that transforms raw internet text into a production-ready AI system.

```
┌─────────────────────────────────────────────────────────────────────┐
│                  THE COMPLETE LLM PIPELINE                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   ┌──────────────┐                                                  │
│   │ Collect Data  │  ← Internet, books, code, papers               │
│   └──────┬───────┘                                                  │
│          ▼                                                          │
│   ┌──────────────┐                                                  │
│   │ Clean Data    │  ← Remove spam, HTML, duplicates                │
│   └──────┬───────┘                                                  │
│          ▼                                                          │
│   ┌──────────────┐                                                  │
│   │ Tokenizer     │  ← BPE / SentencePiece / WordPiece             │
│   └──────┬───────┘                                                  │
│          ▼                                                          │
│   ┌──────────────────┐                                              │
│   │ Create Vocabulary │  ← Map tokens ↔ integer IDs                │
│   └──────┬───────────┘                                              │
│          ▼                                                          │
│   ┌──────────────────────┐                                          │
│   │ Convert Text → Tokens │  ← Sentences become number sequences   │
│   └──────┬───────────────┘                                          │
│          ▼                                                          │
│   ┌──────────────┐                                                  │
│   │ Embeddings    │  ← Token IDs → dense vectors                   │
│   └──────┬───────┘                                                  │
│          ▼                                                          │
│   ┌─────────────────────┐                                           │
│   │ Positional Encoding  │  ← Add word-order information           │
│   └──────┬──────────────┘                                           │
│          ▼                                                          │
│   ┌──────────────────────┐                                          │
│   │ Transformer Decoder   │  ← Multi-head attention + FFN          │
│   └──────┬───────────────┘                                          │
│          ▼                                                          │
│   ┌──────────────┐                                                  │
│   │ Loss Function │  ← Cross-entropy loss                          │
│   └──────┬───────┘                                                  │
│          ▼                                                          │
│   ┌──────────────────┐                                              │
│   │ Backpropagation   │  ← Compute gradients                      │
│   └──────┬───────────┘                                              │
│          ▼                                                          │
│   ┌──────────────┐                                                  │
│   │ Optimizer     │  ← Adam / AdamW update weights                 │
│   └──────┬───────┘                                                  │
│          ▼                                                          │
│   ┌──────────────┐                                                  │
│   │ GPU Training  │  ← Thousands of GPUs for weeks/months          │
│   └──────┬───────┘                                                  │
│          ▼                                                          │
│   ┌──────────────────┐                                              │
│   │ Pretrained LLM    │  ← Knows language, code, reasoning        │
│   └──────┬───────────┘                                              │
│          ▼                                                          │
│   ┌──────────────┐                                                  │
│   │ Fine-Tuning   │  ← SFT / LoRA / QLoRA                        │
│   └──────┬───────┘                                                  │
│          ▼                                                          │
│   ┌────────────────────────────┐                                    │
│   │ Alignment (RLHF / DPO)     │  ← Human preference training     │
│   └──────┬─────────────────────┘                                    │
│          ▼                                                          │
│   ┌──────────────┐                                                  │
│   │ Deployment    │  ← API / Server / Edge                         │
│   └──────────────┘                                                  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Phase 1 — Data Collection

### What Happens Here

An LLM learns everything it knows from text. The first step is to collect **massive amounts** of text data from diverse sources.

### Scale of Data

| Model (Approximate) | Training Tokens   | Data Size (Approx.) |
|----------------------|-------------------|----------------------|
| GPT-3                | ~300 billion      | ~570 GB              |
| LLaMA 2              | ~2 trillion       | ~2 TB                |
| GPT-4 (estimated)    | ~13 trillion      | ~10+ TB              |
| LLaMA 3              | ~15 trillion      | ~15+ TB              |

> **1 token ≈ 0.75 words (English)**  
> **1 trillion tokens ≈ 750 billion words ≈ approximately 7.5 million novels**

### Common Data Sources

```
┌─────────────────────────────────────────────────────┐
│               DATA SOURCES FOR LLMs                  │
├─────────────────────────────────────────────────────┤
│                                                      │
│  📚 Books           → Project Gutenberg, BookCorpus  │
│  🌐 Web Pages       → Common Crawl, C4 dataset      │
│  📖 Wikipedia       → All languages                  │
│  💻 Code            → GitHub, Stack Overflow          │
│  📰 News            → News articles, press releases  │
│  📄 Research Papers → arXiv, PubMed, Semantic Scholar│
│  💬 Forums          → Reddit, Q&A sites              │
│  📝 Documentation   → Technical docs, man pages      │
│  🗣️ Conversations   → Dialogue datasets              │
│                                                      │
└─────────────────────────────────────────────────────┘
```

### Real-World Datasets

| Dataset        | Size          | Description                              |
|----------------|---------------|------------------------------------------|
| Common Crawl   | Petabytes     | Raw web crawl data (monthly snapshots)   |
| C4             | ~750 GB       | Colossal Clean Crawled Corpus (filtered) |
| The Pile       | ~800 GB       | 22 diverse high-quality sub-datasets     |
| RedPajama      | ~5 TB         | Open reproduction of LLaMA training data |
| FineWeb        | ~15 TB        | HuggingFace curated web dataset          |
| StarCoder Data | ~783 GB       | GitHub code across 80+ languages         |

### How Data Collection Works

```
Step 1: Web Crawling
         │
         ▼
   Download billions of web pages using crawlers
   (e.g., Common Crawl processes ~3.15 billion pages per month)
         │
         ▼
Step 2: Format Extraction
         │
         ▼
   Extract raw text from HTML, PDF, and other formats
         │
         ▼
Step 3: Language Detection
         │
         ▼
   Classify text by language (keep English + target languages)
         │
         ▼
Step 4: Deduplication
         │
         ▼
   Remove duplicate documents (MinHash, SimHash, or exact matching)
         │
         ▼
Step 5: Quality Filtering
         │
         ▼
   Remove low-quality content using heuristic and classifier-based filters
         │
         ▼
Step 6: Store as Training Corpus
```

### Key Concepts

| Concept              | What It Means                                                        |
|----------------------|----------------------------------------------------------------------|
| **Corpus**           | The entire collection of text used for training                      |
| **Token**            | A unit of text (word, subword, or character)                         |
| **Epoch**            | One complete pass through the entire training dataset                |
| **Data Mix**         | The proportion of different sources (e.g., 40% web, 20% code, etc.) |
| **Data Deduplication** | Removing identical or near-identical documents                     |

### Why Data Quality Matters

```
High Quality Data → Better Model

         ┌──────────────────────────┐
         │  "Garbage In,             │
         │           Garbage Out"    │
         └──────────────────────────┘

Low Quality Data → Biased / Inaccurate / Toxic Model
```

If the training data contains:
- **Spam** → The model learns to generate spam-like text
- **Bias** → The model reproduces societal biases
- **Errors** → The model confidently states wrong facts
- **Toxic content** → The model may generate harmful outputs

This is why **data curation is one of the most important and expensive parts** of building an LLM.

---

## Phase 2 — Data Cleaning & Preprocessing

### Why Cleaning Is Necessary

Raw internet data is extremely noisy. Without cleaning, the model would learn from garbage.

### What Gets Removed

```
┌───────────────────────────────────────────────────┐
│               DATA CLEANING PIPELINE               │
├───────────────────────────────────────────────────┤
│                                                    │
│  ❌ HTML tags         → <div>, <script>, <style>   │
│  ❌ JavaScript code   → <script>alert(1)</script>  │
│  ❌ CSS               → inline and block styles    │
│  ❌ Boilerplate       → Navigation menus, footers  │
│  ❌ Advertisements    → "Buy now! Click here!"     │
│  ❌ Spam              → Repetitive junk content    │
│  ❌ Duplicates        → Exact and near-duplicates  │
│  ❌ Corrupted text    → Encoding errors, garbled   │
│  ❌ Very short docs   → Documents with < N words   │
│  ❌ PII               → Email, phone, addresses    │
│  ❌ Offensive content → Depending on policy        │
│                                                    │
└───────────────────────────────────────────────────┘
```

### Before vs After Cleaning

**Before (Raw HTML):**

```html
<html>
<head><title>Python Tutorial</title></head>
<body>
<nav>Home | About | Contact</nav>
<div class="ad">Buy Python Course — 90% OFF!!!</div>
<h1>Python is great</h1>
<p>Python is a programming language used for...</p>
<script>
  var x = document.getElementById("ad");
  x.style.display = "none";
</script>
<footer>Copyright 2026. All rights reserved.</footer>
</body>
</html>
```

**After Cleaning:**

```text
Python is great.
Python is a programming language used for...
```

### Cleaning Techniques

| Technique                     | How It Works                                                     |
|-------------------------------|------------------------------------------------------------------|
| **HTML Parsing**              | Strip all tags, keep only text content (BeautifulSoup, trafilatura) |
| **Regex Filters**             | Remove patterns like URLs, email addresses, phone numbers        |
| **Language Filtering**        | Keep only target languages using fastText language classifier    |
| **Length Filtering**           | Remove documents shorter than a minimum word count               |
| **Perplexity Filtering**      | Use a small language model to score text quality                 |
| **Exact Deduplication**       | Hash each document and remove exact matches                      |
| **Fuzzy Deduplication**       | Use MinHash/LSH to find and remove near-duplicates               |
| **URL Blocklisting**          | Exclude known low-quality or harmful domains                     |
| **Classifier-Based Filtering** | Train a classifier to distinguish high-quality vs low-quality   |
| **PII Removal**               | Detect and redact personal information                           |

### The Deduplication Problem

Duplication is a serious issue in web-scale data:

```
Without Deduplication:
─────────────────────
"The cat sat on the mat."  ← appears 50,000 times in dataset
The model memorizes this sentence instead of learning general patterns.

With Deduplication:
───────────────────
"The cat sat on the mat."  ← appears once
The model treats it as one example among millions.
```

**Why deduplication matters:**
- Prevents **memorization** of specific text
- Reduces **training compute waste**
- Improves **model generalization**
- Prevents **benchmark contamination** (training on test data)

### Data Mixing

After cleaning, data from different sources is **mixed in specific proportions**:

```
Example Data Mix (Hypothetical):

  Web Pages:        50%   ████████████████████████████████████
  Code:             15%   ██████████
  Books:            10%   ███████
  Wikipedia:         8%   █████
  Research Papers:   7%   █████
  Conversations:     5%   ███
  Math/Science:      5%   ███
                   ─────
                   100%
```

The **data mix ratio is one of the most carefully tuned hyperparameters** in LLM training. It directly affects what the model is good at.

---

## Phase 3 — Tokenization

### The Core Problem

Computers do not understand text. They understand numbers.

**Tokenization** is the process of converting text into a sequence of integers that the model can process.

```
"I love artificial intelligence"

          │  Tokenization
          ▼

["I", " love", " artificial", " intelligence"]

          │  Vocabulary Lookup
          ▼

[40, 2842, 11471, 8531]
```

### Why Not Just Use Characters?

```
Character-level:  "Hello" → ['H', 'e', 'l', 'l', 'o'] → 5 tokens
Word-level:       "Hello" → ['Hello']                   → 1 token
Subword-level:    "unhappiness" → ['un', 'happiness']   → 2 tokens
```

| Approach       | Pros                            | Cons                                    |
|----------------|---------------------------------|-----------------------------------------|
| Character      | Tiny vocabulary (~256)          | Very long sequences, slow training      |
| Word           | Intuitive, short sequences      | Huge vocabulary, can't handle new words |
| **Subword**    | Balanced vocabulary & sequence  | **Best tradeoff — used by all LLMs**    |

### Subword Tokenization — The Industry Standard

Modern LLMs use **subword tokenization**. This means:

- Common words stay as single tokens: `"the"` → `["the"]`
- Rare words are split into subwords: `"tokenization"` → `["token", "ization"]`
- Unknown words can always be represented: `"Subramani"` → `["Sub", "ram", "ani"]`

### The Three Major Tokenization Algorithms

#### 1. Byte Pair Encoding (BPE)

**Used by:** GPT-2, GPT-3, GPT-4, LLaMA, Mistral

**How BPE works (step-by-step):**

```
Step 1: Start with individual characters as the vocabulary

   Corpus: "low lower newest widest"

   Initial vocabulary: {l, o, w, e, r, n, s, t, d, i, _}
   (where _ = word boundary)

Step 2: Count the most frequent pair of adjacent symbols

   Most frequent pair: (e, s) → appears 2 times

Step 3: Merge the most frequent pair into a new token

   New token: "es"
   Vocabulary: {l, o, w, e, r, n, s, t, d, i, _, es}

Step 4: Repeat Steps 2-3 for N iterations (N = desired vocab size)

   Next merge: (es, t) → "est"
   Next merge: (l, o) → "lo"
   Next merge: (lo, w) → "low"
   ...
```

**The result:** A vocabulary of subword tokens that efficiently represent the training corpus.

#### 2. WordPiece

**Used by:** BERT, DistilBERT

**Key difference from BPE:**
- BPE merges the **most frequent** pair
- WordPiece merges the pair that **maximizes the likelihood** of the training data

```
WordPiece Score for pair (a, b):

                    count(ab)
   score(a, b) = ─────────────────
                  count(a) × count(b)

The pair with the highest score gets merged.
```

#### 3. SentencePiece

**Used by:** LLaMA, T5, ALBERT, Gemma

**Key difference:** Treats the input as a **raw byte stream** (not pre-tokenized words). This means:
- No need for language-specific pre-processing
- Works for any language (Chinese, Japanese, Hindi, etc.)
- Treats spaces as regular characters (uses ▁ to mark word boundaries)

```
SentencePiece Example:

Input:  "I love AI"
Output: ["▁I", "▁love", "▁AI"]

The ▁ marks the beginning of a word.
```

### Tokenization Comparison

```
Input: "The transformer architecture is revolutionary"

BPE (GPT-4):
   ["The", " transform", "er", " architecture", " is", " revolutionary"]
   → 6 tokens

WordPiece (BERT):
   ["The", "transform", "##er", "architecture", "is", "revolution", "##ary"]
   → 7 tokens

SentencePiece (LLaMA):
   ["▁The", "▁transform", "er", "▁architecture", "▁is", "▁revolution", "ary"]
   → 7 tokens
```

### Special Tokens

Every tokenizer includes special tokens with specific meanings:

| Token       | Purpose                                        | Example                 |
|-------------|------------------------------------------------|-------------------------|
| `<BOS>`     | Beginning of sequence                          | Start of a new text     |
| `<EOS>`     | End of sequence                                | End of generated text   |
| `<PAD>`     | Padding (fill to equal length)                 | Batch processing        |
| `<UNK>`     | Unknown token (rare in subword tokenizers)     | Fallback for unknowns   |
| `<SEP>`     | Separator between segments                     | Question + Context      |
| `<MASK>`    | Masked token (for MLM training)                | Used in BERT-style      |

### Tokenization in Practice (Python)

```python
# Using HuggingFace Transformers

from transformers import AutoTokenizer

# Load GPT-2 tokenizer (BPE)
tokenizer = AutoTokenizer.from_pretrained("gpt2")

text = "I love artificial intelligence"
tokens = tokenizer.encode(text)
decoded = tokenizer.decode(tokens)

print(f"Text:    {text}")
print(f"Tokens:  {tokens}")          # [40, 2842, 11471, 8531]
print(f"Decoded: {decoded}")          # I love artificial intelligence

# See individual tokens
print(tokenizer.tokenize(text))       # ['I', ' love', ' artificial', ' intelligence']
```

---

## Phase 4 — Vocabulary Creation

### What Is a Vocabulary?

The vocabulary is a **fixed mapping between tokens and integer IDs**. Once created, it does not change during training.

```
┌─────────────────────────────────────────┐
│            VOCABULARY TABLE              │
├──────────────────┬──────────────────────┤
│     Token        │     Token ID         │
├──────────────────┼──────────────────────┤
│     <PAD>        │       0              │
│     <BOS>        │       1              │
│     <EOS>        │       2              │
│     <UNK>        │       3              │
│     the          │       4              │
│     is           │       5              │
│     a            │       6              │
│     of           │       7              │
│     to           │       8              │
│     and          │       9              │
│     I            │      104             │
│     Python       │      802             │
│     love         │     5892             │
│     AI           │     2201             │
│     Hello        │       54             │
│     ...          │      ...             │
│     ▁revolution  │    28941             │
│     ...          │      ...             │
├──────────────────┼──────────────────────┤
│    TOTAL         │  32,000 - 150,000+   │
└──────────────────┴──────────────────────┘
```

### Vocabulary Sizes of Real Models

| Model            | Vocabulary Size | Tokenizer Type   |
|------------------|-----------------|------------------|
| GPT-2            | 50,257          | BPE              |
| GPT-3/GPT-4      | 100,277         | BPE (tiktoken)   |
| BERT             | 30,522          | WordPiece        |
| LLaMA 2          | 32,000          | SentencePiece    |
| LLaMA 3          | 128,256         | BPE (tiktoken)   |
| Gemma            | 256,000         | SentencePiece    |
| Mistral          | 32,000          | SentencePiece    |

### Why Vocabulary Size Matters

```
Small Vocabulary (e.g., 8,000 tokens):
─────────────────────────────────────
+ Smaller embedding matrix → less memory
- More tokens per sentence → longer sequences → slower
- Common words get split too aggressively

Large Vocabulary (e.g., 256,000 tokens):
────────────────────────────────────────
+ Fewer tokens per sentence → shorter sequences → faster
+ Better multilingual coverage
- Larger embedding matrix → more memory
- Some tokens may rarely appear → undertrained embeddings

The sweet spot depends on the training data, languages, and model size.
```

### The Vocabulary → Embedding Connection

Once the vocabulary is fixed:

```
Every token ID     →     One row in the Embedding Matrix

Token "Python" → ID 802 → Embedding Matrix Row 802 → [0.42, -1.13, 0.76, ..., 0.08]
                                                         └─────── 768 dimensions ──────┘
```

The embedding matrix has shape:

```
[Vocabulary Size × Embedding Dimension]

Example: [32,000 × 4,096] = 131 million parameters just for embeddings
```

---

## Phase 5 — Embedding Layer

### What Are Embeddings?

Token IDs are just integers. They carry no meaning.

The **embedding layer** converts each token ID into a **dense vector** (a list of floating-point numbers) that captures semantic meaning.

```
Token ID: 802 (Python)

                    ┌─────────────────────────────┐
                    │  Embedding Lookup Table       │
                    ├────────┬────────────────────┤
                    │ ID 0   │ [0.12, -0.34, ...] │
                    │ ID 1   │ [0.56,  0.78, ...] │
                    │ ...    │ ...                  │
                    │ ID 802 │ [0.42, -1.13, 0.76, │ ← This row
                    │        │  ..., 0.08]         │
                    │ ...    │ ...                  │
                    │ ID 31999│ [0.91, -0.22, ...]│
                    └────────┴────────────────────┘

Output: [0.42, -1.13, 0.76, ..., 0.08]
         └───────── d_model dimensions ──────────┘
```

### Embedding Dimensions in Real Models

| Model       | Embedding Dimension (d_model) | Parameters in Embedding Layer |
|-------------|-------------------------------|-------------------------------|
| GPT-2 Small | 768                           | ~38.6M                        |
| GPT-2 Large | 1,280                         | ~64.3M                        |
| GPT-3       | 12,288                        | ~1.23B                        |
| LLaMA 2 7B  | 4,096                         | ~131M                         |
| LLaMA 2 70B | 8,192                         | ~262M                         |
| GPT-4 (est.)| ~12,288                       | ~1.2B+                        |

### Why Embeddings Work

The key insight: **similar words end up with similar vectors**.

```
Vector Space (simplified to 2D):

        ▲
        │
   king ●─ ─ ─ ─ ─ ─ ─ ─ ─● queen
        │                    │
        │   (same offset)    │
        │                    │
   man  ●─ ─ ─ ─ ─ ─ ─ ─ ─● woman
        │
        └─────────────────────────────▶

   king - man + woman ≈ queen
```

This is called the **embedding space**. Words with similar meanings cluster together.

### Token Embeddings in Practice

```python
import torch
import torch.nn as nn

# Create an embedding layer
vocab_size = 32000
d_model = 4096

embedding = nn.Embedding(vocab_size, d_model)

# Convert token IDs to embeddings
token_ids = torch.tensor([104, 5892, 2201])  # "I love AI"
embedded = embedding(token_ids)

print(embedded.shape)  # torch.Size([3, 4096])
# Each of the 3 tokens is now a 4096-dimensional vector
```

### How Embeddings Are Learned

Embeddings are **not hard-coded**. They are **learned during training**.

```
Before Training:
   "king"  → [0.52, -0.11, 0.33, ...]   (random)
   "queen" → [0.89,  0.42, -0.67, ...]   (random)

After Training:
   "king"  → [0.82, 0.45, -0.23, ...]
   "queen" → [0.79, 0.48, -0.21, ...]    (very similar to king!)

The model learns to place semantically similar tokens
close together in the embedding space.
```

---

## Phase 6 — Positional Encoding

### The Problem

Transformers process all tokens **simultaneously** (in parallel), unlike RNNs which process sequentially.

This means the Transformer has **no inherent sense of word order**.

```
Without positional information:

   "Dog bites man"    ← Same bag of tokens
   "Man bites dog"    ← Same bag of tokens

   The Transformer sees these as IDENTICAL.
   But they have COMPLETELY different meanings.
```

### The Solution

Add **positional encoding** to each token embedding so the model knows the position of each token.

```
Final Input = Token Embedding + Positional Encoding

Token Embedding:        [0.42, -1.13,  0.76, ..., 0.08]
                                    +
Positional Encoding:    [0.00,  1.00,  0.00, ..., 0.84]
                                    =
Final Input:            [0.42, -0.13,  0.76, ..., 0.92]
```

### Types of Positional Encoding

#### 1. Sinusoidal Positional Encoding (Original Transformer)

Uses sine and cosine functions of different frequencies:

```
PE(pos, 2i)     = sin(pos / 10000^(2i/d_model))
PE(pos, 2i+1)   = cos(pos / 10000^(2i/d_model))

Where:
   pos   = position of the token in the sequence (0, 1, 2, ...)
   i     = dimension index
   d_model = embedding dimension
```

```
Position 0: [sin(0), cos(0), sin(0), cos(0), ...]  = [0.0, 1.0, 0.0, 1.0, ...]
Position 1: [sin(1), cos(1), sin(0.0001), cos(0.0001), ...]
Position 2: [sin(2), cos(2), sin(0.0002), cos(0.0002), ...]
...
```

**Used by:** Original Transformer (Vaswani et al., 2017)

#### 2. Learned Positional Embeddings

Instead of using a fixed mathematical formula, **learn** the position embeddings during training.

```python
position_embedding = nn.Embedding(max_sequence_length, d_model)
# E.g., nn.Embedding(2048, 768) for GPT-2
```

**Used by:** GPT-2, GPT-3, BERT

#### 3. Rotary Positional Embeddings (RoPE)

Encodes position by **rotating** the embedding vectors. This allows the model to capture **relative positions** between tokens.

```
Key insight of RoPE:

Instead of ADDING position to the embedding,
ROTATE the embedding in 2D subspaces.

The angle of rotation depends on the position.

This way, the dot product between two token embeddings
naturally encodes their relative distance.
```

**Used by:** LLaMA, LLaMA 2, LLaMA 3, Mistral, Gemma, Qwen, most modern LLMs

#### 4. ALiBi (Attention with Linear Biases)

Instead of modifying embeddings, ALiBi adds a **linear bias** directly to the attention scores based on the distance between tokens.

```
Attention Score = Q · K^T + bias

Where bias = -m × |position_i - position_j|

m is a head-specific slope
```

**Used by:** BLOOM, MPT

### Comparison of Positional Encoding Methods

| Method       | Type          | Extrapolation | Used By               |
|--------------|---------------|---------------|-----------------------|
| Sinusoidal   | Fixed         | Limited       | Original Transformer  |
| Learned      | Trainable     | Limited       | GPT-2, GPT-3, BERT   |
| **RoPE**     | Rotary        | **Good**      | **LLaMA, Mistral, most modern LLMs** |
| ALiBi        | Attention Bias| Good          | BLOOM, MPT            |

> **Modern trend:** RoPE has become the dominant choice because it handles **longer sequences** and **relative positioning** better than other methods.

---

## Phase 7 — Transformer Decoder Architecture

### Overview

The Transformer Decoder is the **brain** of every modern LLM. It consists of multiple identical layers (called **decoder blocks**) stacked on top of each other.

```
Input Embeddings + Positional Encoding
              │
              ▼
     ┌─────────────────┐
     │ Decoder Block 1  │
     └────────┬────────┘
              ▼
     ┌─────────────────┐
     │ Decoder Block 2  │
     └────────┬────────┘
              ▼
     ┌─────────────────┐
     │ Decoder Block 3  │
     └────────┬────────┘
              ▼
             ...
              ▼
     ┌─────────────────┐
     │ Decoder Block N  │ ← N = 32 for LLaMA 2 7B
     └────────┬────────┘   N = 80 for LLaMA 2 70B
              ▼          N = 96 for GPT-3
     ┌─────────────────┐
     │  Linear + Softmax│ → Probability over vocabulary
     └─────────────────┘
```

### Inside a Single Decoder Block

```
┌──────────────────────────────────────────────────────────┐
│                   DECODER BLOCK                           │
│                                                           │
│   Input                                                   │
│     │                                                     │
│     ├──────────────────────────────┐  (Residual Connection)│
│     │                              │                      │
│     ▼                              │                      │
│   ┌─────────────────────────┐      │                      │
│   │    RMSNorm / LayerNorm  │      │                      │
│   └───────────┬─────────────┘      │                      │
│               ▼                    │                      │
│   ┌─────────────────────────┐      │                      │
│   │  Masked Multi-Head       │      │                      │
│   │  Self-Attention          │      │                      │
│   └───────────┬─────────────┘      │                      │
│               ▼                    │                      │
│           ADD  ◄───────────────────┘                      │
│               │                                           │
│     ├──────────────────────────────┐  (Residual Connection)│
│     │                              │                      │
│     ▼                              │                      │
│   ┌─────────────────────────┐      │                      │
│   │    RMSNorm / LayerNorm  │      │                      │
│   └───────────┬─────────────┘      │                      │
│               ▼                    │                      │
│   ┌─────────────────────────┐      │                      │
│   │  Feed-Forward Network    │      │                      │
│   │  (SwiGLU / GELU / ReLU) │      │                      │
│   └───────────┬─────────────┘      │                      │
│               ▼                    │                      │
│           ADD  ◄───────────────────┘                      │
│               │                                           │
│               ▼                                           │
│            Output                                         │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

### Multi-Head Self-Attention (The Key Mechanism)

This is where the model learns **which tokens should pay attention to which other tokens**.

#### Step 1: Create Q, K, V Matrices

```
For each token embedding X:

   Q = X × W_Q    (Query  — "What am I looking for?")
   K = X × W_K    (Key    — "What do I contain?")
   V = X × W_V    (Value  — "What information do I provide?")

Where:
   X   has shape [seq_len × d_model]
   W_Q has shape [d_model × d_k]
   W_K has shape [d_model × d_k]
   W_V has shape [d_model × d_v]
```

#### Step 2: Compute Attention Scores

```
                    Q × K^T
Attention(Q,K,V) = ─────────  then Softmax  then × V
                     √d_k

Step by step:

1. Scores = Q × K^T                    → [seq_len × seq_len]
2. Scaled = Scores / √d_k              → Prevent large values
3. Masked = Apply causal mask           → Can't see future tokens
4. Weights = Softmax(Masked)            → Normalize to probabilities
5. Output = Weights × V                → Weighted combination of values
```

#### Step 3: Causal Masking (Critical for Autoregressive LLMs)

```
The causal mask ensures each token can only attend to
tokens BEFORE it (including itself), never to future tokens.

Example for sequence "I love AI":

              I     love    AI
   I      [ 1.0    -∞      -∞   ]     ← "I" only sees itself
   love   [ 0.3    0.7     -∞   ]     ← "love" sees "I" and itself
   AI     [ 0.1    0.2     0.7  ]     ← "AI" sees all previous tokens

-∞ becomes 0 after softmax (masked out)
```

#### Step 4: Multi-Head (Why Multiple Heads?)

Instead of one large attention computation, we split into **multiple heads**:

```
Each head learns different patterns:

Head 1: Syntactic relationships    ("the" attends to "cat" — noun agreement)
Head 2: Semantic relationships     ("king" attends to "queen" — similar meaning)
Head 3: Positional patterns        (each token attends to its neighbor)
Head 4: Long-range dependencies    ("it" attends to "the company" far away)
...

All heads run in parallel, then concatenate:

MultiHead(Q,K,V) = Concat(head_1, head_2, ..., head_h) × W_O
```

### Feed-Forward Network (FFN)

After attention, each token passes through a position-wise feed-forward network:

```
Classic FFN:
   FFN(x) = ReLU(x × W_1 + b_1) × W_2 + b_2

Modern FFN (SwiGLU — used by LLaMA, Mistral, Gemma):
   FFN(x) = (Swish(x × W_gate) ⊙ (x × W_up)) × W_down

Where:
   W_1, W_gate, W_up have shape [d_model × d_ff]
   W_2, W_down      have shape [d_ff × d_model]
   d_ff = 4 × d_model (typically)
   ⊙ = element-wise multiplication
```

### Normalization

| Technique     | Formula                                    | Used By                    |
|---------------|--------------------------------------------|----------------------------|
| LayerNorm     | (x - μ) / σ × γ + β                       | GPT-2, GPT-3, BERT        |
| **RMSNorm**   | x / RMS(x) × γ                            | **LLaMA, Mistral, Gemma** |
| Pre-Norm      | Normalize BEFORE attention/FFN             | Most modern LLMs           |
| Post-Norm     | Normalize AFTER attention/FFN              | Original Transformer       |

> **Modern trend:** RMSNorm with Pre-Norm is the standard in current LLMs.

### Model Specifications

| Component          | GPT-2 Small | GPT-3     | LLaMA 2 7B | LLaMA 2 70B |
|--------------------|-------------|-----------|-------------|--------------|
| Layers (N)         | 12          | 96        | 32          | 80           |
| d_model            | 768         | 12,288    | 4,096       | 8,192        |
| Attention Heads     | 12          | 96        | 32          | 64           |
| d_ff (FFN)         | 3,072       | 49,152    | 11,008      | 28,672       |
| Context Length      | 1,024       | 2,048     | 4,096       | 4,096        |
| Total Parameters   | 124M        | 175B      | 6.7B        | 70B          |

---

## Phase 8 — Next-Token Prediction & Decoding

### The Core Task

An LLM is trained to do **one thing**: predict the next token.

```
Input:  "The capital of France is"
                                    │
                    ┌───────────────┘
                    ▼
              ┌──────────┐
              │   LLM     │
              └─────┬────┘
                    ▼
              Logits (raw scores for every token in vocabulary)

              Token       Logit
              Paris        8.5
              Lyon         3.2
              the          1.1
              Berlin      -0.3
              ...         ...

                    │  Softmax
                    ▼

              Token       Probability
              Paris        92%
              Lyon          3%
              the           2%
              Berlin        1%
              ...          ...
```

### Decoding Strategies

Once the model produces probabilities, how do we choose the next token?

#### 1. Greedy Decoding

Always pick the token with the **highest probability**.

```
Step 1: "The capital of France is" → "Paris"   (92%)
Step 2: "The capital of France is Paris" → "."  (78%)

Simple but can produce repetitive, boring text.
```

#### 2. Beam Search

Keep track of the **top-k most likely sequences** at each step.

```
Beam Width = 3

Step 1:  "... is"  →  "Paris"  (92%)
                   →  "Lyon"   (3%)
                   →  "the"    (2%)

Step 2:  "... Paris"  →  "."     (78%)
         "... Paris"  →  ","     (15%)
         "... Lyon"   →  "."     (60%)

Pick the sequence with the highest total probability.
```

#### 3. Top-k Sampling

Sample from only the **top k most probable** tokens.

```
k = 5

Original distribution:
   Paris (92%), Lyon (3%), the (2%), Berlin (1%), France (0.5%), ...

After top-k filtering (keep top 5, redistribute):
   Paris (94.9%), Lyon (3.1%), the (1.0%), Berlin (0.5%), France (0.5%)

Then randomly sample from these 5 tokens.
```

#### 4. Top-p (Nucleus) Sampling

Sample from the **smallest set of tokens** whose cumulative probability ≥ p.

```
p = 0.95

Sorted probabilities:
   Paris (92%) → cumulative: 92%
   Lyon  (3%)  → cumulative: 95%  ← Stop here (≥ 0.95)

Nucleus = {Paris, Lyon}
Sample from these two tokens.
```

#### 5. Temperature

Controls how "random" or "creative" the sampling is.

```
Temperature T applied to logits before softmax:

   P(token_i) = exp(logit_i / T) / Σ exp(logit_j / T)

T = 0.1  → Very confident, almost deterministic (like greedy)
T = 1.0  → Normal distribution (as trained)
T = 2.0  → Very spread out, more random/creative

Visualization:

   T = 0.1:  Paris ████████████████████████████████ 99.9%
              Lyon  ▏ 0.1%

   T = 1.0:  Paris ████████████████████████ 92%
              Lyon  ██ 3%
              the   █ 2%

   T = 2.0:  Paris ██████████████ 55%
              Lyon  ████ 15%
              the   ███ 10%
              Berlin██ 8%
```

### Autoregressive Generation

LLMs generate text **one token at a time**, feeding each generated token back as input:

```
Step 1: Input: "Once upon"         → Predict: "a"
Step 2: Input: "Once upon a"       → Predict: "time"
Step 3: Input: "Once upon a time"  → Predict: ","
Step 4: Input: "Once upon a time," → Predict: "there"
...

This continues until:
   - <EOS> token is generated
   - Maximum length is reached
   - A stop condition is met
```

---

## Phase 9 — Loss Function

### Cross-Entropy Loss

The standard loss function for language modeling is **cross-entropy loss**.

It measures how different the model's predicted probability distribution is from the true distribution.

```
True distribution (one-hot):
   Token:       [pizza, rice, burgers, apples, ...]
   True:        [1,     0,    0,       0,      ...]   ← "pizza" is correct

Predicted distribution:
   Predicted:   [0.45,  0.20, 0.10,    0.05,   ...]

Cross-Entropy Loss = -Σ y_true × log(y_pred)
                   = -1 × log(0.45)
                   = -log(0.45)
                   = 0.798

If the model predicted 0.99 for pizza:
   Loss = -log(0.99) = 0.01  ← Very small loss (good!)

If the model predicted 0.01 for pizza:
   Loss = -log(0.01) = 4.61  ← Very large loss (bad!)
```

### Perplexity

Perplexity is the standard metric for evaluating language models. It is the exponential of the average cross-entropy loss.

```
Perplexity = exp(average cross-entropy loss)

Perplexity = 1    → Perfect prediction (impossible in practice)
Perplexity = 10   → On average, the model is as confused as choosing between 10 equally likely tokens
Perplexity = 100  → Very uncertain
```

| Model (Approximate) | Perplexity (on benchmarks) |
|----------------------|----------------------------|
| GPT-2               | ~30-35                     |
| GPT-3               | ~20-25                     |
| LLaMA 2 7B          | ~5-7                       |
| Modern LLMs         | ~3-5                       |

### How Loss Drives Learning

```
High Loss (early training):
   Model predicts: "Java" when the true answer is "Python"
   Loss = -log(P("Python")) = very large
   → Large gradients → Big weight updates → Model learns

Low Loss (late training):
   Model predicts: "Python" with high confidence
   Loss = -log(0.95) = 0.05
   → Small gradients → Small weight updates → Model fine-tunes
```

---

## Phase 10 — Backpropagation

### What Is Backpropagation?

Backpropagation is the algorithm that computes **how much each weight contributed to the error** and calculates the **gradient** (direction of steepest increase in loss) for every parameter.

```
Forward Pass:
────────────
   Input → Embeddings → Decoder Blocks → Logits → Loss

   The model makes a prediction and we compute the loss.

Backward Pass (Backpropagation):
───────────────────────────────
   Loss → Gradients flow backward → Every weight gets a gradient

   ∂Loss/∂W for every weight W in the model
```

### Chain Rule

Backpropagation uses the **chain rule** from calculus:

```
If Loss depends on output, which depends on hidden, which depends on weights:

   ∂Loss     ∂Loss     ∂output     ∂hidden
   ───── = ─────── × ───────── × ──────────
   ∂W      ∂output    ∂hidden      ∂W

Each layer multiplies its local gradient and passes it backward.
```

### Gradient Flow Through the Decoder

```
Loss
  │
  ▼ ∂Loss/∂logits
Linear Layer (output projection)
  │
  ▼ ∂Loss/∂hidden_N
Decoder Block N
  │
  ▼ ∂Loss/∂hidden_(N-1)
Decoder Block N-1
  │
  ▼
 ...
  │
  ▼ ∂Loss/∂hidden_1
Decoder Block 1
  │
  ▼ ∂Loss/∂embeddings
Embedding Layer

Every parameter in every layer gets updated.
For a 7B parameter model, that's 7 BILLION gradients computed.
```

### The Vanishing/Exploding Gradient Problem

```
Without residual connections:

   Layer 1 gradient = g
   Layer 2 gradient = g × a
   Layer 3 gradient = g × a × a
   ...
   Layer 32 gradient = g × a^31

   If a < 1: gradients vanish (shrink to ~0)
   If a > 1: gradients explode (grow to infinity)

With residual connections (skip connections):

   Output = Layer(x) + x    ← The "+ x" ensures gradient ≥ 1

   This is why residual connections are ESSENTIAL in deep networks.
```

---

## Phase 11 — Optimizer

### What Does the Optimizer Do?

The optimizer uses the computed gradients to **update the model weights** in a direction that reduces the loss.

```
Basic Rule:

   W_new = W_old - learning_rate × gradient

   If gradient is positive → decrease W (to reduce loss)
   If gradient is negative → increase W (to reduce loss)
```

### Stochastic Gradient Descent (SGD)

The simplest optimizer:

```
W = W - lr × ∂Loss/∂W

Problems:
- Gets stuck in local minima
- Same learning rate for all parameters
- Noisy updates
```

### Adam (Adaptive Moment Estimation)

The most popular optimizer for deep learning:

```
Adam maintains two running averages for each parameter:

   m = β₁ × m + (1 - β₁) × gradient          ← 1st moment (mean of gradients)
   v = β₂ × v + (1 - β₂) × gradient²         ← 2nd moment (variance of gradients)

   m̂ = m / (1 - β₁^t)                         ← Bias-corrected 1st moment
   v̂ = v / (1 - β₂^t)                         ← Bias-corrected 2nd moment

   W = W - lr × m̂ / (√v̂ + ε)

Where:
   β₁ = 0.9   (typical)
   β₂ = 0.999 (typical)
   ε  = 1e-8  (small number to prevent division by zero)
   lr = learning rate
```

### AdamW (Adam with Weight Decay)

**Used by most modern LLMs** (GPT, LLaMA, Mistral, etc.)

```
AdamW separates weight decay from the gradient update:

   W = W - lr × (m̂ / (√v̂ + ε) + λ × W)

Where λ is the weight decay factor (typically 0.01 - 0.1)

Why AdamW?
- Better generalization than Adam
- Proper weight decay regularization
- Standard choice for LLM training
```

### Learning Rate Schedule

The learning rate is not constant during training. It follows a **schedule**:

```
Learning Rate Schedule (Typical for LLM Training):

  lr
  │
  │        ╱╲
  │       ╱  ╲
  │      ╱    ╲
  │     ╱      ╲──────────────────────── Cosine Decay
  │    ╱                                    ╲
  │   ╱                                      ╲
  │  ╱                                        ╲
  │ ╱                                          ╲
  │╱                                            ╲
  └────────────────────────────────────────────────── steps
   ↑ Warmup                    Training
   (1-2% of total steps)
```

**Warmup:** Start with a very small learning rate and gradually increase it. This stabilizes early training.

**Cosine Decay:** After warmup, gradually decrease the learning rate following a cosine curve.

### Typical Hyperparameters for LLM Training

| Hyperparameter      | Typical Value          | Purpose                                |
|----------------------|------------------------|----------------------------------------|
| Learning Rate (peak) | 1e-4 to 3e-4          | Controls step size                     |
| Warmup Steps         | 1,000 - 2,000         | Stabilize early training               |
| Weight Decay (λ)     | 0.01 - 0.1            | Regularization                         |
| β₁                   | 0.9                   | Momentum for gradient mean             |
| β₂                   | 0.95 - 0.999          | Momentum for gradient variance         |
| Batch Size           | 1M - 4M tokens        | Number of tokens processed per step    |
| Gradient Clipping    | 1.0                   | Prevent exploding gradients            |

---

## Phase 12 — GPU & Distributed Training

### Why GPUs?

```
CPU vs GPU for Matrix Multiplication:

CPU (16 cores):
   Matrix [4096 × 4096] × [4096 × 4096]
   Time: ~500 ms

GPU (thousands of cores):
   Same computation
   Time: ~0.5 ms

GPUs are ~1000× faster for the parallel math that deep learning requires.
```

### GPU Memory Requirements

```
Model Parameters → Memory Needed

7B parameters in FP16:
   7 × 10⁹ × 2 bytes = 14 GB  ← Just for the weights

Plus:
   Gradients:        14 GB
   Optimizer states:  28 GB (Adam stores m and v for each parameter)
   Activations:      Variable (depends on batch size and sequence length)

Total for 7B model: ~80-100 GB  ← Doesn't fit on a single GPU!

For 70B model:    ~800-1000 GB  ← Needs 10-20 GPUs minimum
For 175B model:   ~3000+ GB    ← Needs hundreds of GPUs
```

### Common GPUs Used for LLM Training

| GPU              | Memory  | FP16 TFLOPS | Typical Use               |
|------------------|---------|-------------|---------------------------|
| NVIDIA A100      | 80 GB   | 312         | Standard for LLM training |
| NVIDIA H100      | 80 GB   | 989         | Current generation        |
| NVIDIA H200      | 141 GB  | 989         | High-memory variant       |
| NVIDIA B200      | 192 GB  | 2,250       | Next generation (2025+)   |
| Google TPU v5e   | 16 GB   | 197         | Google's custom chips      |
| Google TPU v5p   | 95 GB   | 459         | High-performance variant   |

### Distributed Training Strategies

When a model doesn't fit on one GPU, we use **parallelism**:

#### 1. Data Parallelism

```
Same model copied to multiple GPUs.
Each GPU processes a different batch of data.
Gradients are averaged across GPUs.

   GPU 0:  Model Copy → Batch 0 → Gradients
   GPU 1:  Model Copy → Batch 1 → Gradients
   GPU 2:  Model Copy → Batch 2 → Gradients
   GPU 3:  Model Copy → Batch 3 → Gradients
                    │
                    ▼
            Average Gradients → Update All Copies

Pro:  Simple, scales well
Con:  Model must fit on each GPU (doesn't work for very large models)
```

#### 2. Tensor Parallelism

```
Split individual layers across multiple GPUs.

Example: Split a [4096 × 16384] weight matrix across 4 GPUs:

   GPU 0:  [4096 × 4096]  ← First quarter
   GPU 1:  [4096 × 4096]  ← Second quarter
   GPU 2:  [4096 × 4096]  ← Third quarter
   GPU 3:  [4096 × 4096]  ← Fourth quarter

Each GPU computes its portion, then results are combined.

Pro:  Can train very large layers
Con:  Requires fast inter-GPU communication
```

#### 3. Pipeline Parallelism

```
Split different layers across different GPUs.

   GPU 0:  Layers 1-8    ← First group of layers
   GPU 1:  Layers 9-16   ← Second group
   GPU 2:  Layers 17-24  ← Third group
   GPU 3:  Layers 25-32  ← Fourth group

Data flows through GPUs sequentially (pipeline).

Pro:  Straightforward to implement
Con:  Pipeline bubbles (some GPUs idle while waiting)
```

#### 4. Fully Sharded Data Parallelism (FSDP)

```
Shard (split) the model parameters, gradients, AND optimizer states
across all GPUs. Each GPU only stores a fraction.

When a layer is needed:
1. All GPUs gather the full parameters for that layer
2. Compute forward/backward
3. Discard the parameters (only keep the shard)

Pro:  Maximum memory efficiency
Con:  High communication overhead
```

### Training Infrastructure at Scale

```
Training LLaMA 2 70B (approximate):

   GPUs:           2,048 × NVIDIA A100 80GB
   Training Time:  ~1,720,320 GPU-hours
   Data:           2 trillion tokens
   Cost:           Estimated $2-5 million+ in compute

Training GPT-4 (estimated):

   GPUs:           ~10,000-25,000 GPUs
   Training Time:  ~3-6 months
   Cost:           Estimated $50-100+ million in compute
```

### Mixed Precision Training

To save memory and increase speed, modern training uses multiple number formats:

```
FP32 (32-bit float):  1 sign + 8 exponent + 23 mantissa = 4 bytes
FP16 (16-bit float):  1 sign + 5 exponent + 10 mantissa = 2 bytes
BF16 (bfloat16):      1 sign + 8 exponent +  7 mantissa = 2 bytes

Strategy:
   - Keep master weights in FP32 (for precision)
   - Do forward/backward in BF16 (for speed and memory)
   - Gradients in BF16
   - Optimizer states in FP32

This reduces memory by ~50% with minimal quality loss.
```

---

## Phase 13 — The Pretrained Model

### What the Pretrained Model Knows

After training on trillions of tokens, the model has learned:

```
┌─────────────────────────────────────────────────────────┐
│          CAPABILITIES OF A PRETRAINED LLM                │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  📝 Language          Grammar, syntax, semantics         │
│  🌍 World Knowledge   Facts, history, geography         │
│  💻 Programming       Python, JavaScript, C++, etc.     │
│  🔢 Mathematics       Arithmetic, algebra, calculus     │
│  🔬 Science           Physics, chemistry, biology       │
│  🧠 Reasoning         Logic, inference, planning       │
│  🌐 Multilingual      Many languages                    │
│  📊 Structured Data   JSON, XML, tables, code          │
│  📖 Summarization     Condensing long text              │
│  ✍️ Writing           Different styles and formats      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### What the Pretrained Model Cannot Do Well (Yet)

```
❌ Follow specific instructions reliably
❌ Refuse harmful requests
❌ Maintain a consistent persona
❌ Have multi-turn conversation skills
❌ Admit when it doesn't know something
❌ Avoid hallucinations

These capabilities require Fine-Tuning and Alignment (next phases).
```

### Pretraining Objective: Next Token Prediction

The entire pretraining process optimizes a single objective:

```
Given: "The Eiffel Tower is located in"
Predict: "Paris"

Given: "def fibonacci(n):\n    if n <= 1:\n        return"
Predict: " n"

Given: "E = mc"
Predict: "²"

The model does this billions of times across trillions of tokens.
```

### The Scaling Laws

Research has shown predictable relationships between model size, data, compute, and performance:

```
Chinchilla Scaling Laws (Hoffmann et al., 2022):

   For compute-optimal training:
      Tokens ≈ 20 × Parameters

   Examples:
      7B parameter model  →  ~140B tokens (minimum)
      70B parameter model →  ~1.4T tokens (minimum)

   Modern practice often uses even more tokens:
      LLaMA 2 7B was trained on 2T tokens (14× the minimum)
```

```
Loss vs. Parameters (log scale):

  Loss
   │ ╲
   │  ╲
   │   ╲
   │    ╲
   │     ╲
   │      ╲──────────
   │
   └──────────────────── Parameters (log scale)
   1B   10B   100B  1T

More parameters → Lower loss (diminishing returns)
More data      → Lower loss
More compute   → Lower loss
```

---

## Phase 14 — Fine-Tuning

### Why Fine-Tune?

A pretrained model is a **general-purpose text predictor**. Fine-tuning adapts it for specific tasks or behaviors.

```
Pretrained Model (Base Model)
         │
         ├──→ Instruction Fine-Tuning  → Chat Assistant
         │
         ├──→ Medical Fine-Tuning      → Medical AI
         │
         ├──→ Legal Fine-Tuning        → Legal AI
         │
         ├──→ Code Fine-Tuning         → Coding Assistant
         │
         └──→ Domain Fine-Tuning       → Custom Application
```

### Types of Fine-Tuning

#### 1. Full Fine-Tuning

Update **all** parameters of the model.

```
All 7 billion parameters are trainable.

Pros:
   + Maximum flexibility
   + Best performance

Cons:
   - Requires as much memory as pretraining
   - Risk of catastrophic forgetting
   - Expensive (multiple GPU-days)
```

#### 2. LoRA (Low-Rank Adaptation)

Freeze the original weights. Add small **low-rank matrices** that are trainable.

```
Original weight matrix W [4096 × 4096] → FROZEN (not updated)

Add two small matrices:
   A [4096 × r]    ← Trainable
   B [r × 4096]    ← Trainable

Where r = rank (typically 8, 16, 32, or 64)

New computation:
   Output = x × W + x × A × B

Number of trainable parameters:
   Original: 4096 × 4096 = 16.7M per matrix
   LoRA:     4096 × 16 + 16 × 4096 = 131K per matrix  ← 128× fewer!

Total trainable parameters for 7B model with LoRA:
   ~10-50 million (vs 7 billion) = 0.1-0.7% of total
```

```
┌──────────────────────────────────────────┐
│             LoRA Architecture             │
│                                           │
│   Input x                                 │
│     │                                     │
│     ├──────────────────────┐              │
│     │                      │              │
│     ▼                      ▼              │
│  ┌──────┐            ┌──────────┐         │
│  │  W   │ (frozen)   │  A × B   │ (train) │
│  │      │            │ rank = r │         │
│  └──┬───┘            └────┬─────┘         │
│     │                     │               │
│     └─────── ADD ─────────┘               │
│              │                            │
│              ▼                            │
│           Output                          │
│                                           │
└──────────────────────────────────────────┘
```

#### 3. QLoRA (Quantized LoRA)

Combine LoRA with **quantization** to reduce memory even further.

```
Step 1: Quantize the base model from FP16 → 4-bit
   Memory: 7B × 2 bytes = 14 GB  →  7B × 0.5 bytes = 3.5 GB

Step 2: Apply LoRA adapters in BF16/FP16
   Memory: ~50-200 MB

Step 3: Fine-tune only the LoRA adapters

Total Memory: ~6-8 GB ← Fine-tune a 7B model on a SINGLE consumer GPU!
```

### Instruction Tuning

A critical fine-tuning stage that teaches the model to **follow instructions**:

```
Training Data Format:

{
  "instruction": "Summarize the following text in 3 bullet points.",
  "input": "The Renaissance was a period of cultural...",
  "output": "• The Renaissance spanned roughly the 14th-17th centuries...\n• It originated in Italy...\n• Key figures include..."
}

After instruction tuning:

   User: "Explain quantum computing to a 5-year-old"
   Model: "Imagine you have a magic coin that can be heads AND tails 
           at the same time..."

Before instruction tuning (base model):

   User: "Explain quantum computing to a 5-year-old"
   Model: "Explain quantum computing to a 10-year-old. Explain quantum 
           computing to a college student..."
           (Just continues the pattern — not helpful)
```

### Common Fine-Tuning Datasets

| Dataset          | Size    | Type                    | Purpose                    |
|------------------|---------|-------------------------|----------------------------|
| Alpaca           | 52K     | Instruction-following   | General instruction tuning |
| ShareGPT         | ~90K    | Conversations           | Chat behavior              |
| OpenAssistant    | ~160K   | Multi-turn dialogues    | Assistant training         |
| FLAN Collection  | ~15M    | Diverse NLP tasks       | Task generalization        |
| CodeAlpaca       | ~20K    | Code instructions       | Coding ability             |
| Medical QA       | Various | Medical Q&A             | Medical domain             |

---

## Phase 15 — Alignment (RLHF, DPO, SFT)

### Why Alignment Is Necessary

A fine-tuned model can follow instructions, but it might:

```
❌ Generate harmful content if asked
❌ Confidently state false information
❌ Be manipulated with adversarial prompts
❌ Produce biased or offensive responses
❌ Fail to say "I don't know" when appropriate
```

**Alignment** teaches the model to be **helpful, harmless, and honest (HHH)**.

### The Alignment Pipeline

```
Step 1: Supervised Fine-Tuning (SFT)
         │
         ▼
   Train on high-quality human-written responses
         │
         ▼
Step 2: Reward Model Training
         │
         ▼
   Train a separate model to score response quality
         │
         ▼
Step 3: Reinforcement Learning (RLHF) or Direct Preference Optimization (DPO)
         │
         ▼
   Optimize the LLM to produce responses that score highly
```

### Step 1: Supervised Fine-Tuning (SFT)

Human annotators write ideal responses:

```
Prompt: "How do I pick a lock?"

❌ Bad response:  "First, you need a tension wrench and a pick..."
✅ Good response: "I can't provide instructions for picking locks 
                    as it could be used for illegal purposes. If you're 
                    locked out, I'd recommend contacting a licensed 
                    locksmith."

The model is trained on thousands of such (prompt, ideal_response) pairs.
```

### Step 2: Reward Model Training

Human annotators **rank** multiple responses:

```
Prompt: "Explain gravity"

Response A: "Gravity is the force that attracts objects with mass 
             toward each other. On Earth, it gives weight to objects 
             and causes them to fall when dropped."

Response B: "Gravity is like a magnet but for everything. 
             Things fall down because of gravity."

Response C: "Gravity doesn't exist. The Earth sucks."

Human Ranking: A > B > C

These rankings are used to train a Reward Model:
   reward_model(prompt, response) → score (higher = better)
```

### Step 3a: RLHF (Reinforcement Learning from Human Feedback)

```
┌──────────────────────────────────────────────────────────┐
│                    RLHF Pipeline                          │
│                                                           │
│   Prompt                                                  │
│     │                                                     │
│     ▼                                                     │
│   ┌──────────┐                                            │
│   │   LLM     │ ── Generate Response                     │
│   └─────┬────┘                                            │
│         ▼                                                 │
│   ┌──────────────┐                                        │
│   │ Reward Model  │ ── Score the Response                 │
│   └──────┬───────┘                                        │
│          ▼                                                │
│   ┌──────────────────┐                                    │
│   │  PPO Algorithm    │ ── Update LLM to maximize reward  │
│   └──────────────────┘                                    │
│                                                           │
│   + KL Divergence Penalty                                 │
│     (Don't drift too far from the base model)             │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

**PPO (Proximal Policy Optimization)** is the RL algorithm used to update the LLM based on rewards.

The **KL divergence penalty** prevents the model from "gaming" the reward model by producing degenerate text that scores high but is nonsensical.

### Step 3b: DPO (Direct Preference Optimization)

DPO is a **simpler alternative** to RLHF that doesn't need a separate reward model.

```
RLHF: Train reward model → Use RL to optimize → Complex pipeline
DPO:  Directly optimize on preference pairs → Much simpler

DPO Training Data:
   (prompt, chosen_response, rejected_response)

Example:
   Prompt:   "What is 2+2?"
   Chosen:   "2+2 equals 4."
   Rejected: "2+2 is obviously 5, everyone knows that."

DPO Loss:
   Increase probability of chosen response
   Decrease probability of rejected response
   All in one training step — no RL needed
```

### Comparison: RLHF vs DPO

| Aspect            | RLHF                      | DPO                        |
|-------------------|----------------------------|----------------------------|
| Complexity        | High (3 models needed)     | Low (1 model)              |
| Training Stability| Can be unstable            | More stable                |
| Performance       | Slightly better (debated)  | Competitive                |
| Memory            | Very high                  | Moderate                   |
| Industry Adoption | GPT-4, Claude (early)      | LLaMA 3, Mistral, Gemma   |
| Reward Model      | Required                   | Not required               |

> **Modern trend:** DPO and its variants (IPO, KTO, ORPO) are increasingly preferred due to simplicity and competitive performance.

---

## Phase 16 — Deployment & Inference

### The Deployment Pipeline

```
Trained Model (Checkpoints on Disk)
         │
         ▼
   ┌─────────────────┐
   │  Optimization     │
   │  - Quantization   │ ← Reduce model size (FP16 → INT8 → INT4)
   │  - KV Cache       │ ← Speed up autoregressive generation
   │  - Flash Attention│ ← Memory-efficient attention
   │  - Speculative    │
   │    Decoding       │ ← Use small model to speed up large model
   └────────┬────────┘
            ▼
   ┌─────────────────┐
   │  Serving Engine   │
   │  - vLLM           │
   │  - TensorRT-LLM   │
   │  - Text Gen       │
   │    Inference (TGI) │
   └────────┬────────┘
            ▼
   ┌─────────────────┐
   │  API Layer        │
   │  - REST API       │
   │  - gRPC           │
   │  - WebSocket      │
   └────────┬────────┘
            ▼
   ┌─────────────────┐
   │  Load Balancer    │
   │  - Route requests │
   │  - Auto-scale     │
   └────────┬────────┘
            ▼
        Users / Apps
```

### Quantization for Deployment

```
Original Model (FP16):
   7B × 2 bytes = 14 GB

INT8 Quantization:
   7B × 1 byte = 7 GB   (2× smaller, minimal quality loss)

INT4 Quantization:
   7B × 0.5 bytes = 3.5 GB  (4× smaller, some quality loss)

GPTQ / AWQ / GGUF:
   Advanced quantization methods that minimize quality loss
```

### KV Cache (Key-Value Cache)

The most important inference optimization:

```
Without KV Cache:

   Step 1: Process "The"         → Compute attention for 1 token
   Step 2: Process "The cat"     → Recompute attention for 2 tokens
   Step 3: Process "The cat sat" → Recompute attention for 3 tokens
   ...
   Step N: Recompute ALL previous attention → O(N²) total work

With KV Cache:

   Step 1: Process "The"         → Store K,V for "The"
   Step 2: Process "cat"         → Reuse K,V for "The", compute new K,V for "cat"
   Step 3: Process "sat"         → Reuse K,V for "The","cat", compute new for "sat"
   ...
   Step N: Only compute attention for the NEW token → O(N) per step

Speedup: Massive — often 10-100× faster for long sequences
Memory: Grows linearly with sequence length
```

### Inference Serving Engines

| Engine          | Developer    | Key Features                           |
|-----------------|-------------|----------------------------------------|
| vLLM            | UC Berkeley | PagedAttention, continuous batching    |
| TensorRT-LLM   | NVIDIA      | Optimized for NVIDIA GPUs              |
| TGI             | HuggingFace | Easy deployment, token streaming       |
| Ollama          | Community   | Local deployment, consumer hardware    |
| llama.cpp       | Community   | CPU inference, GGUF quantization       |

### Deployment Architectures

```
Option 1: Cloud API
   ┌──────┐     ┌──────────┐     ┌──────────┐
   │ User │ ──→ │ API GW   │ ──→ │ GPU Server│
   └──────┘     └──────────┘     └──────────┘

Option 2: On-Premise
   ┌──────┐     ┌──────────┐     ┌──────────┐
   │ User │ ──→ │ Internal │ ──→ │ GPU Node  │
   └──────┘     │ Network  │     │ (Private) │
                └──────────┘     └──────────┘

Option 3: Edge / Local
   ┌──────────────────────┐
   │ User's Device         │
   │  ┌──────────────────┐ │
   │  │ Quantized Model   │ │
   │  │ (GGUF / ONNX)     │ │
   │  └──────────────────┘ │
   └──────────────────────┘
```

### Key Inference Metrics

| Metric                    | What It Measures                           | Target              |
|---------------------------|--------------------------------------------|---------------------|
| **Time to First Token**   | Latency before first output token          | < 500ms             |
| **Tokens per Second**     | Generation speed                           | 30-100+ tok/s       |
| **Throughput**            | Total tokens served per second (all users) | Depends on hardware |
| **Memory Usage**          | GPU memory consumed                        | Within GPU limits   |
| **Cost per 1M Tokens**    | Financial cost of serving                  | $0.15 - $60+        |

---

## Complete Technology Stack Reference

| Phase                     | Tools & Frameworks                                       |
|---------------------------|----------------------------------------------------------|
| Data Collection           | Common Crawl, wget, scrapy, trafilatura                  |
| Data Cleaning             | BeautifulSoup, fastText, MinHash, regex                  |
| Data Processing           | Apache Spark, Dask, Polars, DataTrove                    |
| Tokenization              | HuggingFace Tokenizers, SentencePiece, tiktoken          |
| Model Framework           | PyTorch, JAX, TensorFlow                                 |
| Training Framework        | DeepSpeed, FSDP, Megatron-LM, Composer                  |
| Fine-Tuning               | HuggingFace PEFT, Axolotl, LLaMA-Factory                |
| Alignment (RLHF/DPO)     | TRL (HuggingFace), OpenRLHF, DeepSpeed-Chat             |
| Evaluation                | lm-evaluation-harness, MMLU, HumanEval, MT-Bench        |
| Inference Serving         | vLLM, TensorRT-LLM, TGI, Triton Inference Server        |
| Quantization              | GPTQ, AWQ, bitsandbytes, llama.cpp (GGUF)               |
| Experiment Tracking       | Weights & Biases, MLflow, TensorBoard                    |
| Orchestration             | Kubernetes, Ray, Slurm                                   |
| Cloud Providers           | AWS, GCP, Azure, Lambda Labs, CoreWeave                  |

---

## Real-World Model Specifications

### GPT Series (OpenAI)

| Spec            | GPT-2      | GPT-3       | GPT-4 (est.)    |
|-----------------|------------|-------------|------------------|
| Parameters      | 1.5B       | 175B        | ~1.8T (MoE est.) |
| Training Tokens | ~40B       | ~300B       | ~13T             |
| Context Length   | 1,024      | 2,048       | 8K-128K          |
| Layers          | 48         | 96          | ~120 (est.)      |
| Architecture    | Decoder    | Decoder     | MoE Decoder      |

### LLaMA Series (Meta)

| Spec            | LLaMA 1 7B | LLaMA 2 13B | LLaMA 3.1 70B | LLaMA 3.1 405B |
|-----------------|------------|-------------|----------------|-----------------|
| Parameters      | 6.7B       | 13B         | 70.6B          | 405B            |
| Training Tokens | 1T         | 2T          | 15T            | 15T             |
| Context Length   | 2,048      | 4,096       | 128K           | 128K            |
| Vocab Size      | 32,000     | 32,000      | 128,256        | 128,256         |
| Heads           | 32         | 40          | 64             | 126             |
| Layers          | 32         | 40          | 80             | 126             |

### Other Notable Models

| Model          | Organization | Parameters | Open/Closed | Key Innovation           |
|----------------|-------------|------------|-------------|--------------------------|
| Gemini Ultra   | Google      | ~Unknown   | Closed      | Multimodal, long context  |
| Claude 3.5     | Anthropic   | ~Unknown   | Closed      | Constitutional AI         |
| Mistral 7B     | Mistral AI  | 7B         | Open        | Sliding window attention  |
| Mixtral 8x7B   | Mistral AI  | 46.7B MoE  | Open        | Mixture of Experts        |
| Qwen 2.5       | Alibaba     | Up to 72B  | Open        | Strong multilingual       |
| Gemma 2        | Google      | Up to 27B  | Open        | Efficient architecture    |
| DeepSeek-V3    | DeepSeek    | 671B MoE   | Open        | Cost-efficient training   |
| Phi-3          | Microsoft   | Up to 14B  | Open        | Small but capable         |

---

## Learning Roadmap & Next Steps

### Recommended Study Order

```
✅ COMPLETED: Transformer Architecture
✅ COMPLETED: Complete LLM Development Pipeline (this document)

NEXT TOPICS:
──────────────

1. Tokenization Deep Dive
   └─ BPE algorithm implementation
   └─ SentencePiece internals
   └─ Hands-on: Train your own tokenizer

2. Attention Mathematics
   └─ Scaled dot-product attention (derivation)
   └─ Multi-head attention
   └─ Multi-query attention (MQA) & Grouped-query attention (GQA)
   └─ Flash Attention (memory-efficient)
   └─ KV Cache mechanics

3. Building a Mini-LLM from Scratch
   └─ Implement a small GPT in PyTorch
   └─ Train on a small dataset
   └─ Generate text
   └─ Understand every component

4. Pretraining Objectives
   └─ Causal language modeling (GPT-style)
   └─ Masked language modeling (BERT-style)
   └─ Prefix language modeling (T5-style)

5. Fine-Tuning Techniques
   └─ Full fine-tuning
   └─ LoRA & QLoRA (theory + practice)
   └─ Instruction tuning datasets
   └─ Hands-on: Fine-tune LLaMA with LoRA

6. Alignment Methods
   └─ RLHF pipeline
   └─ DPO (theory + implementation)
   └─ Constitutional AI
   └─ Hands-on: Align a model with DPO

7. Inference & Decoding
   └─ Greedy, beam search, top-k, top-p, temperature
   └─ KV Cache implementation
   └─ Speculative decoding
   └─ Quantization (GPTQ, AWQ, GGUF)

8. Distributed Training
   └─ Data parallelism
   └─ Tensor parallelism
   └─ Pipeline parallelism
   └─ FSDP
   └─ DeepSpeed ZeRO stages

9. Advanced Architectures
   └─ Mixture of Experts (MoE)
   └─ Multimodal models (vision + language)
   └─ State-space models (Mamba)
   └─ Retrieval-augmented generation (RAG)

10. Production Deployment
    └─ Model serving with vLLM
    └─ Building RAG systems
    └─ Prompt engineering
    └─ Evaluation and benchmarking
```

### Key Papers to Read

| Paper                                  | Year | Topic                          |
|----------------------------------------|------|--------------------------------|
| "Attention Is All You Need"            | 2017 | Transformer architecture       |
| "Language Models are Few-Shot Learners"| 2020 | GPT-3 and in-context learning  |
| "Training Compute-Optimal LLMs"        | 2022 | Chinchilla scaling laws        |
| "LLaMA: Open Foundation Models"       | 2023 | Efficient open-source LLMs     |
| "LoRA: Low-Rank Adaptation"           | 2021 | Parameter-efficient fine-tuning|
| "Direct Preference Optimization"       | 2023 | Simplified alignment           |
| "FlashAttention"                       | 2022 | Memory-efficient attention     |
| "Mixtral of Experts"                   | 2024 | Sparse Mixture of Experts      |

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────┐
│                    LLM QUICK REFERENCE                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  DATA:        Trillions of tokens from diverse sources           │
│  TOKENIZER:   BPE / SentencePiece (subword tokenization)         │
│  VOCAB:       32K - 256K tokens                                  │
│  EMBEDDING:   Token ID → Dense vector (768 - 12,288 dims)        │
│  POSITION:    RoPE (modern) / Learned / Sinusoidal                │
│  ARCHITECTURE:Transformer Decoder (12 - 126 layers)               │
│  ATTENTION:   Multi-Head Self-Attention with causal mask          │
│  FFN:         SwiGLU activation (modern) / GELU / ReLU           │
│  NORM:        RMSNorm (modern) / LayerNorm, Pre-Norm             │
│  LOSS:        Cross-Entropy (next-token prediction)              │
│  OPTIMIZER:   AdamW with cosine LR schedule                      │
│  TRAINING:    Distributed across thousands of GPUs                │
│  FINE-TUNE:   SFT + LoRA/QLoRA                                   │
│  ALIGNMENT:   RLHF or DPO                                       │
│  INFERENCE:   Quantized (INT4/INT8) + KV Cache + vLLM            │
│  DECODING:    Top-p sampling with temperature                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

> **Remember:** Every time you chat with ChatGPT, Claude, or Gemini — this entire pipeline is what makes it possible. From raw internet text to the response you see on your screen, every step described here has been executed at massive scale.

---

*Document Version: 1.0 | Last Updated: August 2026*
