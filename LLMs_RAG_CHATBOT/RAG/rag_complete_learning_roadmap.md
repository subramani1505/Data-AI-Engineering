# RAG (Retrieval-Augmented Generation) — Complete Learning Roadmap

> **Author:** Subramani V  
> **Created:** August 2026  
> **Purpose:** Production-level learning roadmap for mastering RAG systems — from fundamentals to cutting-edge architectures  
> **Prerequisites:** Transformers → LLMs → LangChain → LangGraph → Multi-Agent Systems  
> **Learning Philosophy:** Concepts first, code second, frameworks last

---

## What You'll Learn

By the end of this roadmap you'll understand:

- Why RAG was invented and why LLMs alone fail
- How retrieval actually works — from BM25 to dense retrieval
- Why embeddings work and the mathematics behind them
- How vector databases search billions of vectors in milliseconds
- Chunking strategies that make or break RAG quality
- Indexing pipelines used in production systems
- Hybrid Search — combining the best of lexical and semantic
- Query Rewriting, Decomposition, and HyDE
- Reranking and Context Compression
- Agentic RAG — agents that decide how and where to retrieve
- Graph RAG — knowledge graphs meet vector search
- Multimodal RAG — images, tables, charts, audio, video
- Production RAG — caching, monitoring, security, scaling
- Evaluation — measuring faithfulness, relevance, groundedness
- Latest architectures from 2026

**You'll be able to read and understand almost any research paper on RAG.**

---

## Learning Methodology

For each module, we follow this pattern:

```
┌──────────────────────────────────────────────────────────────────────┐
│                    LEARNING PATTERN PER MODULE                        │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  Step 1:  WHY does this problem exist?                                │
│              ↓                                                        │
│  Step 2:  HOW was it solved before RAG?                               │
│              ↓                                                        │
│  Step 3:  WHAT limitations remained?                                  │
│              ↓                                                        │
│  Step 4:  HOW does RAG solve them?                                    │
│              ↓                                                        │
│  Step 5:  WHAT is the internal architecture?                          │
│              ↓                                                        │
│  Step 6:  HOW is it implemented in Python (from scratch)?             │
│              ↓                                                        │
│  Step 7:  HOW do frameworks like LangChain support it?                │
│              ↓                                                        │
│  Step 8:  WHAT do production systems do differently?                  │
│                                                                       │
│  This approach ensures you understand not just HOW to build           │
│  RAG systems, but WHY each design choice exists.                      │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

> **Important:** We do NOT jump into LangChain or any RAG framework initially. We first build a strong conceptual foundation. Once every concept is clear, we implement each stage in Python from scratch, and only then see how LangChain or LangGraph abstracts those steps.

---

## Complete RAG Learning Path

```
PART 1:  RAG Foundations (Most Important)
              ↓
PART 2:  Embeddings — The Heart of RAG
              ↓
PART 3:  Document Processing & Ingestion
              ↓
PART 4:  Chunking Strategies
              ↓
PART 5:  Indexing Pipeline
              ↓
PART 6:  Vector Search & Vector Databases
              ↓
PART 7:  Retrieval Pipeline
              ↓
PART 8:  Query Understanding & Transformation
              ↓
PART 9:  Reranking & Context Optimization
              ↓
PART 10: Generation Pipeline
              ↓
PART 11: Advanced RAG Architectures
              ↓
PART 12: Agentic RAG
              ↓
PART 13: Graph RAG
              ↓
PART 14: Multimodal RAG
              ↓
PART 15: Evaluation & Metrics
              ↓
PART 16: Production RAG Systems
              ↓
