# Module 2 — Information Retrieval (IR) Foundations

> **Author:** Subramani V
> **Part of:** RAG Complete Learning Roadmap — PART 1: RAG Foundations
> **Goal:** Understand the Information Retrieval foundations that modern RAG is built upon.

---

## Why This Module Matters

Most people learning RAG jump directly to embeddings and vector databases.

That is a mistake.

Modern RAG is built on **Information Retrieval (IR)** — a field that has existed since the 1950s, long before LLMs, Transformers, or ChatGPT.

Search engines like Google, Bing, Elasticsearch, Solr, and Apache Lucene all evolved from Information Retrieval research.

Understanding IR will make concepts like BM25, Hybrid Search, Dense Retrieval, Sparse Retrieval, Reranking, Recall, and Precision feel natural — not like random jargon.

---

## Module Structure

```
2.1   What is Information Retrieval?
2.2   IR vs Database Retrieval
2.3   Components of an IR System
2.4   Documents
2.5   Corpus
2.6   Query
2.7   Tokens and Terms
2.8   Relevance
2.9   Ranking
2.10  Search Engines - How They Work
2.11  Crawling -> Indexing -> Ranking Pipeline
2.12  The Inverted Index                     <- From roadmap
2.13  Precision
2.14  Recall
2.15  F1 Score                               <- From roadmap
2.16  The Precision-Recall Trade-off         <- From roadmap
2.17  Which Matters More for RAG?            <- From roadmap
2.18  Term Frequency (TF)
2.19  Inverse Document Frequency (IDF)
2.20  TF-IDF with full math                  <- From roadmap
2.21  Limitations of TF-IDF
2.22  BM25 with full math                    <- From roadmap
2.23  BM25 Parameters k1 and b              <- From roadmap
2.24  BM25 in Production: Elasticsearch, OpenSearch, Lucene
2.25  Sparse Retrieval
2.26  Semantic Search
2.27  Dense Retrieval
2.28  Lexical vs Semantic Strengths and Weaknesses
2.29  Hybrid Search
2.30  Reciprocal Rank Fusion (RRF)           <- From roadmap
2.31  Why IR Matters in RAG
```

Every topic builds naturally on the previous one.

---

## Topic 2.1 - What is Information Retrieval?

Let us start with a simple question.

Suppose you have **10 million documents** stored in your company.

A user asks:

> "What is the leave policy for new employees?"

The challenge is not generating the answer.

The challenge is **finding the correct document** among millions.

That process is called **Information Retrieval (IR)**.

### Definition

Information Retrieval is the process of **finding the most relevant information from a large collection of documents in response to a user query.**

IR does **not** generate new knowledge.

It **retrieves** existing knowledge.

---

### Real-World Analogy - The Librarian

Imagine a huge library with ten million books.

You ask the librarian:

"I want a book about Machine Learning."

The librarian does not write a new book.

The librarian searches the library and hands you the most relevant books.

That is Information Retrieval.

---

## Topic 2.2 - IR vs Database Retrieval

Many beginners confuse these two. Here is the clear difference.

### Database Retrieval

You have a SQL table:

| Emp_ID | Name  | Salary |
|---|---|---|
| 101 | Alice | 50000 |
| 102 | Bob | 70000 |

Query:

```sql
SELECT Salary FROM Employee WHERE Name = 'Bob';
```

Output: 70000

The answer is **exact**. There is no ambiguity.

---

### Information Retrieval

You have:

```
HR Policy.pdf
Leave Policy.pdf
Insurance.pdf
Travel Policy.pdf
Benefits.pdf
```

User asks:

"How many casual leaves do new employees get?"

There is no SQL row for this.

The system must:

- Understand the query
- Search through document text
- Rank documents by relevance
- Return the most useful ones

This is Information Retrieval.

---

### Comparison Table

| Feature | Database Retrieval | Information Retrieval |
|---|---|---|
| Data type | Structured (rows, columns) | Unstructured (text, documents) |
| Match type | Exact match | Best match |
| Query language | SQL | Natural language or keywords |
| Output | Rows | Ranked documents |
| Result | Deterministic | Relevance-based |
| Example tools | PostgreSQL, MySQL | Elasticsearch, Solr, BM25 |

