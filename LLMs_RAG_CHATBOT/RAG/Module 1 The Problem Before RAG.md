# Module 1 — The Problem Before RAG

> **Author:** Subramani V
> **Part of:** RAG Complete Learning Roadmap — PART 1: RAG Foundations
> **Goal:** Understand WHY RAG exists before learning HOW it works.

---

## Goal of this Module

By the end of this module, you should be able to answer:

- Why do we need RAG?
- Why isn't an LLM enough on its own?
- What is knowledge inside an LLM?
- What is parametric memory vs non-parametric memory?
- What are hallucinations, and what types exist?
- Why can't we just fine-tune an LLM every time data changes?
- What problems does RAG actually solve?

Think of this module as understanding the **pain points** that existed before RAG.

---

## Module Structure

```
1.1  The World Before LLMs
1.2  What Is Knowledge?
1.3  Where Does an LLM Store Knowledge?
1.4  Parametric Memory
1.5  Parametric vs Non-Parametric Memory  <- (NEW — from roadmap)
1.6  Static Knowledge
1.7  Knowledge Cutoff
1.8  Hallucinations
1.9  Types of Hallucinations             <- (NEW — from roadmap)
1.10 The Confidence Problem              <- (NEW — from roadmap)
1.11 Long Documents
1.12 The "Lost in the Middle" Problem    <- (NEW — from roadmap)
1.13 Private Company Data
1.14 Security Concerns                   <- (NEW — from roadmap)
1.15 Dynamic / Fresh Information
1.16 Why Fine-Tuning Is Not Enough
1.17 Catastrophic Forgetting             <- (NEW — from roadmap)
1.18 Cost of Retraining
1.19 Need for External Knowledge
1.20 The Birth of RAG
```

Notice that each topic naturally leads to the next.

---

## Topic 1.1 — The World Before LLMs

Let us travel back in time.

Imagine it is **2018**.

Suppose you ask:

> "What is the capital of Japan?"

Traditional software could not answer this on its own.

A developer had to write something like:

```python
if country == "Japan":
    return "Tokyo"
```

or store the information in a database.

The software had **no understanding**.

It simply matched rules or fetched stored values.

---

Then **search engines** came along.

When you searched:

```
Capital of Japan
```

The search engine:

- Crawled millions of web pages
- Ranked them by relevance
- Showed you a list of links

It did **not** generate an answer.

You still had to open a website and read it yourself.

---

Then **LLMs arrived**.

Now you ask:

```
What is the capital of Japan?
```

The LLM simply answers:

```
Tokyo.
```

No search. No database. No website.

Naturally, people asked:

> "If LLMs already know everything, why do we need RAG?"

That question leads us to the next topic.

---

## Topic 1.2 — What Is Knowledge?

This sounds simple but is actually one of the deepest ideas in AI.

**Knowledge is information a system can use to answer questions.**

Examples:

```
Earth revolves around the Sun.
Python is a programming language.
Paris is the capital of France.
Water freezes at 0 degrees Celsius.
```

Humans store knowledge in the brain.
Computers store knowledge in files or databases.

**Where does an LLM store knowledge?**

This is the central question.

---

## Topic 1.3 — Where Does an LLM Store Knowledge?

Most beginners think:

> "Maybe inside a database."

Wrong.

Others think:

> "Maybe inside a hidden text file."

Wrong.

An LLM stores knowledge inside **billions of learned parameters (weights)**.

GPT-like models have billions or even trillions of parameters.

During training, these parameters are adjusted to capture patterns from enormous text corpora.

A simplified view:

```
Books
News
Wikipedia
GitHub
Research Papers
Internet
       |
  Training Process
       |
Billions of Parameters
       |
Knowledge Representation
```

Those learned parameters **become** the model's internal knowledge.

---

## Topic 1.4 — Parametric Memory

**This is an interview favourite.**

### Definition

Knowledge stored inside the model's parameters is called **Parametric Memory**.

Why "parametric"?

Because the knowledge is encoded in the model's **parameters** (weights).

### Example

Suppose the model learned:

```
Python was created by Guido van Rossum.
```

Where is this fact stored?

Not in a database.
Not in a text file.
It is **distributed across many parameter values**.

That is why we say:

```
Training
    |
Weights (Parameters)
    |
Knowledge
```

The knowledge is not stored as one neat record.
It is spread across millions of interacting weights.

---

### Analogy — The Chef

Imagine a chef who has cooked for 20 years.

Ask:

```
How do you make pizza?
```

The chef does not pull out a recipe card.

The knowledge lives in **experience** — in their hands, memory, and intuition.

An LLM is similar: the knowledge lives in its weights, not in any file you can open.

---

### Key Interview Point

There is no single neuron that stores:

```
Paris = capital of France
```

Knowledge is **distributed**.

This is why modifying a single fact inside an LLM is extremely difficult.

---

## Topic 1.5 — Parametric vs Non-Parametric Memory

**This is a topic the roadmap specifically highlights. Many candidates miss it.**

| Feature | Parametric Memory | Non-Parametric Memory |
|---|---|---|
| Where stored | Inside model weights | Outside model (files, databases) |
| Updated by | Retraining or fine-tuning | Editing the external source |
| Cost to update | High | Low |
| Examples | LLM weights, neural networks | Databases, search indexes, document stores |
| Speed | Instant (no lookup needed) | Depends on retrieval latency |
| Freshness | Frozen at training time | Can be updated any time |

### Why This Matters for RAG

RAG combines **both**:

- **Parametric memory**: the LLM's trained knowledge (language, reasoning, world facts)
- **Non-parametric memory**: the retrieval database (your documents, live data, company policies)

The LLM provides language understanding.
The retrieval system provides fresh, accurate, domain-specific facts.

This combination is the fundamental insight behind RAG.

---

## Topic 1.6 — Static Knowledge

Here comes the first major limitation.

Suppose GPT was trained until:

```
December 2025
```

Everything learned during training becomes its internal parametric memory.

Now it is **August 2026**.

You ask:

```
Who won yesterday's Wimbledon final?
```

The model **does not know**.

Why? Because its knowledge does not update automatically.

Training finished months ago.

Its knowledge is **static** — frozen like a photograph.

---

### Analogy — The Encyclopedia

Imagine buying:

```
World Encyclopedia — 2020 Edition
```

You read it in 2026.

It still contains only information available up to 2020.

The book is not wrong — it is simply **outdated**.

An LLM behaves exactly the same, unless it retrieves external information.

---

## Topic 1.7 — Knowledge Cutoff

**Knowledge cutoff** is the specific point in time up to which the model was trained.

Example:

```
Learned:  2020 -> 2021 -> 2022 -> 2023 -> 2024 -> 2025
                                                   ^
                                            Cutoff Date

Not learned:   2026 (No)    2027 (No)
```

If someone asks:

```
What happened in the news yesterday?
```

The model cannot answer from parametric memory alone.

---

### Interview Question — Static Knowledge vs Knowledge Cutoff

**Q: What is the difference between static knowledge and knowledge cutoff?**

| Concept | Meaning |
|---|---|
| **Static Knowledge** | The model's learned knowledge does not update automatically after training ends |
| **Knowledge Cutoff** | The specific date up to which the model was trained |

The **cutoff** explains *where* the boundary is.
**Static knowledge** explains *why* new facts are not automatically included.

---

## Topic 1.8 — Hallucinations

**One of the most misunderstood topics in AI.**

### What People Think

Many people think hallucinations mean:

> "The model lies."

Not exactly.

### Better Definition

A hallucination occurs when the model **generates information that is unsupported, incorrect, or fabricated** while presenting it confidently.

Why does this happen?

Because the LLM is fundamentally a **next-token predictor**, not a fact lookup system.

The model does not "know" when it does not know something.

It continues generating the most probable next word — even if that word is wrong.

---

### Example 1 — Correct Answer

Question:

```
Who invented the Python programming language?
```

Correct answer:

```
Guido van Rossum
```

The model has seen this many times during training. It answers correctly.

---

