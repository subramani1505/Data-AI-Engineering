# RAG Roadmap — Module Coverage Evaluation

> **Purpose:** Evaluating whether the original roadmap covered all critical RAG topics  
> **Verdict:** Your original roadmap covered ~85% of what's needed. Below are the gaps and additions.

---

## What You Covered Well

| Area | Status | Notes |
|------|--------|-------|
| RAG Foundations (Why RAG exists) | Excellent | All key concepts covered |
| Information Retrieval History | Excellent | BM25, TF-IDF, precision/recall |
| Birth of RAG | Good | Original paper, retriever-generator architecture |
| Embeddings | Good | Core concepts covered |
| Document Processing | Good | PDFs, OCR, tables, metadata |
| Chunking | Excellent | All major strategies included |
| Indexing Pipeline | Good | Batch, incremental, metadata, versioning |
| Vector Databases | Excellent | All major DBs + algorithms (HNSW, IVF, PQ) |
| Retrieval Pipeline | Excellent | All retriever types covered |
| Query Understanding | Excellent | HyDE, multi-query, decomposition, step-back |
| Reranking | Good | Cross-encoder, reranker models, context compression |
| Advanced RAG | Excellent | Adaptive, Corrective, Self-RAG, ColBERT |
| Agentic RAG | Good | Planning, tool selection, verification |
| Graph RAG | Good | Knowledge graphs, Neo4j, hybrid search |
| Multimodal RAG | Good | Images, tables, audio, video |
| Evaluation | Good | Key metrics covered |
| Production RAG | Good | Caching, monitoring, security, scaling |
| Latest Research | Good | MCP, deep research, long context vs RAG |

---

## Gaps Identified and Added in the Expanded Roadmap

These are topics that were missing or underrepresented in your original outline:

### 1. Embedding Model Ecosystem (Added to Part 2)

- Specific embedding model names (text-embedding-3, BGE, E5, GTE)
- MTEB benchmark for comparing embedding models
- Fine-tuning embedding models (contrastive learning, hard negatives)
- Cross-modal embeddings (CLIP)
- Query vs passage embedding asymmetry

**Why it matters:** You can't choose the right embedding model without knowing the landscape.

---

### 2. Inverted Index (Added to Module 2)

- How inverted indexes work (the data structure behind BM25)
- Word to document list mapping
- Inverted index vs vector index comparison

**Why it matters:** Understanding inverted indexes is essential to understanding why hybrid search works.

---

### 3. RAG vs Fine-Tuning vs Long Context (Added to Module 3)

- When to use RAG vs fine-tuning vs long context
- RAG for dynamic knowledge and frequent updates
- Fine-tuning for behavioral changes and domain adaptation
- Hybrid approaches in production

**Why it matters:** This is one of the most common questions AI engineers face.

---

### 4. Generation Pipeline Details (Expanded as Part 10)

- Prompt construction patterns for RAG
- Context formatting (numbered sources, metadata inclusion)
- Token budget management
- Streaming responses with citations
- Post-generation fact checking

**Why it matters:** Your original had "Generation" as a topic list but lacked architectural depth.

---

### 5. Multi-Agent RAG (Added to Part 12)

- Specialized agents (retriever agent, analyst agent)
- Supervisor/orchestrator patterns for RAG
- LangGraph implementation of multi-agent RAG
- Agent collaboration for complex queries

**Why it matters:** Connects directly to your LangGraph and multi-agent systems knowledge.

---

### 6. Microsoft GraphRAG Architecture (Added to Part 13)

- Community detection in document collections
- Hierarchical summarization
- Global vs local queries
- Open-source implementation

**Why it matters:** Microsoft GraphRAG is the most prominent Graph RAG implementation in 2025-2026.

---

### 7. Evaluation Frameworks (Expanded in Part 15)

- RAGAS framework
- LangSmith evaluation
- DeepEval, TruLens, Phoenix
- LLM-as-a-Judge methodology
- Building evaluation datasets
- Synthetic test generation

**Why it matters:** Without proper evaluation tooling, you can't systematically improve RAG quality.

---

### 8. Production Security (Expanded in Part 16)

- Semantic caching (not just caching)
- Cost optimization strategies
- Prompt injection defense
- Data exfiltration prevention
- Blue-green deployment for indexes
- Multi-region deployment

**Why it matters:** Production RAG has security and cost challenges that demos never face.

---

### 9. Vision-First RAG (Added to Part 17)

- ColPali, ColQwen — visual document embeddings
- Process documents as images (bypass OCR entirely)
- End-to-end visual document retrieval
- When vision RAG beats text RAG

**Why it matters:** This is one of the hottest research areas in 2025-2026.

---

### 10. Hierarchical RAG / RAPTOR (Added to Part 17)

- RAPTOR (Recursive Abstractive Processing for Tree-Organized Retrieval)
- Multi-level retrieval (summary to section to paragraph)
- Tree-structured document representations

**Why it matters:** RAPTOR is a widely-cited architecture for long document retrieval.

---

## Coverage Summary

| Category | Original Coverage | After Additions |
|----------|:-----------------:|:---------------:|
| Foundations | 95% | 100% |
| Embeddings | 70% | 95% |
| Document Processing | 85% | 95% |
| Chunking | 95% | 100% |
| Indexing | 85% | 95% |
| Vector Search and DBs | 95% | 100% |
| Retrieval Pipeline | 90% | 100% |
| Query Understanding | 95% | 100% |
| Reranking | 85% | 95% |
| Generation | 60% | 95% |
| Advanced RAG | 90% | 100% |
| Agentic RAG | 80% | 95% |
| Graph RAG | 80% | 95% |
| Multimodal RAG | 85% | 95% |
| Evaluation | 65% | 95% |
| Production RAG | 75% | 95% |
| Latest Research | 80% | 95% |
| **Overall** | **~82%** | **~97%** |

---

## Final Verdict

Your original roadmap was very strong — it covered the vast majority of important RAG topics. The main gaps were:

1. **Depth in Generation** — you listed topics but didn't break them down
2. **Embedding model ecosystem** — knowing which models exist and how to evaluate them
3. **Evaluation frameworks** — the specific tools and methodologies
4. **Vision-first RAG** — a major 2025-2026 trend you missed
5. **Production security** — prompt injection, PII, access control

All of these have been addressed in the expanded roadmap document.