---

## Topic 2.3 - Components of an IR System

Every retrieval system has the same building blocks:

```
User
  |
Query
  |
Search Engine / Retriever
  |
Ranking Algorithm
  |
Top-K Documents
```

Modern RAG follows exactly this pattern.

Later, we replace the traditional search engine with a vector database and embedding-based retrieval.

---

## Topic 2.4 - Documents

Everything searchable is treated as a **document**.

Examples:

- PDF files
- Word documents (DOCX)
- HTML web pages
- Emails
- Markdown files
- Wiki pages
- Research papers
- Source code files
- Chat conversation logs

A document is simply a unit of information that can be indexed and retrieved.

---

## Topic 2.5 - Corpus

**Interview Question: What is a corpus?**

A **corpus** is the complete collection of documents available for searching.

### Example

```
Company Knowledge Base
  |-- HR (1,200 documents)
  |-- Finance (800 documents)
  |-- Engineering (15,000 documents)
  |-- Sales (3,000 documents)
  |-- Legal (2,000 documents)

Total: 22,000 documents = the corpus
```

### Analogy

The entire contents of a library = corpus.
Each individual book = document.

---

## Topic 2.6 - Query

A query is the user information request.

Examples:

```
"vacation policy"
"Python generators"
"refund process"
"how does Kubernetes work"
"annual report 2024"
```

Everything begins with a query.

The quality of the query heavily influences what gets retrieved.

---

## Topic 2.7 - Tokens and Terms

Search engines do not treat sentences as single units.

Suppose the query is:

```
Python programming language
```

The search engine breaks it into terms:

```
Python  |  programming  |  language
```

Each term becomes individually searchable.

This process is called **tokenization**.

### Stop Words

Common words like "is", "the", "a", "of" are often removed because they appear in almost every document and carry little meaning.

```
"What is the capital of France?"
   -> After stop word removal:
"capital France"
```

---

## Topic 2.8 - Relevance

Imagine searching:

```
Python decorators
```

You retrieve three documents.

| Document | Content |
|---|---|
| Doc A | Python decorators tutorial with examples |
| Doc B | Python variables and scope |
| Doc C | Cooking recipes for decorative cakes |

Which is most relevant?

Clearly Doc A.

**Relevance** measures how useful a document is for answering the user query.

Relevance is not binary. It is a **score** — some documents are more relevant than others.

---

## Topic 2.9 - Ranking

Suppose retrieval finds 100 potentially relevant documents.

Which one should appear first?

The search engine assigns a **relevance score** to each document.

| Document | Relevance Score |
|---|---|
| Doc A | 0.98 |
| Doc B | 0.90 |
| Doc C | 0.82 |
| Doc D | 0.75 |

Documents are sorted by score. The highest score appears first.

This process is called **ranking**.

Without ranking, a search system returning 100,000 results in random order would be useless.

---

## Topic 2.10 - Search Engines: How They Work

A search engine is an automated IR system that operates at massive scale.

Understanding how Google, Bing, and Elasticsearch work internally helps you understand why RAG systems are designed the way they are.

A search engine has three main stages:

```
Stage 1: Crawling
Stage 2: Indexing
Stage 3: Ranking (Query time)
```

---

## Topic 2.11 - The Crawling -> Indexing -> Ranking Pipeline

### Stage 1: Crawling

The crawler automatically visits web pages or documents and reads their content.

```
Web
  |-- Page A -> Crawler reads content
  |-- Page B -> Crawler reads content
  |-- Page C -> Crawler reads content

Crawler stores raw content.
```

For enterprise RAG, crawling means reading your PDF, DOCX, and HTML files from your document store.

---

### Stage 2: Indexing (Offline Pipeline)

After crawling, the system **indexes** the content so it can be searched efficiently.

```
Raw Documents
     |
Text Extraction
     |
Cleaning and Normalization
     |
Tokenization
     |
Build Inverted Index (or Vector Index)
     |
Store in Search Index
```

This is done **offline** (before any user queries arrive).

Building the index is the expensive, one-time step.

Searching the index later is fast.

---

### Stage 3: Ranking (Online / Query Time)

When a user submits a query:

```
User Query
     |
Query Processing (tokenize, clean)
     |
Lookup in Index
     |
Candidate Documents Retrieved
     |
Scoring and Ranking
     |
Top-K Results Returned
```

This must happen in **milliseconds**.

---

## Topic 2.12 - The Inverted Index

**This is the data structure that powers ALL traditional search engines. It is a critical concept.**

### The Problem

Suppose you have 10 million documents and a user searches for the word "Python".

You cannot open every document and scan for the word "Python". That would take hours.

### The Solution: Inverted Index

An **inverted index** is a data structure that maps every word to the list of documents that contain it.

Think of it as the index at the back of a textbook:

```
textbook index:
  arrays ......... pages 45, 67, 102
  functions ....... pages 23, 34, 89
  loops ........... pages 12, 45, 78
```

An inverted index works the same way:

```
Inverted Index:

"Python"      -> [Doc1, Doc3, Doc7, Doc12, ...]
"machine"     -> [Doc2, Doc5, Doc9, ...]
"learning"    -> [Doc2, Doc4, Doc5, Doc9, ...]
"decorator"   -> [Doc1, Doc7, ...]
```

---

### How It Works

**Step 1: During Indexing**

```
Doc1: "Python decorators are powerful"
Doc2: "Machine learning and deep learning"
Doc3: "Python is easy to learn"

Inverted Index:
  "python"    -> [Doc1, Doc3]
  "decorator" -> [Doc1]
  "machine"   -> [Doc2]
  "learning"  -> [Doc2, Doc3]
  "deep"      -> [Doc2]
  "easy"      -> [Doc3]
```

**Step 2: At Query Time**

User searches: "Python learning"

1. Look up "python" -> [Doc1, Doc3]
2. Look up "learning" -> [Doc2, Doc3]
3. Doc3 appears in both -> highest relevance

This lookup takes microseconds, not hours.

---

### Why Inverted Index Is So Fast

Instead of scanning every document for every query, the index pre-computes which documents contain which words.

```
Without index: O(N * D)   -> N queries, D documents each
With index:    O(1) lookup per term, then O(k) for k matching docs
```

This is why Google can search billions of pages in under one second.

---

### Inverted Index vs Vector Index

| Feature | Inverted Index | Vector Index |
|---|---|---|
| Stores | Word to document lists | Embedding vectors |
| Search type | Keyword / lexical | Semantic / meaning-based |
| Speed | Very fast | Fast (approximate) |
| Used by | BM25, Elasticsearch | FAISS, Pinecone, Weaviate |
| Best for | Exact term matching | Conceptual similarity |

Modern RAG systems use **both** types.

---

## Topic 2.13 - Precision

Suppose the system retrieves **10 documents**.

Of those 10, only **8 are actually useful**.

```
Precision = Relevant Retrieved / Total Retrieved
Precision = 8 / 10 = 0.80 = 80%
```

### Definition

Precision answers:

> Of the documents I retrieved, how many were actually relevant?

**High precision** = few irrelevant results returned.
**Low precision** = many irrelevant results mixed in.

---

### Analogy

You search "Machine Learning Books".

The librarian gives you 10 books.
- 9 are about Machine Learning
- 1 is a cooking book

Precision = 9/10 = 90%

---

## Topic 2.14 - Recall

Now imagine there are **20** relevant books in the entire library.

The librarian only finds **8** of them.

```
Recall = Relevant Retrieved / Total Relevant
Recall = 8 / 20 = 0.40 = 40%
```

### Definition

Recall answers:

> Of all the relevant documents that exist, how many did the system actually find?

**High recall** = very few relevant documents were missed.
**Low recall** = many relevant documents were missed.

---

## Topic 2.15 - F1 Score

Neither precision nor recall alone tells the complete story.

**F1 Score** is the harmonic mean of precision and recall:

```
F1 = 2 * (Precision * Recall) / (Precision + Recall)
```

### Example

```
Precision = 0.80
Recall    = 0.40

F1 = 2 * (0.80 * 0.40) / (0.80 + 0.40)
F1 = 2 * 0.32 / 1.20
F1 = 0.64 / 1.20
F1 = 0.533 = 53.3%
```

F1 is low because recall is low.

### Why Harmonic Mean and Not Arithmetic Mean?