### Example 2 — Hallucination

Question:

```
Who won the 2026 XYZ Robotics Championship yesterday?
```

If that information was not in training and the model has no retrieval system, it might still produce:

```
Team Alpha won the championship.
```

It is not retrieving a verified fact.
It is generating the **most probable continuation** of the text.

---

### Analogy — The Exam Student

Imagine a student in an exam.

They do not know the answer.

Instead of writing:

```
I don't know.
```

They **confidently invent** an answer.

That is similar to hallucination.

The model has no "I don't know" button by default.

---

## Topic 1.9 — Types of Hallucinations

**The roadmap specifically lists three types. Know them for interviews.**

### 1. Factual Hallucination

The model states something that is objectively false.

```
Example:
Q: When was the Eiffel Tower built?
A: The Eiffel Tower was built in 1756.
```

Correct answer: 1889

The model fabricates a plausible-sounding but incorrect fact.

---

### 2. Faithful Hallucination

The model generates something that **contradicts the provided context**.

This is especially dangerous in RAG.

```
Example:
Context provided: "The policy allows 5 days of sick leave per year."

Q: How many sick days do employees get?
A: Employees are entitled to 10 days of sick leave per year.
```

The model ignored the retrieved context and hallucinated a different number.

---

### 3. Instructional Hallucination

The model fails to follow the instructions given in the prompt.

```
Example:
Instruction: "Answer only with Yes or No."

Q: Is Paris the capital of France?
A: Yes, Paris is the beautiful capital city of France, located along the Seine river...
```

The model ignored the constraint and generated additional unrequested content.

---

### Summary Table

| Type | Description | Common Cause |
|---|---|---|
| **Factual** | States incorrect facts | Not in training data or low training signal |
| **Faithful** | Contradicts the provided context | Poor attention to retrieved documents |
| **Instructional** | Ignores prompt instructions | Model not well-aligned or overconfident |

---

## Topic 1.10 — The Confidence Problem

**This is what makes hallucinations dangerous.**

When an LLM hallucinates, it does not say:

```
I am not sure about this.
```

It says:

```
The answer is X.
```

with exactly the same confidence as when it is correct.

### Why This Happens

LLMs are trained to generate fluent, coherent text.

Being fluent means sounding confident.

The model has no internal "truth checker."

It generates the most probable continuation, and probable continuations sound authoritative.

---

### Why This Is Dangerous in Production

Consider a customer support bot:

```
User: What is the refund period for this product?
Bot:  The refund period is 90 days.
```

If the actual policy is 30 days and the bot hallucinated, a customer acts on wrong information.

This causes:

- Legal risk
- Financial loss
- Customer trust damage

RAG reduces this risk by **grounding** the model in retrieved documents.

But it does not eliminate hallucinations entirely.

---

## Topic 1.11 — Long Documents

Suppose your company has:

```
500-page policy manual
```

Can the LLM automatically know it?

No.

Unless that document was part of its training — which is extremely unlikely — it has no knowledge of it.

Even if you paste large parts of the document into the prompt, you eventually hit the model's **context window limit**.

```
Example:

GPT-4: 128,000 tokens = approximately 96,000 words = approximately 300 pages

A 1000-page legal contract: approximately 750,000 words
Does not fit in a single context window.
```

You cannot simply paste every page into every prompt.

That would be:

- **Expensive** (paying per token)
- **Slow** (LLM processes every token)
- **Often impossible** (exceeds limits)

---

### Analogy — The Library

Imagine asking someone to **memorize an entire library** before every conversation.

Not practical.

Instead, you would give them only the **relevant pages** from the relevant book.

That is exactly what retrieval does.

---

## Topic 1.12 — The "Lost in the Middle" Problem

**This is a critical insight from research that the roadmap specifically highlights.**

Even when a document *does* fit inside the context window, there is still a problem.

### What Research Found

A 2023 research paper (Liu et al.) showed that LLMs perform **worst** when relevant information is placed in the **middle** of a long context.