PART 17: Latest RAG Research (2026)
```

---

---

# PART 1 — RAG Foundations (Most Important)

This is where we spend the most time. If you deeply understand **why** RAG was invented, every later topic — embeddings, chunking, vector databases, retrievers, rerankers, and agentic RAG — will feel like natural solutions to specific problems rather than disconnected concepts.

---

## Module 1 — The Problem Before RAG

> **This answers the most fundamental question: WHY does RAG exist?**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│                MODULE 1: THE PROBLEM BEFORE RAG                       │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  1.1  Knowledge Inside LLMs                                           │
│       ├── What do LLMs actually "know"?                               │
│       ├── Training data → compressed knowledge                        │
│       └── The difference between memorization and understanding       │
│                                                                       │
│  1.2  Parametric Memory                                               │
│       ├── What is parametric memory?                                  │
│       ├── Knowledge stored in model weights (parameters)              │
│       ├── How billions of parameters encode world knowledge           │
│       └── Parametric vs Non-Parametric memory                         │
│                                                                       │
│  1.3  Static Knowledge                                                │
│       ├── LLMs are frozen snapshots of training data                  │
│       ├── The world changes but the model doesn't                     │
│       └── Why this is a fundamental architectural limitation          │
│                                                                       │
│  1.4  Hallucinations                                                  │
│       ├── What are hallucinations?                                    │
│       ├── Why LLMs hallucinate (probabilistic generation)             │
│       ├── Types: factual, faithful, instructional hallucinations      │
│       ├── The confidence problem — LLMs sound sure even when wrong    │
│       └── Why hallucinations are dangerous in production              │
│                                                                       │
│  1.5  Knowledge Cutoff                                                │
│       ├── Training data has a cutoff date                             │
│       ├── "Who won the 2026 election?" → model doesn't know           │
│       ├── Real-time information is impossible with parametric memory   │
│       └── How this limits business applications                       │
│                                                                       │
│  1.6  Long Documents                                                  │
│       ├── Context window limits                                       │
│       ├── Can't process a 500-page legal contract in one call         │
│       ├── "Lost in the middle" problem                                │
│       └── Cost of processing long contexts                            │
│                                                                       │
│  1.7  Company Private Data                                            │
│       ├── LLMs don't know YOUR company's data                         │
│       ├── Internal docs, policies, knowledge bases                    │
│       ├── Competitive advantage lives in private data                 │
│       └── Sending private data to external APIs — security concerns   │
│                                                                       │
│  1.8  Why Fine-Tuning Doesn't Solve Everything                        │
│       ├── Fine-tuning teaches BEHAVIOR, not facts                     │
│       ├── Expensive and slow process                                  │
│       ├── Data goes stale → need to retrain                           │
│       ├── Catastrophic forgetting                                     │
│       ├── Fine-tuning vs RAG — when to use which                      │
│       └── Cost of retraining at scale                                 │
│                                                                       │
│  1.9  Fresh Information                                               │
│       ├── News, stock prices, weather, live data                      │
│       ├── Real-time systems need real-time data                       │
│       └── No amount of training fixes the freshness problem           │
│                                                                       │
│  1.10 External Knowledge                                              │
│       ├── The idea of connecting LLMs to external sources             │
│       ├── Databases, APIs, documents, the internet                    │
│       └── This is the fundamental insight that led to RAG             │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Module 2 — Information Retrieval History

> **Most people skip this. Don't. Modern RAG comes from Information Retrieval (IR), a field that predates LLMs by decades.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│            MODULE 2: INFORMATION RETRIEVAL HISTORY                     │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  2.1  Search Engines                                                  │
│       ├── How Google, Bing, and search engines work                   │
│       ├── Crawling → Indexing → Ranking                               │
│       └── The evolution from keyword matching to semantic search       │
│                                                                       │
│  2.2  Information Retrieval (IR) Fundamentals                         │
│       ├── What is Information Retrieval?                               │
│       ├── Documents, Corpus, Query, Ranking, Relevance                │
│       ├── The core IR problem: find relevant documents for a query    │
│       └── Precision vs Recall trade-off                               │
│                                                                       │
│  2.3  Precision & Recall                                              │
│       ├── Precision: of what you returned, how much was relevant?     │
│       ├── Recall: of what was relevant, how much did you return?      │
│       ├── F1 Score: harmonic mean of precision and recall              │
│       ├── Why you can't maximize both simultaneously                  │
│       └── Which matters more for RAG (spoiler: recall first)          │
│                                                                       │
│  2.4  TF-IDF                                                          │
│       ├── Term Frequency (TF) — how often a word appears              │
│       ├── Inverse Document Frequency (IDF) — how rare a word is       │
│       ├── TF-IDF = TF × IDF                                          │
│       ├── Why common words get low scores                             │
│       ├── Mathematical formulation                                    │
│       └── Limitations of TF-IDF                                       │
│                                                                       │
│  2.5  BM25                                                            │
│       ├── Best Matching 25 — the industry standard                    │
│       ├── Improvement over TF-IDF                                     │
│       ├── Document length normalization                               │
│       ├── Saturation function                                         │
│       ├── Parameters: k1, b                                           │
│       ├── Why BM25 is STILL used in production (even in 2026)         │
│       └── BM25 in Elasticsearch, OpenSearch, Lucene                   │
│                                                                       │
│  2.6  Lexical Search vs Semantic Search                               │
│       ├── Lexical: exact keyword matching                             │
│       ├── Semantic: meaning-based matching                            │
│       ├── "car" vs "automobile" — lexical fails, semantic succeeds    │
│       ├── Strengths and weaknesses of each                            │
│       └── Why modern systems use BOTH (Hybrid Search)                 │
│                                                                       │
│  2.7  Hybrid Search                                                   │
│       ├── Combining BM25 (lexical) + vector search (semantic)         │
│       ├── Reciprocal Rank Fusion (RRF)                                │
│       ├── Weighted combination strategies                             │
│       └── Why hybrid beats either alone                               │
│                                                                       │
│  2.8  Inverted Index                                                  │
│       ├── The data structure behind all search engines                 │
│       ├── Word → list of documents containing that word               │
│       ├── How it enables sub-second search over billions of docs       │
│       └── Inverted index vs vector index                              │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Module 3 — Birth of RAG

> **The core concept that changed everything.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│                MODULE 3: BIRTH OF RAG                                  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  3.1  What is RAG?                                                    │
│       ├── Retrieval-Augmented Generation — the full name              │
│       ├── "Retrieve relevant information, then generate an answer"    │
│       └── The simplest RAG pipeline in 3 steps                       │
│                                                                       │
│  3.2  The Original RAG Paper (Facebook/Meta AI, 2020)                 │
│       ├── "Retrieval-Augmented Generation for Knowledge-Intensive     │
│       │    NLP Tasks" — Lewis et al.                                  │
│       ├── Key contributions                                           │
│       ├── RAG-Sequence vs RAG-Token                                   │
│       └── Why this paper was revolutionary                            │
│                                                                       │
│  3.3  The RAG Architecture                                            │
│       ├── Retriever — finds relevant documents                        │
│       ├── Generator — produces the answer                             │
│       ├── Knowledge Base — the source of truth                        │
│       └── Context Injection — feeding retrieved info to the LLM       │
│                                                                       │
│       ┌─────────┐     ┌──────────┐     ┌───────────┐                 │
│       │  Query   │────→│ Retriever │────→│ Generator │────→ Answer    │
│       └─────────┘     └──────────┘     └───────────┘                 │
│                            │                  ▲                        │
│                            ▼                  │                        │
│                       ┌──────────┐      ┌──────────┐                 │
│                       │ Knowledge │      │ Retrieved │                 │
│                       │   Base    │─────→│  Context  │                 │
│                       └──────────┘      └──────────┘                 │
│                                                                       │
│  3.4  Why RAG Works                                                   │
│       ├── Grounds LLM responses in real data                          │
│       ├── Reduces hallucinations dramatically                         │
│       ├── No retraining needed — just update the knowledge base       │
│       ├── Works with private/proprietary data                         │
│       └── Cost-effective compared to fine-tuning                      │
│                                                                       │
│  3.5  Advantages of RAG                                               │
│       ├── Up-to-date knowledge (no cutoff problem)                    │
│       ├── Verifiable answers (source attribution)                     │
│       ├── Domain adaptability without retraining                      │
│       ├── Cost efficiency                                             │
│       └── Transparency and trust                                      │
│                                                                       │
│  3.6  Limitations of RAG                                              │
│       ├── Quality depends on retrieval quality                        │
│       ├── Garbage in → garbage out                                    │
│       ├── Latency overhead (retrieval + generation)                   │
│       ├── Chunking affects accuracy                                   │
│       ├── Complex to optimize end-to-end                              │
│       └── Not a silver bullet — some tasks don't need RAG             │
│                                                                       │
│  3.7  RAG vs Fine-Tuning vs Long Context — When to Use What           │
│       ├── RAG: dynamic knowledge, frequent updates                    │
│       ├── Fine-Tuning: behavioral changes, domain adaptation          │
│       ├── Long Context: when all data fits in the context window      │
│       └── Hybrid approaches in production                             │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 2 — Embeddings (The Heart of RAG)

> **Without embeddings, there is no modern RAG.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│                PART 2: EMBEDDINGS                                      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  4.1  What Are Embeddings?                                            │
│       ├── Converting text/images/audio into numerical vectors          │
│       ├── Dense fixed-size representations                            │
│       ├── Meaning is captured in vector positions                     │
│       └── "King - Man + Woman ≈ Queen" — the classic example          │
│                                                                       │
│  4.2  Why Text Becomes Vectors                                        │
│       ├── Computers can't understand text directly                    │
│       ├── Vectors enable mathematical comparison                      │
│       ├── Similar meanings → similar vectors                          │
│       └── The embedding hypothesis                                    │
│                                                                       │
│  4.3  Vector Space & High-Dimensional Space                           │
│       ├── What is a vector space?                                     │
│       ├── 2D, 3D → intuition, then 768D, 1536D, 3072D                │
│       ├── Curse of dimensionality                                     │
│       └── Why high dimensions actually help                           │
│                                                                       │
│  4.4  Distance & Similarity Metrics                                   │
│       ├── Cosine Similarity — angle between vectors                   │
│       ├── Euclidean Distance — straight-line distance                 │
│       ├── Dot Product — magnitude-aware similarity                    │
│       ├── Manhattan Distance                                          │
│       ├── When to use which metric                                    │
│       └── Mathematical formulas and intuition                         │
│                                                                       │
│  4.5  Embedding Models                                                │
│       ├── Word2Vec, GloVe (historical)                                │
│       ├── BERT-based embeddings                                       │
│       ├── Sentence Transformers (all-MiniLM, all-mpnet)               │
│       ├── OpenAI Embeddings (text-embedding-3-small/large)            │
│       ├── Cohere Embed v3                                             │
│       ├── Google Embedding Models                                     │
│       ├── Voyage AI, Jina Embeddings                                  │
│       ├── Open-source: BGE, E5, GTE, NomicEmbed                      │
│       └── How to choose an embedding model                            │
│                                                                       │
│  4.6  Types of Embeddings                                             │
│       ├── Word Embeddings — single word representations               │
│       ├── Sentence Embeddings — full sentence meaning                 │
│       ├── Document Embeddings — entire document representation        │
│       ├── Chunk Embeddings — RAG-specific representations             │
│       ├── Query Embeddings — optimized for search queries             │
│       └── Cross-modal Embeddings (text ↔ image, CLIP)                 │
│                                                                       │
│  4.7  Embedding Model Evaluation                                      │
│       ├── MTEB Benchmark                                              │
│       ├── Retrieval accuracy metrics                                  │
│       ├── Semantic similarity benchmarks                               │
│       └── Domain-specific evaluation                                  │
│                                                                       │
│  4.8  Fine-Tuning Embedding Models                                    │
│       ├── Why fine-tune embeddings?                                   │
│       ├── Contrastive learning                                        │
│       ├── Hard negative mining                                        │
│       ├── Domain adaptation                                           │
│       └── When default embeddings are good enough                     │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 3 — Document Processing & Ingestion

> **Before retrieval comes preprocessing. Garbage in → garbage out.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│                PART 3: DOCUMENT PROCESSING                            │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  5.1  Document Formats                                                │
│       ├── PDFs — the most common and most complex                     │
│       ├── DOCX — Microsoft Word documents                             │
│       ├── PPTX — Presentations                                        │
│       ├── XLSX/CSV — Spreadsheets and tabular data                    │
│       ├── HTML — Web pages                                            │
│       ├── Markdown — Documentation                                    │
│       ├── Plain Text                                                  │
│       ├── JSON/XML — Structured data                                  │
│       ├── Code Files — Python, JS, Java, etc.                         │
│       └── Emails — .eml, .msg formats                                 │
│                                                                       │
│  5.2  PDF Processing Deep Dive                                        │
│       ├── Why PDFs are hard (no semantic structure)                    │
│       ├── Text-based vs image-based PDFs                              │
│       ├── PyPDF2, pdfplumber, pymupdf (fitz)                          │
│       ├── Unstructured.io                                             │
│       ├── Document AI services (Google, Azure, AWS Textract)          │
│       └── Handling headers, footers, page numbers                     │
│                                                                       │
│  5.3  OCR (Optical Character Recognition)                             │
│       ├── When OCR is needed (scanned documents, images)              │
│       ├── Tesseract, EasyOCR                                          │
│       ├── Cloud OCR services                                          │
│       └── OCR accuracy and post-processing                            │
│                                                                       │
│  5.4  Table Extraction                                                │
│       ├── Why tables are a special challenge                          │
│       ├── Table detection and extraction tools                        │
│       ├── Converting tables to structured formats                     │
│       └── Embedding tables vs treating them specially                  │
│                                                                       │
│  5.5  Layout Detection                                                │
│       ├── Understanding document structure                            │
│       ├── Headers, paragraphs, lists, images, tables                  │
│       ├── Layout-aware processing                                     │
│       └── Tools: LayoutParser, Document AI                            │
│                                                                       │
│  5.6  Cleaning & Normalization                                        │
│       ├── Removing noise (headers, footers, page numbers)             │
│       ├── Unicode normalization                                       │
│       ├── Whitespace handling                                         │
│       ├── Deduplication                                               │
│       └── Language detection                                          │
│                                                                       │
│  5.7  Metadata Extraction                                             │
│       ├── Title, author, date, source                                 │
│       ├── Section headers and hierarchy                               │
│       ├── Custom metadata for filtering                               │
│       └── Why metadata is critical for production RAG                  │
│                                                                       │
│  5.8  Markdown Conversion                                             │
│       ├── Why convert to Markdown?                                    │
│       ├── Structure preservation                                      │
│       ├── Tools and libraries                                         │
│       └── Markdown as the universal intermediate format               │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 4 — Chunking Strategies

> **One of the biggest topics in RAG. How you chunk determines how well you retrieve.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│                PART 4: CHUNKING STRATEGIES                            │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  6.1  Why Chunk?                                                      │
│       ├── Documents are too long for embedding models                 │
│       ├── Embedding models have token limits (512–8192)               │
│       ├── Smaller chunks → more precise retrieval                     │
│       ├── Larger chunks → more context per retrieval                  │
│       └── The chunk size trade-off                                    │
│                                                                       │
│  6.2  Fixed-Size Chunking                                             │
│       ├── Split by character/token count                              │
│       ├── Simplest approach                                           │
│       ├── Pros: fast, predictable                                     │
│       └── Cons: breaks semantic boundaries                            │
│                                                                       │
│  6.3  Sliding Window Chunking                                         │
│       ├── Fixed size with overlap                                     │
│       ├── Overlap ensures context continuity                          │
│       └── How to choose overlap size                                  │
│                                                                       │
│  6.4  Recursive Chunking                                              │
│       ├── LangChain's RecursiveCharacterTextSplitter                  │
│       ├── Tries multiple separators: \n\n → \n → . → space            │
│       ├── Preserves semantic boundaries better                        │
│       └── Most commonly used in practice                              │
│                                                                       │
│  6.5  Semantic Chunking                                               │
│       ├── Split based on meaning, not character count                 │
│       ├── Embedding-based boundary detection                          │
│       ├── Cosine similarity between consecutive segments              │
│       ├── When similarity drops → create new chunk                    │
│       └── More expensive but higher quality                           │
│                                                                       │
│  6.6  Hierarchical Chunking                                           │
│       ├── Multiple levels: document → section → paragraph → sentence  │
│       ├── Tree-structured representation                              │
│       └── Enables multi-resolution retrieval                          │
│                                                                       │
│  6.7  Parent-Child Chunking                                           │
│       ├── Small chunks for retrieval (precision)                      │
│       ├── Large parent chunks for context (comprehensiveness)          │
│       ├── Retrieve small → return parent                              │
│       └── LangChain's ParentDocumentRetriever                         │
│                                                                       │
│  6.8  Agentic Chunking                                                │
│       ├── LLM decides chunk boundaries                                │
│       ├── "Read this document and identify logical sections"          │
│       ├── Most expensive but highest quality                          │
│       └── When to justify the cost                                    │
│                                                                       │
│  6.9  Specialized Chunking                                            │
│       ├── Markdown Chunking — split by headers                        │
│       ├── Table Chunking — keep tables intact                         │
│       ├── Code Chunking — split by functions/classes                   │
│       ├── HTML Chunking — DOM-aware splitting                         │
│       └── JSON Chunking — structure-aware splitting                    │
│                                                                       │
│  6.10 Chunk Overlap                                                   │
│       ├── Why overlap matters                                         │
│       ├── Typical overlap: 10-20% of chunk size                       │
│       ├── Too little → lost context at boundaries                     │
│       └── Too much → redundancy and increased storage/cost            │
│                                                                       │
│  6.11 Chunk Size Optimization                                         │
│       ├── Small chunks (100-300 tokens): precise but narrow            │
│       ├── Medium chunks (300-800 tokens): balanced                     │
│       ├── Large chunks (800-2000 tokens): comprehensive but noisy      │
│       ├── How to evaluate optimal chunk size for your use case         │
│       └── Empirical testing methodology                               │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 5 — Indexing Pipeline

> **How documents become searchable. This is the offline pipeline that powers retrieval.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│                PART 5: INDEXING PIPELINE                               │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  The Complete Indexing Flow:                                          │
│                                                                       │
│       Document                                                        │
│          ↓                                                            │
│       Loading & Parsing                                               │
│          ↓                                                            │
│       Cleaning & Normalization                                        │
│          ↓                                                            │
│       Chunking                                                        │
│          ↓                                                            │
│       Embedding Generation                                            │
│          ↓                                                            │
│       Metadata Enrichment                                             │
│          ↓                                                            │
│       Vector Database Storage                                         │
│                                                                       │
│  7.1  Index & Indexing                                                │
│       ├── What is an index?                                           │
│       ├── Why indexing is a separate pipeline                         │
│       └── Index structures for different search types                 │
│                                                                       │
│  7.2  Batch Indexing                                                  │
│       ├── Processing large document collections                       │
│       ├── Parallelization strategies                                  │
│       ├── Rate limiting with embedding APIs                           │
│       └── Error handling and retry logic                              │
│                                                                       │
│  7.3  Incremental Indexing                                            │
│       ├── Adding new documents without reprocessing everything         │
│       ├── Change detection                                            │
│       ├── Upsert operations                                          │
│       └── Handling document updates and deletions                     │
│                                                                       │
│  7.4  Metadata Management                                             │
│       ├── What metadata to store (source, date, author, category)     │
│       ├── Metadata schemas                                            │
│       ├── Metadata filtering during retrieval                         │
│       └── Custom metadata for business logic                          │
│                                                                       │
│  7.5  Versioning                                                      │
│       ├── Document version tracking                                   │
│       ├── Index versioning                                            │
│       ├── Rollback strategies                                         │
│       └── A/B testing different indexing approaches                   │
│                                                                       │
│  7.6  Reindexing                                                      │
│       ├── When to reindex (new model, changed strategy)               │
│       ├── Blue-green deployment for indexes                           │
│       ├── Zero-downtime reindexing                                    │
│       └── Cost and time considerations                                │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 6 — Vector Search & Vector Databases

> **The infrastructure that makes RAG possible at scale.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│            PART 6: VECTOR SEARCH & VECTOR DATABASES                   │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  8.1  Why Vector Databases?                                           │
│       ├── Traditional databases can't do similarity search             │
│       ├── The need for fast nearest-neighbor search                    │
│       ├── Billions of vectors → need specialized infrastructure       │
│       └── Vector DB vs traditional DB vs search engine                 │
│                                                                       │
│  8.2  Vector Search Algorithms                                        │
│       ├── Exact Search (brute-force k-NN)                             │
│       │   ├── Compare query against every vector                       │
│       │   ├── O(n) — doesn't scale                                    │
│       │   └── 100% accurate but too slow                              │
│       │                                                               │
│       ├── Approximate Nearest Neighbor (ANN)                          │
│       │   ├── Trade accuracy for speed                                │
│       │   ├── 95-99% recall is good enough                            │
│       │   └── The basis of all production vector search               │
│       │                                                               │
│       ├── HNSW (Hierarchical Navigable Small World)                   │
│       │   ├── Graph-based algorithm                                   │
│       │   ├── Multi-layer navigable graph                             │
│       │   ├── O(log n) search time                                    │
│       │   ├── Best for: in-memory, high recall                        │
│       │   └── Used by: Qdrant, Weaviate, pgvector                    │
│       │                                                               │
│       ├── IVF (Inverted File Index)                                   │
│       │   ├── Cluster-based partitioning                              │
│       │   ├── Search only relevant clusters                           │
│       │   ├── Good for: large datasets                                │
│       │   └── Used by: FAISS, Milvus                                  │
│       │                                                               │
│       ├── PQ (Product Quantization)                                   │
│       │   ├── Compress vectors to reduce memory                       │
│       │   ├── Lossy compression                                       │
│       │   ├── Good for: memory-constrained environments               │
│       │   └── Often combined with IVF (IVF-PQ)                        │
│       │                                                               │
│       ├── DiskANN                                                     │
│       │   ├── Disk-based ANN search                                   │
│       │   ├── Handles billion-scale datasets                          │
│       │   ├── Developed by Microsoft Research                         │
│       │   └── Used in: Azure AI Search, Bing                         │
│       │                                                               │
│       └── ScaNN (Google)                                              │
│           ├── Scalable Nearest Neighbors                              │
│           └── Anisotropic vector quantization                         │
│                                                                       │
│  8.3  Index Structures                                                │
│       ├── Flat Index (exact)                                          │
│       ├── IVF-Flat                                                    │
│       ├── IVF-PQ                                                      │
│       ├── HNSW                                                        │
│       ├── HNSW-PQ                                                     │
│       └── Choosing the right index                                    │
│                                                                       │
│  8.4  Metadata Filtering                                              │
│       ├── Pre-filtering vs post-filtering                             │
│       ├── Filtered search performance                                 │
│       └── Hybrid metadata + vector queries                            │
│                                                                       │
│  8.5  Sharding & Replication                                          │
│       ├── Distributing data across nodes                              │
│       ├── Horizontal scaling                                          │
│       └── High availability and fault tolerance                       │
│                                                                       │
│  8.6  Popular Vector Databases                                        │
│       ├── Pinecone — fully managed, serverless                        │
│       ├── Weaviate — open-source, hybrid search                       │
│       ├── Milvus — open-source, high performance                      │
│       ├── Qdrant — open-source, Rust-based, fast                      │
│       ├── Chroma — lightweight, developer-friendly                    │
│       ├── FAISS — Facebook's library (not a database)                 │
│       ├── pgvector — PostgreSQL extension                             │
│       ├── Elasticsearch — vector + full-text hybrid                   │
│       ├── OpenSearch — AWS-managed alternative                        │
│       ├── Azure AI Search — Microsoft's managed solution              │
│       └── Comparison matrix: features, pricing, scale                 │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 7 — Retrieval Pipeline

> **Probably the most important part of RAG. This is where queries become answers.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│                PART 7: RETRIEVAL PIPELINE                              │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  The Complete Retrieval Flow:                                         │
│                                                                       │
│       User Query                                                      │
│          ↓                                                            │
│       Query Embedding                                                 │
│          ↓                                                            │
│       Similarity Search                                               │
│          ↓                                                            │
│       Top-K Results                                                   │
│          ↓                                                            │
│       Metadata Filtering                                              │
│          ↓                                                            │
│       Reranking                                                       │
│          ↓                                                            │
│       Context Building                                                │
│                                                                       │
│  9.1  Query Embedding                                                 │
│       ├── Same embedding model as indexing (critical!)                 │
│       ├── Query-document asymmetry                                    │
│       └── Query prefix vs passage prefix (some models need this)      │
│                                                                       │
│  9.2  Similarity Search                                               │
│       ├── Finding nearest vectors                                     │
│       ├── Distance metrics in practice                                │
│       └── Search parameters and tuning                                │
│                                                                       │
│  9.3  Top-K Selection                                                 │
│       ├── How many chunks to retrieve (K)?                             │
│       ├── Small K (3-5): precise, less noise                           │
│       ├── Large K (10-20): more recall, more noise                     │
│       ├── Dynamic K based on query complexity                         │
│       └── Top-K vs Top-N (retrieval vs final context)                  │
│                                                                       │
│  9.4  Metadata Filtering                                              │
│       ├── Filter by date, source, category, author                    │
│       ├── Pre-filter (before search) vs post-filter (after search)    │
│       └── Structured queries on vector databases                      │
│                                                                       │
│  9.5  Retriever Types in LangChain                                    │
│       ├── VectorStoreRetriever — basic similarity search               │
│       ├── Multi Query Retriever — generate multiple query variations   │
│       ├── Parent Document Retriever — retrieve small, return large     │
│       ├── Multi Vector Retriever — multiple vectors per document       │
│       ├── Self Query Retriever — LLM generates structured filters     │
│       ├── Ensemble Retriever — combine multiple retrievers             │
│       ├── Contextual Compression Retriever — compress retrieved docs   │
│       └── Recursive Retriever — iterative refinement                  │
│                                                                       │
│  9.6  Hybrid Search Implementation                                    │
│       ├── BM25 + vector search combination                            │
│       ├── Reciprocal Rank Fusion (RRF) algorithm                      │
│       ├── Weighted scoring                                            │
│       └── Production hybrid search patterns                           │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 8 — Query Understanding & Transformation

> **Modern RAG does much more than just embed and search. Smart query handling dramatically improves retrieval quality.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│            PART 8: QUERY UNDERSTANDING & TRANSFORMATION               │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  10.1 Query Classification                                           │
│       ├── Is this a factual question? Conversational? Analytical?     │
│       ├── Route different query types to different pipelines          │
│       └── Intent detection for RAG queries                            │
│                                                                       │
│  10.2 Query Expansion                                                 │
│       ├── Add related terms to improve recall                         │
│       ├── Synonym expansion                                           │
│       └── Concept expansion using LLMs                                │
│                                                                       │
│  10.3 Query Rewriting                                                 │
│       ├── LLM rewrites ambiguous queries for better retrieval          │
│       ├── "Fix this" → "How do I fix the database connection error?"  │
│       ├── Conversational context resolution                           │
│       └── Coreference resolution                                      │
│                                                                       │
│  10.4 HyDE (Hypothetical Document Embeddings)                         │
│       ├── Generate a hypothetical answer first                        │
│       ├── Embed the hypothetical answer (not the query)               │
│       ├── Search with the hypothetical answer's embedding             │
│       ├── Why this works (answer ≈ document, query ≠ document)        │
│       └── When to use HyDE vs standard embedding                      │
│                                                                       │
│  10.5 Multi Query                                                     │
│       ├── Generate multiple query variations                          │
│       ├── Search with each variation                                  │
│       ├── Combine results (union + deduplicate)                        │
│       └── Improves recall for ambiguous queries                       │
│                                                                       │
│  10.6 Query Decomposition                                             │
│       ├── Break complex questions into sub-questions                  │
│       ├── Answer each sub-question independently                      │
│       ├── Synthesize final answer                                     │
│       └── Essential for multi-hop reasoning                           │
│                                                                       │
│  10.7 Step-back Prompting                                             │
│       ├── Ask a more general question first                           │
│       ├── Use general answer to inform specific retrieval              │
│       └── Improves reasoning on complex queries                       │
│                                                                       │
│  10.8 Intent Detection                                                │
│       ├── Classify user intent before retrieval                       │
│       ├── Route to appropriate retrieval strategy                     │
│       └── Handle out-of-scope queries gracefully                      │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 9 — Reranking & Context Optimization

> **Retrieval finds candidates. Reranking picks the best ones.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│            PART 9: RERANKING & CONTEXT OPTIMIZATION                   │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  11.1 Why Retrieval Isn't Enough                                      │
│       ├── Bi-encoder retrieval is fast but approximate                 │
│       ├── Top-K results often contain irrelevant chunks               │
│       ├── Ordering matters for LLM context                            │
│       └── Quality of context = quality of answer                      │
│                                                                       │
│  11.2 Bi-Encoder vs Cross-Encoder                                     │
│       ├── Bi-Encoder: encode query and document separately             │
│       │   ├── Fast (can be precomputed)                                │
│       │   ├── Used for retrieval (stage 1)                            │
│       │   └── Less accurate on relevance scoring                      │
│       ├── Cross-Encoder: encode query + document together              │
│       │   ├── Slow (can't be precomputed)                              │
│       │   ├── Used for reranking (stage 2)                            │
│       │   └── Much more accurate on relevance scoring                 │
│       └── Two-stage pipeline: retrieve (bi) → rerank (cross)          │
│                                                                       │
│  11.3 Reranker Models                                                 │
│       ├── Cohere Rerank                                               │
│       ├── Jina Reranker                                               │
│       ├── BGE Reranker                                                │
│       ├── Cross-encoder/ms-marco-MiniLM                               │
│       ├── Voyage Rerank                                                │
│       ├── ColBERT (late interaction — special case)                    │
│       └── LLM-based reranking (using GPT/Claude to score relevance)   │
│                                                                       │
│  11.4 Context Compression                                             │
│       ├── Remove irrelevant parts of retrieved chunks                 │
│       ├── LLM-based compression ("extract only relevant sentences")    │
│       ├── Contextual compression retriever in LangChain                │
│       └── Reduces token usage and cost                                │
│                                                                       │
│  11.5 Lost in the Middle                                              │
│       ├── LLMs pay more attention to start and end of context          │
│       ├── Middle sections get "lost"                                   │
│       ├── Ordering strategies: put best results first and last         │
│       └── Research: Liu et al. "Lost in the Middle" (2023)            │
│                                                                       │
│  11.6 Long Context Reordering                                         │
│       ├── Reorder retrieved chunks for optimal LLM attention           │
│       ├── Relevance-based ordering                                    │
│       ├── Interleaving strategies                                     │
│       └── LongContextReorder in LangChain                             │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 10 — Generation Pipeline

> **The final step: turning retrieved context into a high-quality, grounded answer.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│                PART 10: GENERATION PIPELINE                           │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  12.1 Prompt Construction                                             │
│       ├── System prompt design for RAG                                │
│       ├── Context injection patterns                                  │
│       ├── "Answer based ONLY on the provided context"                 │
│       ├── Few-shot examples in RAG prompts                            │
│       └── Dynamic prompt assembly                                     │
│                                                                       │
│  12.2 Context Formatting                                              │
│       ├── How to structure retrieved chunks in the prompt              │
│       ├── Numbered sources for citation                                │
│       ├── Metadata inclusion (source, page, date)                     │
│       └── Token budget management                                     │
│                                                                       │
│  12.3 Citations & Source Attribution                                   │
│       ├── Inline citations [Source 1]                                  │
│       ├── Footnote-style citations                                    │
│       ├── URL/document linking                                        │
│       ├── Why citations build user trust                              │
│       └── Verifiable answers vs opaque responses                      │
│                                                                       │
│  12.4 Grounded Responses                                              │
│       ├── Ensuring answers are grounded in retrieved context           │
│       ├── "I don't have enough information" responses                 │
│       ├── Confidence scoring                                          │
│       └── Avoiding confabulation                                      │
│                                                                       │
│  12.5 Hallucination Reduction                                         │
│       ├── Prompt engineering techniques                               │
│       ├── Temperature settings for RAG (low T recommended)             │
│       ├── Verification chains                                         │
│       ├── Self-consistency checking                                   │
│       └── Post-generation fact checking                               │
│                                                                       │
│  12.6 Context Window Optimization                                     │
│       ├── Fitting more relevant information in limited context         │
│       ├── Compression vs truncation                                    │
│       ├── Chunk selection strategies                                  │
│       └── Cost-aware context building                                 │
│                                                                       │
│  12.7 Streaming Responses                                             │
│       ├── Token-by-token streaming                                    │
│       ├── Server-Sent Events (SSE)                                    │
│       ├── User experience benefits                                    │
│       └── Streaming with citations                                    │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 11 — Advanced RAG Architectures

> **Beyond basic retrieve-and-generate. These are the architectures used in production.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│            PART 11: ADVANCED RAG ARCHITECTURES                        │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  13.1 Adaptive RAG                                                    │
│       ├── Dynamically decide whether to retrieve or not               │
│       ├── Some queries don't need retrieval                           │
│       └── Route queries to the right pipeline                         │
│                                                                       │
│  13.2 Corrective RAG (CRAG)                                           │
│       ├── Evaluate retrieval quality before generation                 │
│       ├── If retrieval is poor → try web search or rephrase           │
│       ├── Self-correcting retrieval pipeline                          │
│       └── Paper: "Corrective RAG" (2024)                              │
│                                                                       │
│  13.3 Self-RAG                                                        │
│       ├── Model decides: retrieve? generate? critique?                │
│       ├── Self-reflection on generated output                         │
│       ├── Retrieval tokens as special markers                         │
│       └── Paper: "Self-RAG" (2024)                                    │
│                                                                       │
│  13.4 Reflective RAG                                                  │
│       ├── Generate → evaluate → retrieve more → regenerate            │
│       ├── Iterative refinement loop                                   │
│       └── Improves answer quality through reflection                  │
│                                                                       │
│  13.5 Fusion-in-Decoder (FiD)                                         │
│       ├── Process each retrieved passage independently                │
│       ├── Fuse in the decoder layer                                   │
│       ├── Scales to many passages efficiently                         │
│       └── Research architecture (Izacard & Grave, 2021)               │
│                                                                       │
│  13.6 Fusion Retrieval                                                │
│       ├── Combine results from multiple retrieval strategies           │
│       ├── Reciprocal Rank Fusion                                      │
│       └── Weighted fusion approaches                                  │
│                                                                       │
│  13.7 Dense Retrieval vs Sparse Retrieval                             │
│       ├── Dense: embedding-based (semantic)                            │
│       ├── Sparse: BM25/TF-IDF-based (lexical)                         │
│       ├── Learned Sparse: SPLADE, DeepImpact                          │
│       └── Hybrid: combining both for best results                     │
│                                                                       │
│  13.8 Late Interaction Models                                         │
│       ├── ColBERT — Contextualized Late Interaction over BERT          │
│       ├── Token-level interaction instead of single-vector             │
│       ├── Better relevance scoring with precomputable representations  │
│       └── ColBERTv2 and PLAID optimizations                           │
│                                                                       │
│  13.9 Adaptive Retrieval                                              │
│       ├── Adjust retrieval parameters per query                       │
│       ├── Dynamic K selection                                         │
│       ├── Dynamic threshold selection                                 │
│       └── Learned retrieval strategies                                │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 12 — Agentic RAG

> **When RAG becomes an agent — deciding what tools to use, when to search, and how to verify.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│                PART 12: AGENTIC RAG                                    │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  14.1 What is Agentic RAG?                                            │
│       ├── The agent decides the retrieval strategy                    │
│       ├── Not just vector search — SQL, APIs, web, knowledge graphs   │
│       └── Planning → retrieve → verify → answer                      │
│                                                                       │
│  14.2 Agent Decision Making                                           │
│       ├── Search vector database?                                     │
│       ├── Query SQL database?                                         │
│       ├── Call an API?                                                │
│       ├── Search the web?                                             │
│       ├── Use a knowledge graph?                                      │
│       └── Combine multiple sources?                                   │
│                                                                       │
│  14.3 Planning                                                        │
│       ├── Query analysis and decomposition                            │
│       ├── Multi-step retrieval plans                                  │
│       ├── Tool selection strategy                                     │
│       └── ReAct-style planning for RAG                                │
│                                                                       │
│  14.4 Tool Selection                                                  │
│       ├── Defining tools for the RAG agent                            │
│       ├── Vector search tool, SQL tool, web search tool               │
│       ├── Calculator, code executor, API caller                       │
│       └── Tool descriptions that guide LLM selection                  │
│                                                                       │
│  14.5 Memory in Agentic RAG                                           │
│       ├── Conversation memory                                         │
│       ├── Retrieval history (what was already retrieved)               │
│       ├── User preference memory                                      │
│       └── Long-term knowledge accumulation                            │
│                                                                       │
│  14.6 Verification & Reflection                                       │
│       ├── Verify retrieved information for relevance                  │
│       ├── Cross-check across sources                                  │
│       ├── Self-critique generated answers                             │
│       └── Retry with different strategy if quality is low              │
│                                                                       │
│  14.7 Multi-Agent RAG                                                 │
│       ├── Specialized agents: retriever agent, analyst agent           │
│       ├── Supervisor/orchestrator patterns                            │
│       ├── Agent collaboration for complex queries                      │
│       └── LangGraph implementation of multi-agent RAG                 │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 13 — Graph RAG

> **When relationships matter more than similarity.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│                PART 13: GRAPH RAG                                      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  15.1 Knowledge Graphs                                                │
│       ├── What is a knowledge graph?                                  │
│       ├── Entities, relationships, properties                         │
│       ├── Nodes and edges                                             │
│       ├── Triples: (Subject, Predicate, Object)                       │
│       └── Why knowledge graphs complement vector search               │
│                                                                       │
│  15.2 Graph Databases                                                 │
│       ├── Neo4j — most popular graph database                         │
│       ├── Amazon Neptune                                              │
│       ├── ArangoDB                                                    │
│       ├── Cypher query language                                       │
│       └── Graph vs relational vs document databases                   │
│                                                                       │
│  15.3 Entity Extraction & Linking                                     │
│       ├── Named Entity Recognition (NER)                               │
│       ├── Entity linking to knowledge base                             │
│       ├── Relationship extraction                                     │
│       ├── LLM-based entity extraction                                 │
│       └── Building knowledge graphs from documents                    │
│                                                                       │
│  15.4 Graph Traversal                                                 │
│       ├── Breadth-first search                                        │
│       ├── Depth-first search                                          │
│       ├── Shortest path algorithms                                    │
│       ├── Neighborhood queries                                        │
│       └── Multi-hop reasoning on graphs                               │
│                                                                       │
│  15.5 Hybrid Graph + Vector Search                                    │
│       ├── Vector search for semantic similarity                       │
│       ├── Graph traversal for relationships                           │
│       ├── Combining both for comprehensive retrieval                  │
│       └── Microsoft GraphRAG architecture                             │
│                                                                       │
│  15.6 Microsoft GraphRAG                                              │
│       ├── Community detection in document collections                  │
│       ├── Hierarchical summarization                                  │
│       ├── Global queries vs local queries                              │
│       ├── Entity resolution                                           │
│       └── Open-source implementation                                  │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 14 — Multimodal RAG

> **RAG isn't just text. Modern systems retrieve and reason over images, tables, charts, audio, and video.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│                PART 14: MULTIMODAL RAG                                 │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  16.1 Images                                                          │
│       ├── Image embedding models (CLIP, SigLIP)                       │
│       ├── Image → text descriptions (captioning)                      │
│       ├── Image search via text queries                               │
│       └── Storing and retrieving image chunks                         │
│                                                                       │
│  16.2 Tables                                                          │
│       ├── Table detection in documents                                │
│       ├── Table-to-text conversion                                    │
│       ├── Structured table embedding                                  │
│       ├── Table QA (answering questions over tables)                   │
│       └── Challenges with complex/nested tables                       │
│                                                                       │
│  16.3 Charts & Graphs                                                 │
│       ├── Chart understanding (bar, line, pie)                        │
│       ├── Data extraction from charts                                 │
│       ├── Vision model analysis                                       │
│       └── Chart QA benchmarks                                         │
│                                                                       │
│  16.4 Audio                                                           │
│       ├── Speech-to-text → text RAG                                   │
│       ├── Audio embedding models                                      │
│       ├── Meeting transcription and retrieval                         │
│       └── Podcast/lecture search                                      │
│                                                                       │
│  16.5 Video                                                           │
│       ├── Frame extraction and embedding                              │
│       ├── Video transcription + visual analysis                       │
│       ├── Temporal search (find moment in video)                      │
│       └── Multimodal fusion for video understanding                   │
│                                                                       │
│  16.6 OCR in Multimodal RAG                                           │
│       ├── Extracting text from images in documents                    │
│       ├── Handwritten text recognition                                │
│       └── Form and receipt processing                                 │
│                                                                       │
│  16.7 Vision Models for RAG                                           │
│       ├── GPT-4o, Gemini 2.5 Pro, Claude Sonnet 4                    │
│       ├── Processing documents as images                              │
│       ├── "Visual RAG" — embed page screenshots                       │
│       └── When vision RAG beats text RAG                              │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 15 — Evaluation & Metrics

> **Very important in production. If you can't measure it, you can't improve it.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│                PART 15: EVALUATION & METRICS                          │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  17.1 Why Evaluation Matters                                          │
│       ├── RAG systems have many failure points                        │
│       ├── Retrieval can fail → wrong context → wrong answer           │
│       ├── Need to measure each stage independently                    │
│       └── Continuous monitoring vs one-time evaluation                │
│                                                                       │
│  17.2 Retrieval Metrics                                               │
│       ├── Context Precision — are retrieved docs relevant?             │
│       ├── Context Recall — did we retrieve all relevant docs?          │
│       ├── Mean Reciprocal Rank (MRR)                                  │
│       ├── Normalized Discounted Cumulative Gain (nDCG)                │
│       ├── Hit Rate / Recall@K                                         │
│       └── Mean Average Precision (MAP)                                │
│                                                                       │
│  17.3 Generation Metrics                                              │
│       ├── Faithfulness — is the answer supported by context?           │
│       ├── Answer Relevance — does the answer address the question?    │
│       ├── Groundedness — is every claim grounded in sources?          │
│       ├── Hallucination Rate — % of unsupported claims                │
│       ├── Answer Correctness — is the answer factually correct?       │
│       └── Answer Completeness — does the answer cover all aspects?    │
│                                                                       │
│  17.4 End-to-End Metrics                                              │
│       ├── Latency (time to answer)                                    │
│       ├── Cost (tokens used per query)                                │
│       ├── User satisfaction (thumbs up/down)                          │
│       └── Task completion rate                                        │
│                                                                       │
│  17.5 Evaluation Frameworks                                           │
│       ├── RAGAS (Retrieval Augmented Generation Assessment)            │
│       ├── LangSmith                                                   │
│       ├── DeepEval                                                    │
│       ├── TruLens                                                     │
│       ├── Phoenix (Arize)                                             │
│       ├── Custom evaluation pipelines                                 │
│       └── LLM-as-a-Judge evaluation                                   │
│                                                                       │
│  17.6 Building Evaluation Datasets                                    │
│       ├── Ground truth creation                                       │
│       ├── Synthetic test generation                                   │
│       ├── Human annotation                                            │
│       └── Continuous evaluation in production                         │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 16 — Production RAG Systems

> **What separates a demo from a product. Production RAG has an entirely different set of challenges.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│                PART 16: PRODUCTION RAG SYSTEMS                        │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  18.1 Caching                                                         │
│       ├── Semantic caching — similar questions → cached answers        │
│       ├── Exact match caching                                         │
│       ├── Embedding-based cache lookup                                │
│       ├── TTL and cache invalidation                                  │
│       └── Cost savings from caching                                   │
│                                                                       │
│  18.2 Monitoring & Observability                                      │
│       ├── What to monitor (latency, error rate, retrieval quality)     │
│       ├── Tracing tools: LangSmith, Phoenix, Langfuse                 │
│       ├── Dashboard design for RAG pipelines                          │
│       ├── Alerting on quality degradation                             │
│       └── Debugging retrieval failures                                │
│                                                                       │
│  18.3 Logging                                                         │
│       ├── Query logs                                                  │
│       ├── Retrieval logs (what was retrieved, scores)                  │
│       ├── Generation logs (prompts, responses)                        │
│       ├── User feedback logs                                          │
│       └── Compliance and audit trail                                  │
│                                                                       │
│  18.4 Streaming                                                       │
│       ├── Token streaming for real-time UX                             │
│       ├── Server-Sent Events (SSE)                                    │
│       ├── WebSockets                                                  │
│       └── Streaming with source citations                             │
│                                                                       │
│  18.5 Security                                                        │
│       ├── Prompt injection defense                                    │
│       ├── Data exfiltration prevention                                │
│       ├── Input validation and sanitization                           │
│       └── Adversarial query handling                                  │
│                                                                       │
│  18.6 Access Control                                                  │
│       ├── Document-level permissions                                  │
│       ├── User-role-based filtering                                   │
│       ├── Row-level security for vector databases                     │
│       └── Ensuring users only see authorized documents                │
│                                                                       │
│  18.7 PII Handling                                                    │
│       ├── Detecting personally identifiable information               │
│       ├── PII redaction before indexing                                │
│       ├── PII masking in responses                                    │
│       └── GDPR/CCPA compliance                                       │
│                                                                       │
│  18.8 Document Freshness & Maintenance                                │
│       ├── Detecting stale documents                                   │
│       ├── Scheduled reindexing                                        │
│       ├── Webhook-triggered updates                                   │
│       ├── Document lifecycle management                               │
│       └── Chunk refresh strategies                                    │
│                                                                       │
│  18.9 Scaling                                                         │
│       ├── Horizontal scaling of retrieval                             │
│       ├── Load balancing across vector DB replicas                    │
│       ├── Queue-based processing for batch workloads                  │
│       ├── Auto-scaling based on traffic                               │
│       └── Multi-region deployment                                     │
│                                                                       │
│  18.10 Cost Optimization                                              │
│       ├── Embedding model cost reduction                              │
│       ├── LLM call optimization (caching, smaller models)              │
│       ├── Storage optimization                                        │
│       ├── Batch processing for non-real-time workloads                │
│       └── Cost monitoring and budgeting                               │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# PART 17 — Latest RAG Research (2026)

> **The cutting edge. Where RAG is heading next.**

### Topics

```
┌──────────────────────────────────────────────────────────────────────┐
│            PART 17: LATEST RAG RESEARCH (2026)                        │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  19.1 Agentic RAG Evolution                                           │
│       ├── Agents that plan multi-step retrieval strategies             │
│       ├── Self-improving retrieval agents                             │
│       └── Autonomous research agents (Perplexity, Gemini Deep Research│
│                                                                       │
│  19.2 Deep Research Systems                                           │
│       ├── Multi-step, iterative research pipelines                    │
│       ├── OpenAI Deep Research, Google Deep Research                   │
│       ├── Automated literature review                                 │
│       └── Report generation from multiple sources                     │
│                                                                       │
│  19.3 Long Context vs RAG                                             │
│       ├── 1M+ context windows — do we still need RAG?                 │
│       ├── When long context beats RAG                                 │
│       ├── When RAG still wins (cost, freshness, scale)                │
│       └── The convergence: Long Context + RAG hybrid                  │
│                                                                       │
│  19.4 Memory-Augmented LLMs                                           │
│       ├── Persistent memory layers                                    │
│       ├── MemoryGPT, Zep, Mem0                                       │
│       ├── Episodic vs semantic memory                                 │
│       └── Memory as an evolution of RAG                               │
│                                                                       │
│  19.5 MCP-Based Retrieval                                             │
│       ├── Model Context Protocol (Anthropic)                          │
│       ├── Standardized context delivery to LLMs                       │
│       ├── MCP servers as universal retrieval interfaces                │
│       └── Impact on RAG architecture                                  │
│                                                                       │
│  19.6 Hierarchical RAG                                                │
│       ├── Multi-level retrieval (summary → section → paragraph)       │
│       ├── Raptor (Recursive Abstractive Processing for Tree-           │
│       │   Organized Retrieval)                                        │
│       └── Tree-structured document representations                    │
│                                                                       │
│  19.7 Reasoning + Retrieval                                           │
│       ├── Chain-of-thought with retrieval                             │
│       ├── Reasoning models (o3, o4) + RAG                             │
│       ├── Interleaved thinking and searching                          │
│       └── When to think vs when to search                             │
│                                                                       │
│  19.8 Self-Improving RAG                                              │
│       ├── Systems that learn from user feedback                       │
│       ├── Automatic retrieval strategy optimization                   │
│       ├── Reinforcement learning for retrieval                        │
│       └── Continuous improvement loops                                │
│                                                                       │
│  19.9 Vision-First RAG                                                │
│       ├── Process documents as images instead of text                  │
│       ├── ColPali, ColQwen — visual document embeddings               │
│       ├── Bypass OCR and text extraction entirely                      │
│       └── End-to-end visual document retrieval                        │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# Practical Projects (Progressive Complexity)

> **We'll build projects that increase in complexity as you learn.**

```
┌──────────────────────────────────────────────────────────────────────┐
│                PRACTICAL PROJECTS ROADMAP                              │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  PROJECT 1: Basic PDF Q&A                                             │
│  ─────────────────────────                                            │
│  Skills: Document loading, chunking, embeddings, vector search        │
│  Stack: PyPDF2, OpenAI Embeddings, ChromaDB, LangChain                │
│  Goal: Load a PDF, chunk it, embed it, store vectors, answer Q&A      │
│                                                                       │
│  PROJECT 2: Multi-Document RAG                                        │
│  ────────────────────────────                                         │
│  Skills: Multiple formats, metadata, hybrid search                    │
│  Stack: Unstructured, multiple loaders, Qdrant, LangChain             │
│  Goal: Search across PDFs, DOCX, Markdown, and web pages              │
│                                                                       │
│  PROJECT 3: Enterprise RAG                                            │
│  ────────────────────────                                             │
│  Skills: Metadata filtering, hybrid search, reranking                 │
│  Stack: Pinecone/Weaviate, Cohere Rerank, advanced chunking           │
│  Goal: Production-grade RAG with reranking and access control          │
│                                                                       │
│  PROJECT 4: Agentic RAG                                               │
│  ──────────────────────                                               │
│  Skills: Agent planning, tool selection, multi-source retrieval        │
│  Stack: LangGraph, SQL + Vector DB + Web Search tools                 │
│  Goal: Agent decides whether to use vector DB, SQL, or web search     │
│                                                                       │
│  PROJECT 5: GraphRAG                                                  │
│  ───────────────────                                                  │
│  Skills: Knowledge graphs, entity extraction, graph traversal          │
│  Stack: Neo4j, LangChain GraphRetriever, entity linking               │
│  Goal: Combine knowledge graphs with vector search                    │
│                                                                       │
│  PROJECT 6: Production RAG System                                     │
│  ────────────────────────────                                         │
│  Skills: Scaling, monitoring, evaluation, CI/CD                       │
│  Stack: Full production stack with evaluation pipeline                │
│  Goal: Scalable RAG with indexing, monitoring, evaluation, updates    │
│                                                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

---

# Quick Reference — Module Map

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    COMPLETE MODULE MAP                                    │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  PART 1:  RAG FOUNDATIONS                                                │
│           ├── Module 1: The Problem Before RAG                           │
│           ├── Module 2: Information Retrieval History                     │
│           └── Module 3: Birth of RAG                                     │
│                                                                          │
│  PART 2:  EMBEDDINGS                                                     │
│           ├── Module 4: Embedding fundamentals                           │
│           ├── Module 5: Embedding models & types                         │
│           └── Module 6: Evaluation & fine-tuning                         │
│                                                                          │
│  PART 3:  DOCUMENT PROCESSING                                            │
│           ├── Module 7: Document formats & loading                       │
│           └── Module 8: OCR, tables, cleaning, metadata                  │
│                                                                          │
│  PART 4:  CHUNKING                                                       │
│           ├── Module 9: Chunking strategies                              │
│           └── Module 10: Chunk optimization                              │
│                                                                          │
│  PART 5:  INDEXING PIPELINE                                              │
│           ├── Module 11: Batch & incremental indexing                     │
│           └── Module 12: Metadata, versioning, reindexing                │
│                                                                          │
│  PART 6:  VECTOR SEARCH & DATABASES                                      │
│           ├── Module 13: Vector search algorithms                        │
│           └── Module 14: Vector database comparison                      │
│                                                                          │
│  PART 7:  RETRIEVAL PIPELINE                                             │
│           ├── Module 15: Basic retrieval                                  │
│           └── Module 16: Advanced retriever types                        │
│                                                                          │
│  PART 8:  QUERY UNDERSTANDING                                            │
│           ├── Module 17: Query rewriting & expansion                     │
│           └── Module 18: HyDE, multi-query, decomposition                │
│                                                                          │
│  PART 9:  RERANKING & CONTEXT OPTIMIZATION                               │
│           ├── Module 19: Bi-encoder vs cross-encoder                     │
│           └── Module 20: Context compression & ordering                  │
│                                                                          │
│  PART 10: GENERATION PIPELINE                                            │
│           ├── Module 21: Prompt construction & citations                  │
│           └── Module 22: Hallucination reduction & grounding             │
│                                                                          │
│  PART 11: ADVANCED RAG                                                   │
│           ├── Module 23: Adaptive, Corrective, Self-RAG                  │
│           └── Module 24: ColBERT, Dense/Sparse/Hybrid                    │
│                                                                          │
│  PART 12: AGENTIC RAG                                                    │
│           ├── Module 25: Agent planning & tool selection                  │
│           └── Module 26: Memory, verification, multi-agent               │
│                                                                          │
│  PART 13: GRAPH RAG                                                      │
│           ├── Module 27: Knowledge graphs & Neo4j                        │
│           └── Module 28: Hybrid graph + vector search                    │
│                                                                          │
│  PART 14: MULTIMODAL RAG                                                 │
│           ├── Module 29: Image, table, chart retrieval                    │
│           └── Module 30: Audio, video, vision RAG                        │
│                                                                          │
│  PART 15: EVALUATION                                                     │
│           ├── Module 31: Retrieval & generation metrics                   │
│           └── Module 32: Evaluation frameworks & datasets                │
│                                                                          │
│  PART 16: PRODUCTION RAG                                                 │
│           ├── Module 33: Caching, monitoring, security                   │
│           └── Module 34: Scaling, cost optimization, maintenance         │
│                                                                          │
│  PART 17: LATEST RESEARCH (2026)                                         │
│           ├── Module 35: Deep Research, MCP, hierarchical RAG            │
│           └── Module 36: Self-improving, vision-first, reasoning RAG     │
│                                                                          │
│  PROJECTS: 6 Progressive Projects                                        │
│           ├── P1: Basic PDF Q&A                                          │
│           ├── P2: Multi-Document RAG                                     │
│           ├── P3: Enterprise RAG                                         │
│           ├── P4: Agentic RAG                                            │
│           ├── P5: GraphRAG                                               │
│           └── P6: Production RAG System                                  │
│                                                                          │
│  TOTAL: 17 Parts │ 36 Modules │ 6 Projects                              │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

---

# Where We Begin

> We start with **Module 1: The Problem Before RAG**, because if you deeply understand *why* RAG was invented, every later topic — embeddings, chunking, vector databases, retrievers, rerankers, and agentic RAG — will feel like natural solutions to specific problems rather than disconnected concepts.

---

> **Next:** [Module 1 — The Problem Before RAG → To be created as a separate document]