Arithmetic average: (0.80 + 0.40) / 2 = 0.60

This would make the score look acceptable even when recall is terrible.

The harmonic mean punishes extreme imbalances more severely.

If either precision or recall is very low, F1 stays low.

---

## Topic 2.16 - The Precision-Recall Trade-off

Precision and recall often move in opposite directions.

**Scenario A — High Precision, Low Recall**

The system returns only 3 results, all perfectly relevant.

```
Precision = 3/3 = 100%
Recall    = 3/20 = 15%
```

You retrieved almost nothing, but what you got was perfect.

**Scenario B — High Recall, Low Precision**

The system returns 100 results to catch everything.

Only 20 of those 100 are relevant.

```
Precision = 20/100 = 20%
Recall    = 20/20 = 100%
```

You found everything relevant, but 80% of results were noise.

---

### Why You Cannot Maximize Both Simultaneously

If you increase recall by retrieving more documents, you inevitably include irrelevant ones, reducing precision.

If you increase precision by retrieving fewer, more selective results, you inevitably miss some relevant ones, reducing recall.

```
Recall  increases  ->  Precision decreases
Precision increases  ->  Recall decreases
```

---

## Topic 2.17 - Which Matters More for RAG?

**Interview favourite: "In a RAG system, do you prioritize precision or recall?"**

### Answer: Recall First, Then Precision

In RAG, the retrieval stage should prioritize **recall**.

**Why?**

The retriever job is to find all potentially relevant chunks.

The LLM and optionally a reranker can then discard irrelevant ones.

```
Retriever  -> (High Recall)     -> Retrieve many relevant candidates
     |
Reranker   -> (High Precision)  -> Keep only the best ones
     |
LLM        -> Generate answer from best chunks
```

**Missing a relevant document at retrieval time** is a fatal error.

The LLM can never recover from information it never saw.

**Retrieving some irrelevant documents** is acceptable.

The reranker and LLM can handle noise.

> Rule: Recall is the responsibility of the retriever. Precision is the responsibility of the reranker.


---

## Topic 2.18 - Term Frequency (TF)

Now we move to how traditional IR scores documents.

**Term Frequency (TF)** measures how often a word appears in a document.

```
TF(t, d) = Number of times term t appears in document d
           -----------------------------------------------
           Total number of terms in document d
```

### Example

Document:

```
"Python is a great language. Python is widely used."
```

Total words: 9
"Python" appears: 2 times

```
TF("Python", Doc) = 2 / 9 = 0.222
```

### Intuition

If a word appears many times in a document, the document is probably about that word.

### Problem with TF Alone

Common words like "the", "is", "a" appear many times in every document but carry no meaning.

TF alone would incorrectly rank these documents very high.

This leads to IDF.

---

## Topic 2.19 - Inverse Document Frequency (IDF)

**Inverse Document Frequency (IDF)** gives **more importance to rare words** and **less importance to common words**.

```
IDF(t) = log( N / df(t) )

Where:
  N     = Total number of documents in the corpus
  df(t) = Number of documents that contain term t
```

### Example

```
Corpus size (N) = 10,000 documents

"Python" appears in 500 documents:
  IDF("Python") = log(10000 / 500) = log(20) = 1.301

"the" appears in 9,500 documents:
  IDF("the") = log(10000 / 9500) = log(1.053) = 0.022
```

"Python" has a much higher IDF than "the".

"Python" is a more informative, discriminative word.

### Intuition

- Rare word (appears in few documents) -> High IDF -> More important
- Common word (appears in almost all documents) -> Low IDF -> Less important

---

## Topic 2.20 - TF-IDF (Full Math)

**TF-IDF** combines both TF and IDF to score how important a word is for a specific document relative to the entire corpus.

```
TF-IDF(t, d) = TF(t, d) * IDF(t)
```

### Full Example

Corpus: 10,000 documents
Document: "Python is a great language. Python is widely used."

Calculation for "Python":

```
TF("Python", Doc)  = 2/9 = 0.222
IDF("Python")      = log(10000 / 500) = 1.301
TF-IDF("Python")   = 0.222 * 1.301 = 0.289
```

Calculation for "is":