```
Context Position vs Performance:

Beginning of context  ->  HIGH accuracy
Middle of context     ->  LOW accuracy   <- dangerous zone
End of context        ->  HIGH accuracy
```

### Why This Happens

LLMs pay more attention to the beginning and end of a context.

This is called the "primacy" and "recency" effect.

Information buried in the middle gets relatively less attention.

---

### Implication for RAG

Even if you retrieved the right document, **where** you place the retrieved content in the prompt matters.

This is why reranking and context ordering are important topics in advanced RAG.

Simply stuffing all retrieved text into the prompt is not good enough.

---

## Topic 1.13 — Private Company Data

Suppose you work at a bank.

Internal documents include:

- Customer policies
- Loan approval rules
- Internal SOPs (Standard Operating Procedures)
- Compliance manuals
- HR documents

Would a public LLM know any of this?

No.

These documents were never part of public training data.

Even if you upload them once as context, the model does **not permanently learn** them.

The next conversation starts fresh.

---

### Example

An employee asks:

```
What is our company's travel reimbursement policy?
```

**Without retrieval:**

- The model does not know it.
- Or worse: it answers using a generic policy it hallucinated from similar companies.

**With RAG:**

- Retrieve the relevant section from the HR document.
- Pass it as context to the LLM.
- Generate an answer grounded in the actual policy.

This is one of the biggest reasons **enterprise RAG** exists.

---

### Competitive Advantage

Private data is often a company's most valuable asset:

- Proprietary research
- Customer interaction history
- Internal knowledge bases
- Domain expertise built over years

A competitor using the same public LLM cannot access your private data.

RAG is how companies unlock the value of their internal knowledge.

---

## Topic 1.14 — Security Concerns with Private Data

**This is a topic the roadmap specifically highlights. Know it.**

When you send private data to an external LLM API, you face real risks:

### Risk 1 — Data Exposure

Sending a customer's personal information, financial records, or trade secrets to a third-party API means that data leaves your infrastructure.

This may violate:

- GDPR (Europe)
- HIPAA (Healthcare in USA)
- PCI-DSS (Payment card data)
- Internal data governance policies

---

### Risk 2 — Training Data Contamination

Some cloud providers may use your queries to improve their models.

If your confidential data is used in training, competitors using the same model might inadvertently benefit from it.

---

### Risk 3 — Prompt Injection

Attackers can craft malicious inputs that cause the LLM to leak data it was given in the prompt (the retrieved context).

---

### How RAG Helps

With RAG deployed **on-premise** or in a **private cloud**:

- Documents never leave your infrastructure
- The LLM runs inside your security boundary
- You control what gets retrieved and shown to the model

This is why many enterprises build **private RAG systems** rather than using public APIs directly.

---

## Topic 1.15 — Dynamic / Fresh Information

Some information changes constantly.

| Category | Example |
|---|---|
| Financial | Stock prices, exchange rates |
| Weather | Temperature, forecasts |
| Sports | Live scores, match results |
| Travel | Flight status, seat availability |
| E-commerce | Product inventory, pricing |
| Business | Company dashboards, KPIs |

If an LLM relied only on parametric memory, its answers would be **permanently outdated**.

```
Example:
Q: Current stock price of TSLA?
A: (Model gives price from training data — months or years old)
```

The answer changes every second.

You do not want to retrain the model every second.

Instead, retrieve the latest data when needed.

This is why real-time RAG systems connect to live APIs and databases.

---

## Topic 1.16 — Why Fine-Tuning Is Not Enough

A common beginner question is:

> "Why not just fine-tune the model every time new information appears?"

Let us see why that **does not scale**.

---

### The Workflow Problem

Suppose your company updates:

- HR policy
- Product catalog
- Pricing tables
- Technical documentation
- FAQs

every day.

Fine-tuning after each change would require:

```
1. Collect and format new training data
2. Fine-tune the model (hours of GPU time)
3. Evaluate the fine-tuned model
4. Run safety and quality checks
5. Deploy the updated model
6. Monitor for regressions
```

Doing this daily — or hourly — is completely impractical.

---

### The Purpose Problem