```
TF("is", Doc)      = 2/9 = 0.222
IDF("is")          = log(10000 / 9800) = log(1.020) = 0.009
TF-IDF("is", Doc)  = 0.222 * 0.009 = 0.002   <- very low, as expected
```

Words that are frequent in one document but rare across the corpus get the highest TF-IDF scores.

---

### Document Scoring for a Query

To rank documents for a query, sum the TF-IDF scores of all query terms:

```
Query: "Python language"

Score(Doc) = TF-IDF("Python", Doc) + TF-IDF("language", Doc)
```

Documents with higher total scores rank higher.

---

## Topic 2.21 - Limitations of TF-IDF

| Limitation | Explanation |
|---|---|
| No semantic understanding | "car" and "automobile" are treated as completely different words |
| Exact match only | If query uses different words than the document, it is missed |
| Document length sensitivity | Longer documents naturally have higher term frequencies |
| No word order | "Python bites snake" and "Snake bites Python" have identical scores |
| Sparse representation | Each document becomes a vector with one dimension per unique word — mostly zeros |

These limitations led to BM25 and eventually to dense embeddings.

---

## Topic 2.22 - BM25 (Full Math)

**BM25 (Best Matching 25)** is the current industry standard for lexical search.

It improves over TF-IDF by solving two major problems:

1. **TF saturation**: In TF-IDF, a word appearing 100 times scores 10x more than one appearing 10 times. BM25 introduces diminishing returns.
2. **Document length normalization**: Longer documents naturally contain more words. BM25 normalizes for this.

---

### BM25 Formula

```
BM25(d, Q) = SUM over each term t in query Q of:

  IDF(t)  *   TF(t,d) * (k1 + 1)
              -----------------------------------
              TF(t,d) + k1 * (1 - b + b * (|d| / avgdl))

Where:
  TF(t, d)  = Term frequency of term t in document d
  IDF(t)    = Inverse Document Frequency of term t
  |d|       = Length of document d in words
  avgdl     = Average document length across the corpus
  k1        = TF saturation parameter (default: 1.2 to 2.0)
  b         = Length normalization parameter (default: 0.75)
```

---

### Breaking Down the Formula

**Part 1: IDF(t)**

BM25 uses a slightly different IDF formula that is more numerically stable:

```
IDF(t) = log( (N - df(t) + 0.5) / (df(t) + 0.5) + 1 )
```

Rare words still get higher IDF scores.

---

**Part 2: TF Saturation (k1 controls this)**

In TF-IDF, TF=100 scores 100x higher than TF=1. This is unrealistic.

In BM25, as TF grows very large, the score **saturates** (approaches a ceiling of k1 + 1).

```
TF = 1   -> Score moderate
TF = 10  -> Score higher
TF = 100 -> Score only slightly higher than TF=10 (not 10x higher)
```

This is called the **saturation function**.

---

**Part 3: Document Length Normalization (b controls this)**

The denominator contains:

```
1 - b + b * (|d| / avgdl)
```

If a document is longer than average, the denominator gets larger, reducing the score.

This penalizes long documents from dominating just because they contain more words.

---

## Topic 2.23 - BM25 Parameters: k1 and b

| Parameter | Role | Typical Value |
|---|---|---|
| **k1** | Controls TF saturation. Higher k1 = less saturation. Lower k1 = stronger saturation. | 1.2 to 2.0 |
| **b** | Controls length normalization. b=1 = full normalization. b=0 = no normalization. | 0.75 |

### When to Adjust Parameters

- Short documents (tweets, titles): lower b (e.g., 0.3) — length normalization matters less
- Long documents (legal contracts, research papers): higher b (e.g., 0.9) — penalize length more
- Exact keyword matching matters a lot: higher k1 (e.g., 2.0)
- Keyword frequency should matter less: lower k1 (e.g., 1.2)

### Numeric Example

```
Document: "Python Python Python decorators"
|d| = 4 words
avgdl = 10 words
k1 = 1.5, b = 0.75

TF("Python", Doc) = 3

Numerator:   3 * (1.5 + 1) = 3 * 2.5 = 7.5

Length factor: 1 - 0.75 + 0.75 * (4/10)
             = 0.25 + 0.30
             = 0.55

Denominator: 3 + 1.5 * 0.55 = 3 + 0.825 = 3.825

BM25 TF component: 7.5 / 3.825 = 1.96

(Multiplied by IDF to get the final document score)
```