Fine-tuning is designed to change **behaviour**, not to inject **facts**.

Fine-tuning is good for:

- Teaching the model a new tone or style
- Making it better at a specific task (e.g., SQL generation, code review)
- Domain adaptation (medical language, legal language)

Fine-tuning is **not** an efficient mechanism for:

- Keeping knowledge up-to-date
- Adding a large, frequently changing knowledge base

---

## Topic 1.17 — Catastrophic Forgetting

**This is a specific concept the roadmap highlights. Know it for interviews.**

### Definition

**Catastrophic forgetting** (also called catastrophic interference) is when a neural network, after being fine-tuned on new data, **loses performance on tasks it previously knew well**.

### Example

Suppose a general-purpose LLM is fine-tuned on your company's legal documents.

After fine-tuning:

- It may become better at answering legal questions
- But it may **forget** some general knowledge it had before
- It may overfit to legal language and perform worse on general queries

---

### Why This Happens

Neural networks do not have separate storage compartments.

When you train on new data, the gradient updates modify the same weights that stored old knowledge.

Old knowledge gets **overwritten** by new knowledge.

---

### Implication for RAG

RAG avoids this problem entirely.

You never modify the LLM's weights.

You simply update the **external knowledge base** (the retrieval database).

The LLM's core capabilities remain intact.

---

## Topic 1.18 — Cost of Retraining

Training large models is extremely expensive.

Even **fine-tuning** has significant costs:

| Cost Type | Description |
|---|---|
| Compute | GPU / TPU hours |
| Electricity | Data center power |
| Data preparation | Labelling, cleaning, formatting |
| Engineering time | Building training pipelines |
| Evaluation | Testing for quality and safety |
| Deployment | Serving infrastructure |
| Monitoring | Catching regressions post-deployment |

Example estimates (approximate):

- Fine-tuning a 7B model: $100 to $1,000+
- Fine-tuning a 70B model: $10,000+
- Pretraining a frontier model (GPT-4 scale): $10M to $100M+

Imagine doing even a fine-tune every day because one policy document changed.

That does not make economic sense.

RAG, by contrast, only requires:

- Embedding the new documents (cheap)
- Storing them in a vector database (cheap)

No model changes needed.

---

## Topic 1.19 — Need for External Knowledge

Let us summarize every problem we have uncovered:

| Problem | Can parametric memory solve it? | Solution via RAG |
|---|---|---|
| Latest news | No | Retrieve from news APIs |
| Company documents | No | Retrieve from internal knowledge base |
| Large PDFs exceeding context window | No | Chunk and retrieve relevant sections |
| Frequently changing data | No | Retrieve from live databases |
| Real-time databases | No | Connect retrieval to live sources |
| Internal policies | No | Index and retrieve HR documents |
| Live inventory | No | Query real-time inventory systems |
| Private financial data | No | On-premise RAG with private documents |

So we need another source of knowledge.

That source is **external knowledge** — knowledge stored outside the model, in databases, documents, and APIs.

Instead of expecting the model to memorize everything, we let it **access relevant information when needed**.

---

## Topic 1.20 — The Birth of RAG

Now everything comes together.

### The Original RAG Paper

**"Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks"**
Lewis et al. — Facebook / Meta AI Research, 2020

This paper introduced the RAG framework and showed it dramatically outperformed parametric-only LLMs on knowledge-intensive tasks.

---

### Old Approach — Parametric Only

```
User Question
      |
     LLM
      |
  Answer
(from parametric memory only)
```

Problems:

- Knowledge frozen at training
- Hallucinations
- No access to private data
- No real-time information

---

### New Approach — RAG

```
User Question
      |
Search External Knowledge Base
      |
Retrieve Most Relevant Chunks
      |
Inject Retrieved Context into Prompt
      |
     LLM
      |
Answer (grounded in retrieved evidence)
```

---

### What RAG Combines

```
RAG = Parametric Memory + Retrieved Context

Parametric Memory          Retrieved Context
(LLM trained knowledge     (Fresh, private,
 and language ability)      domain-specific information)
```