---

## Topic 2.24 - BM25 in Production: Elasticsearch, OpenSearch, Lucene

BM25 is the **default scoring algorithm** in the most widely used search infrastructure in the world.

| System | Notes |
|---|---|
| **Apache Lucene** | The foundational library. Elasticsearch and Solr are built on Lucene. BM25 is default since Lucene 6.0 (2016). |
| **Elasticsearch** | Used by thousands of companies. BM25 by default. |
| **OpenSearch** | AWS fork of Elasticsearch. BM25 by default. |
| **Apache Solr** | Enterprise search platform, built on Lucene. |

### Why BM25 is STILL Used in Production in 2026

Despite the rise of vector databases and embeddings:

- BM25 handles **exact keyword matching** better than embeddings (product IDs, error codes, names, serial numbers)
- BM25 is **extremely fast** — no GPU required
- BM25 is **interpretable** — you can explain why a document ranked where it did
- BM25 is **battle-tested** — decades of production use
- BM25 requires **no training data** — works out of the box immediately

This is why all serious production RAG systems use **BM25 + vector search together** (Hybrid Search).

---

## Topic 2.25 - Sparse Retrieval

BM25 and TF-IDF are examples of **sparse retrieval**.

### Why "Sparse"?

Each document is represented as a vector where:

- Each dimension corresponds to one unique word in the entire vocabulary
- Most values are zero (because most words do not appear in most documents)

Example with a tiny vocabulary of 6 words:

```
Vocabulary: [Python, machine, learning, cooking, recipe, decorator]

Doc A: "Python decorator tutorial"
Vector: [1, 0, 0, 0, 0, 1]   <- mostly zeros

Doc B: "cooking recipe collection"
Vector: [0, 0, 0, 1, 1, 0]   <- mostly zeros
```

Real vocabulary = 50,000+ words -> vectors are 50,000+ dimensions with 99%+ zeros.

### Characteristics of Sparse Retrieval

| Property | Value |
|---|---|
| Speed | Very fast (inverted index lookup) |
| Interpretability | High (you can see exactly which words matched) |
| Semantic understanding | None (exact word matching only) |
| Handling synonyms | Poor ("car" vs "automobile") |
| Infrastructure needed | Standard CPU-based search |

---

## Topic 2.26 - Semantic Search

Semantic search tries to understand **meaning**, not just words.

### The Problem Sparse Retrieval Cannot Solve

```
Query:    "How do I fix my car?"
Document: "Automobile repair and maintenance guide"
```

Sparse retrieval: No match. "car" is not in the document.
Semantic search: Strong match. "car" and "automobile" mean the same thing.

---

### How Semantic Search Works

Instead of matching words, semantic search converts text into **embedding vectors** that capture meaning.

```
"car"        -> vector [0.2, 0.8, -0.3, 0.5, ...]
"automobile" -> vector [0.21, 0.79, -0.28, 0.51, ...]
```

These vectors are close in vector space because the words mean similar things.

Semantic search measures **vector similarity** (cosine similarity or dot product) instead of word overlap.

We will study embeddings in full detail in Module 4 (Part 2 of the roadmap).

---

## Topic 2.27 - Dense Retrieval

Dense retrieval is the technical name for embedding-based semantic search.

### Why "Dense"?

Unlike sparse vectors (mostly zeros), embedding vectors are **dense** — every dimension has a non-zero value.

```
Sparse vector (TF-IDF): [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, ...]
                              <- 99% zeros

Dense vector (embedding): [0.23, -0.41, 0.78, 0.12, -0.55, ...]
                               <- no zeros
```

Dimensions in a dense vector do not correspond to individual words.

They represent **abstract semantic features** learned by the embedding model.

### How Dense Retrieval Works

```
Index time:
  Document -> Embedding Model -> Dense Vector -> Vector Database

Query time:
  Query -> Embedding Model -> Dense Vector
        -> Find nearest vectors in database (ANN search)
        -> Return top-K most similar documents
```

---

## Topic 2.28 - Lexical vs Semantic: Strengths and Weaknesses

| Feature | Lexical (BM25) | Semantic (Dense) |
|---|---|---|
| Synonyms ("car" vs "automobile") | Fails | Succeeds |
| Exact terms (product IDs, error codes) | Succeeds | Often fails |
| Acronyms ("ML" vs "Machine Learning") | Fails | Often succeeds |
| Speed | Very fast (CPU) | Slower (GPU-friendly) |
| Interpretability | High | Low (black box) |
| Infrastructure | Simple | Vector database needed |
| Training data required | No | Yes (for embedding model) |
| Out-of-domain performance | Consistent | Can degrade |

---

## Topic 2.29 - Hybrid Search

Modern production systems combine the strengths of both lexical and semantic search.

### Why Hybrid?

Neither method alone is good enough:

- **BM25 alone** misses semantically similar documents that use different words
- **Dense retrieval alone** misses exact keyword matches (product codes, names, numbers)

**Hybrid Search = BM25 + Dense Retrieval combined**

### Architecture

```
User Query
    |
    |-- BM25 Search    --> [Doc3, Doc7, Doc1, Doc12, ...]
    |
    |-- Vector Search  --> [Doc7, Doc2, Doc3, Doc15, ...]
    |
Merge and Rerank (RRF or weighted combination)
    |
Final Top-K Documents
```

---

## Topic 2.30 - Reciprocal Rank Fusion (RRF)

**This is the most common hybrid search merging algorithm. Know it for interviews.**

### The Problem

BM25 and vector search return documents with different, incompatible scores.

```
BM25 score:   42.3   (raw BM25 score, no upper bound)
Vector score:  0.87   (cosine similarity, range 0 to 1)
```

You cannot simply add them — they are on completely different scales.

### The RRF Solution

RRF ignores the raw scores entirely. It uses only the **rank positions** (1st, 2nd, 3rd...).

```
RRF_Score(document) = SUM over each retriever r of:
  1 / (k + rank_r(document))

Where:
  rank_r(document) = position of document in retriever r result list
  k = constant (typically 60) to reduce impact of top ranks
```

---

### RRF Example

```
BM25 results:    Doc3 (rank 1), Doc7 (rank 2), Doc1 (rank 3)
Vector results:  Doc7 (rank 1), Doc2 (rank 2), Doc3 (rank 3)

k = 60

RRF score for Doc3:
  From BM25:   1 / (60 + 1) = 1/61 = 0.0164
  From Vector: 1 / (60 + 3) = 1/63 = 0.0159
  Total:       0.0323

RRF score for Doc7:
  From BM25:   1 / (60 + 2) = 1/62 = 0.0161
  From Vector: 1 / (60 + 1) = 1/61 = 0.0164
  Total:       0.0325

RRF score for Doc2:
  From BM25:   0 (not in BM25 results)
  From Vector: 1 / (60 + 2) = 1/62 = 0.0161
  Total:       0.0161

Final ranking: Doc7 (0.0325) > Doc3 (0.0323) > Doc2 (0.0161)
```

A document that appears highly in **both** retrievers gets the best combined score.

---

### Why k = 60?

The constant k=60 is empirically chosen.

It prevents the very top-ranked document from dominating too much.

```
Without k (k=0): rank 1 = 1.0,  rank 2 = 0.5  <- massive gap
With k=60:       rank 1 = 0.0164, rank 2 = 0.0161  <- reasonable gap
```

---

### Alternative: Weighted Score Combination

Another approach normalizes scores to the same scale and combines with weights:

```
Hybrid_Score = alpha * BM25_normalized + (1 - alpha) * Vector_normalized

alpha = 0.5 means equal weight
alpha = 0.7 means BM25 weighted more heavily
```

This requires careful normalization and tuning of alpha for each use case.

RRF is generally preferred because it is simpler and does not require tuning.

---

## Topic 2.31 - Why IR Matters in RAG

Now everything connects.

A RAG pipeline **begins with retrieval**.

```
User Question
      |
Information Retrieval (BM25 / Dense / Hybrid)
      |
Top-K Relevant Document Chunks
      |
Inject into LLM Prompt
      |
LLM Generates Grounded Answer
```

### The Golden Rule of RAG

> The LLM can only work with what the retriever gives it.
> If the retriever returns wrong documents, even the best LLM produces wrong answers.
> Garbage in -> Garbage out.