The LLM is no longer relying only on what it memorized.

It can now access **any document, database, or API** that you connect to it.

---

### Why RAG Works

| Advantage | Explanation |
|---|---|
| Reduces hallucinations | Answers grounded in real retrieved documents |
| No retraining needed | Update the knowledge base, not the model |
| Works with private data | Documents stay in your infrastructure |
| Cost-effective | Only embedding new docs is required |
| Verifiable | You can show users the source documents |
| Fresh | Knowledge base can be updated any time |

---

### Limitations of RAG

| Limitation | Explanation |
|---|---|
| Retrieval quality bottleneck | Bad retrieval leads to bad answers |
| Latency overhead | Retrieval plus generation takes longer than generation alone |
| Chunking sensitivity | How you split documents greatly affects retrieval quality |
| Complex to optimize | End-to-end quality requires tuning many components |
| Not a silver bullet | Some tasks do not need retrieval at all |

---

## Key Takeaways

| Concept | One-Line Summary |
|---|---|
| Parametric memory | Knowledge stored inside LLM weights, frozen after training |
| Non-parametric memory | Knowledge stored externally, can be updated any time |
| Static knowledge | LLM knowledge does not update after training ends |
| Knowledge cutoff | The specific date beyond which the model has no training data |
| Hallucination | Model generates confident-sounding but incorrect or unsupported information |
| Factual hallucination | States an objectively wrong fact |
| Faithful hallucination | Contradicts the provided retrieved context |
| Instructional hallucination | Ignores the instructions given in the prompt |
| Confidence problem | LLM sounds equally confident whether correct or hallucinating |
| Long documents | Documents often exceed context window limits |
| Lost in the middle | LLMs perform worst with relevant info buried in the middle of context |
| Private data | Public LLMs do not know your company's internal documents |
| Security concerns | Sending private data to external APIs creates legal and compliance risks |
| Fresh information | Dynamic data such as prices, scores, and news cannot come from parametric memory |
| Fine-tuning limits | Fine-tuning is for behaviour, not for continuously updating knowledge |
| Catastrophic forgetting | Fine-tuning new knowledge can overwrite previously learned knowledge |
| Cost of retraining | Retraining is expensive; RAG updates only need new embeddings |
| External knowledge | The insight: connect LLMs to external sources rather than memorizing everything |
| RAG | Retrieve relevant external knowledge, then generate an answer grounded in it |

---

## Interview Questions

After studying this module, you should be able to answer all of these:

1. What is parametric memory, and how is knowledge represented inside an LLM?
2. What is the difference between **parametric** and **non-parametric** memory?
3. What is the difference between static knowledge and knowledge cutoff?
4. Why do LLMs hallucinate?
5. What are the three **types of hallucinations**? Give an example of each.
6. What is the **confidence problem** in LLMs, and why does it make hallucinations dangerous?
7. What is the **"lost in the middle"** problem?
8. Why can an LLM not answer questions about documents it has never seen?
9. Why is fine-tuning **not** the preferred solution for frequently changing knowledge?
10. What is **catastrophic forgetting**, and how does RAG avoid it?
11. What **security concerns** arise when using private company data with public LLMs?
12. What kinds of problems motivated the invention of RAG?
13. How does RAG differ from using an LLM alone?
14. What are the **advantages** of RAG? What are its **limitations**?
15. Why is RAG especially valuable for enterprise AI applications?

---

## Quick Reference — RAG vs Fine-Tuning vs Long Context

| Scenario | Best Approach |
|---|---|
| Knowledge changes frequently | RAG |
| Private company documents | RAG |
| Real-time or live data | RAG |
| Change model tone or style | Fine-Tuning |
| Domain language adaptation | Fine-Tuning |
| Task-specific behaviour such as SQL or code | Fine-Tuning |
| All data fits in context window | Long Context |
| Need verifiable source attribution | RAG |
| Production frequently updated knowledge | RAG |

---

> **Next Module: Module 2 — Information Retrieval History**
> Before learning vector databases and embeddings, understand the decades of Information Retrieval research that led to modern RAG.