This is why understanding TF-IDF, BM25, inverted indexes, recall, precision, and hybrid search is not optional.

It is the **foundation** of everything else in RAG.

---

## Key Takeaways

| Concept | One-Line Summary |
|---|---|
| Information Retrieval | Finding relevant documents from a large corpus in response to a query |
| IR vs Database | IR handles unstructured text with best-match; databases handle structured data with exact-match |
| Document | A unit of information (PDF, HTML, DOCX, email, etc.) |
| Corpus | The complete collection of searchable documents |
| Query | The user search request |
| Inverted Index | Maps every word to documents containing it; enables sub-second search |
| Relevance | How well a document answers the query |
| Ranking | Ordering documents by relevance score |
| Crawling | Automated reading of documents for indexing |
| Indexing | Pre-processing documents so they can be searched quickly |
| Precision | Of retrieved documents, what fraction was relevant |
| Recall | Of all relevant documents, what fraction was retrieved |
| F1 Score | Harmonic mean of precision and recall |
| Precision-Recall trade-off | Improving one typically hurts the other |
| RAG prioritizes Recall | Retriever finds all relevant docs; reranker handles precision |
| TF | How often a term appears in a document |
| IDF | Gives rare words higher weight than common words |
| TF-IDF | TF * IDF; classic word importance score |
| BM25 | Improved TF-IDF with saturation and length normalization; industry standard |
| k1 | BM25 parameter controlling TF saturation |
| b | BM25 parameter controlling document length normalization |
| Sparse retrieval | Word-based vectors, mostly zeros; used by BM25 |
| Dense retrieval | Embedding vectors, no zeros; used for semantic search |
| Semantic search | Matches meaning rather than exact words |
| Hybrid search | Combines BM25 and vector search for best results |
| RRF | Reciprocal Rank Fusion; merges retriever results using rank positions |
| Inverted index vs Vector index | Inverted for keyword search; vector for semantic search |

---

## Interview Questions

After studying this module, you should be able to answer all of these:

1. What is Information Retrieval, and how is it different from SQL database retrieval?
2. What is the difference between a document and a corpus?
3. What is an **inverted index**, and why does it enable fast search at scale?
4. What is relevance, and why is ranking necessary?
5. Explain the difference between **precision** and **recall** with a concrete example.
6. What is the **F1 Score**, and why does it use the harmonic mean instead of the arithmetic mean?
7. What is the **precision-recall trade-off**?
8. In a RAG system, should the retriever prioritize precision or recall? Why?
9. What is **Term Frequency (TF)**, and what is its limitation?
10. What is **Inverse Document Frequency (IDF)**, and what problem does it solve?
11. Explain **TF-IDF** with the full formula and a numeric example.
12. What are the **limitations of TF-IDF**?
13. What is **BM25**, and how does it improve over TF-IDF?
14. What are the **k1 and b parameters** in BM25, and what do they control?
15. Why is BM25 still used in production systems in 2026, despite the rise of embeddings?
16. What is the difference between **sparse retrieval** and **dense retrieval**?
17. What is **semantic search**, and how does it differ from lexical search?
18. Why do production RAG systems use **hybrid search** instead of BM25 or vector search alone?
19. What is **Reciprocal Rank Fusion (RRF)**, and how does it merge results from multiple retrievers?
20. What happens to RAG quality if the retrieval step is poor?

---

## Quick Reference - Search Methods Comparison

| Method | Handles Synonyms | Exact Match | Speed | Needs GPU | Interpretable | Example Tools |
|---|---|---|---|---|---|---|
| TF-IDF | No | Yes | Fast | No | Yes | Scikit-learn |
| BM25 | No | Yes | Very Fast | No | Yes | Elasticsearch, Lucene |
| Dense / Vector | Yes | Poor | Fast (ANN) | Preferred | No | FAISS, Pinecone, Weaviate |
| Hybrid (BM25 + Dense) | Yes | Yes | Moderate | Preferred | Partial | Most production RAG |

---

> **Next Module: Module 3 - The Birth of RAG**
> Now that you understand Information Retrieval deeply, you are ready to see exactly how the original RAG paper connected a retriever to a language model and why that was revolutionary.
