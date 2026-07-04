# LangGraph — Complete Introduction

---

## 1. The Evolution of AI Development

```
Python
  ↓
LLMs  (OpenAI · Claude · Gemini)
  ↓
LangChain
  ↓
AI Agents
  ↓
Multi-Agent Systems
  ↓
LangGraph
```

---

## 2. Why LangGraph? — The Problem with LangChain

LangChain made it easy to build LLM applications by chaining steps together.
Common LangChain workflows look like this:

```
User → Prompt → LLM → Output Parser → Final Answer

Question → Retriever → LLM → Answer

User → Agent → Tool → LLM → Answer
```

These workflows are **linear** — once execution starts, it moves forward step by step without branching, looping, or backtracking.

### The Real-World Problem

Imagine asking a human employee: **"Book my flight."**

A real employee does **not** move linearly. They think like this:

```
Question
    ↓
Do I know the destination?
   /           \
No              Yes
 |               |
Ask User     Search Flights
 |               |
 └──────┬────────┘
        ↓
   Compare Prices
        ↓
   Book Ticket
```

The employee:
- Makes decisions at each step
- Asks clarifying questions when needed
- Repeats steps if results are unsatisfactory
- May hand off to another person

**This is not linear — and LangChain cannot model it naturally.**

### How Real AI Systems Actually Work

A capable AI solving a hard problem works like this:

```
Question
    ↓
Understand
    ↓
Need Search?
   /        \
Yes          No
 |            |
Search      Think
 |            |
Read Results  |
    └────┬────┘
         ↓
Need More Information?
   /             \
Yes               No
 |                 |
Search Again    Final Answer
 |
Combine → Final Answer
```

There are **branches**, **loops**, **decisions**, **retries**, and **human approvals** here.
LangChain cannot represent these naturally. That is why **LangGraph** was created.

---

## 3. What is a Graph?

**A Chain** moves in one direction only:

```
A → B → C → D
```

**A Graph** can branch, merge, loop, and resume from any point:

```
        B
       ↗
A  →  C  →  D
       ↘
        E
```

Or in a real AI workflow:

```
           Search
          ↗
User → Decide
          ↘
           Calculator → Answer
```

A graph can **branch**, **merge**, **repeat**, **loop**, **stop anywhere**, and **resume later** — exactly how humans think and solve problems.

---

## 4. What is LangGraph?

> **LangGraph** is an open-source library built on top of LangChain that enables developers to build **stateful, multi-step, and multi-agent AI applications** using a graph-based execution model.

It models workflows as **directed graphs** where:
- Each **Node** = a computation step (LLM call, tool use, custom logic)
- Each **Edge** = a connection that controls the flow between steps

LangGraph supports **loops**, **conditionals**, **branching**, **human approval**, **persistent memory**, and **multi-agent coordination** — things standard chains cannot express.

### Think of it this way

| | LangChain | LangGraph |
|---|---|---|
| **Purpose** | Build AI Applications | Build AI Workers |
| **Execution** | Linear pipelines | Graph-based workflows |
| **Decisions** | Fixed flow | Conditional branching |
| **Memory** | Minimal | Rich shared state |
| **Agents** | Single agent | Multi-agent systems |
| **Workflows** | Short, sequential | Long-running, complex |
| **Best For** | RAG, Q&A, simple chains | Autonomous agents, orchestration |

---

## 5. Graph Terminology

```
        Search Tool
       /
User ──
       \
        Calculator
              \
               Answer
```

| Term | Definition |
|------|-----------|
| **Node** | Every block in the graph (e.g., Search Tool, Calculator, Answer) |
| **Edge** | A connection between two nodes |
| **Conditional Edge** | An edge that routes dynamically based on the current state |
| **State** | The shared data structure that flows through the entire graph |

---

## 6. What Makes LangGraph Special?

### 6.1 Stateful
Unlike normal chains, LangGraph **remembers information** across all nodes through a shared state:

```python
State = {
    "question":    ...,
    "documents":   ...,
    "history":     ...,
    "tool_output": ...,
    "summary":     ...
}
```

Every node can read from and write to this state.

### 6.2 Decision Making
Instead of `A → B → C → D → E`, you can do:

```
A
↓
Should Search?
  /        \
Yes         No
 |           |
Search      Skip
 └────┬──────┘
      ↓
   Answer
```

### 6.3 Loops
If search results are poor, retry until satisfied:

```
Search
  ↓
Enough Information?
  /        \
No          Yes
 |            |
Search Again  Answer
  ↑_____|
```

### 6.4 Multiple Agents
Each agent is independent and specialised:

```
Research Agent → Writer Agent → Reviewer Agent → Editor Agent
```

### 6.5 Human-in-the-Loop
Very common in enterprise workflows:

```
AI → Generate Reply → Human Approval
                          /       \
                       Yes         No
                        |           |
                       Send       Rewrite
```

### 6.6 Long-Running Workflows
Some workflows run for hours or days — LangGraph supports durable execution:

```
Receive Request → Wait → Receive Approval Tomorrow → Continue
```

---

## 7. LangGraph Core Components

| Component | Description |
|-----------|-------------|
| **StateGraph** | The top-level graph object — add nodes and edges, then compile |
| **State** | Shared TypedDict or Pydantic model that flows through all nodes |
| **Nodes** | Python functions that read state and return updated state fields |
| **Edges** | Connections between nodes — unconditional or conditional |
| **Reducers** | Control how state fields are updated (overwrite vs. append) |
| **Checkpointers** | Persistence layer — saves and restores graph state across runs |
| **Human-in-the-Loop** | Pause execution mid-graph and wait for human input |
| **Subgraphs** | Embed one `StateGraph` as a node inside another for modularity |
| **Multi-Agent Patterns** | Supervisor, hierarchical teams, swarm / peer-to-peer handoffs |
| **Streaming** | Real-time token-level or node-level output streaming |
| **LangGraph Studio** | Visual IDE for designing, debugging, and replaying graph runs |
| **LangGraph Platform** | Cloud deployment platform for scaling LangGraph applications |

---

## 8. Key Concept Deep-Dives

### 8.1 State
The single source of truth. Every node reads from and writes to it.

```python
from typing import TypedDict, Annotated
from langgraph.graph.message import add_messages

class AgentState(TypedDict):
    messages: Annotated[list, add_messages]  # appends, not overwrites
    question: str
    documents: list
```

### 8.2 Nodes
Plain Python functions. They receive state and return a partial update.

```python
def my_node(state: AgentState) -> dict:
    question = state["question"]          # read from state
    return {"documents": fetch_docs(question)}  # return only updated fields
```

### 8.3 Edges
```python
graph.add_edge("node_a", "node_b")                # Normal edge
graph.add_conditional_edges("node_a", router_fn)  # Conditional edge
```

### 8.4 Reducers
Control how list fields behave when multiple nodes update them:
- **Default** — overwrite: new value replaces the old value
- **`add_messages`** — append: new messages are added to the existing list

### 8.5 Checkpointers & Persistence
```python
from langgraph.checkpoint.memory import MemorySaver

checkpointer = MemorySaver()
app = graph.compile(checkpointer=checkpointer)

# Use thread_id to isolate conversations per user
app.invoke(input, config={"configurable": {"thread_id": "user-123"}})
```

Options: `MemorySaver` (in-memory) → `SqliteSaver` → `PostgresSaver` (production).

### 8.6 Human-in-the-Loop
```python
# Pause before a sensitive node
app = graph.compile(interrupt_before=["book_flight"], checkpointer=checkpointer)

# Resume after human review
app.invoke(None, config=...)
```

### 8.7 Multi-Agent Patterns
- **Supervisor** — a controller LLM delegates tasks to specialist worker agents
- **Hierarchical** — nested supervisors managing sub-teams
- **Swarm / Handoffs** — peer agents transfer control using the `Command` object

```python
from langgraph.types import Command
return Command(goto="writer_agent", update={"draft": result})
```

### 8.8 Streaming
```python
for chunk in app.stream(input, stream_mode="updates"):
    print(chunk)
```

| Mode | What is Streamed |
|------|-----------------|
| `values` | Full state after each node |
| `updates` | Only the state delta after each node |
| `messages` | LLM tokens in real time |

---

## 9. Quick Reference — Common Imports

```python
from langgraph.graph import StateGraph, END
from langgraph.graph.message import add_messages
from langgraph.prebuilt import ToolNode, tools_condition, create_react_agent
from langgraph.checkpoint.memory import MemorySaver
from langgraph.types import Command, interrupt
from typing import TypedDict, Annotated
```

---

## 10. Learning Roadmap — Basic to Advanced

### 🟢 Level 1 — Foundations

| # | Topic | What You Learn |
|---|-------|---------------|
| 1 | What is LangGraph & Why Use It | Graph vs. chain mental model, when to use LangGraph over LCEL |
| 2 | LangGraph vs LangChain | Differences, how they complement each other |
| 3 | Installation & Setup | `pip install langgraph`, environment setup, LangSmith tracing |
| 4 | StateGraph Basics | Creating a graph, adding nodes and edges, compiling and invoking |
| 5 | State & TypedDict | Defining state schema, how state flows through nodes |
| 6 | Nodes | Writing node functions, reading state, returning state updates |
| 7 | Edges & Entry Points | `add_edge()`, `set_entry_point()`, `END` sentinel |
| 8 | Your First Agent Graph | A simple ReAct-style agent: LLM node → Tool node → loop |

---

### 🟡 Level 2 — Core Concepts

| # | Topic | What You Learn |
|---|-------|---------------|
| 9  | Conditional Edges | `add_conditional_edges()`, routing functions, dynamic branching |
| 10 | Reducers & Annotated State | `operator.add`, `add_messages`, append vs. overwrite |
| 11 | `add_messages` Reducer | Managing chat history, `HumanMessage` / `AIMessage` in state |
| 12 | Pre-built ReAct Agent | `create_react_agent()`, tool binding, tool execution loop |
| 13 | Tool Calling in Graphs | `ToolNode`, `tools_condition`, binding tools to LLMs |
| 14 | Graph Compilation | `graph.compile()`, input/output schemas, `.invoke()` |
| 15 | Streaming Basics | `.stream()`, streaming modes: `values`, `updates`, `messages` |
| 16 | Async Execution | `ainvoke()`, `astream()`, async nodes for concurrent workloads |

---

### 🔵 Level 3 — Memory & Persistence

| # | Topic | What You Learn |
|---|-------|---------------|
| 17 | Thread-based Memory | `thread_id` in config, isolating conversations per user |
| 18 | MemorySaver | In-memory checkpointer, short-term memory within a session |
| 19 | SqliteSaver | Persistent memory across sessions using SQLite |
| 20 | PostgresSaver | Production-grade persistence with PostgreSQL |
| 21 | Cross-Thread Memory | Storing facts/preferences shared across all threads for a user |
| 22 | State Snapshots | Inspecting past states with `.get_state()`, `.get_state_history()` |
| 23 | Time Travel | Modifying past states and re-running with `update_state()` |

---

### 🟠 Level 4 — Human-in-the-Loop

| # | Topic | What You Learn |
|---|-------|---------------|
| 24 | Breakpoints | Pausing before/after a node with `interrupt_before`, `interrupt_after` |
| 25 | `interrupt()` Function | Pausing mid-node and collecting human input |
| 26 | Resuming Execution | Passing updated state to `.invoke()` to resume from a breakpoint |
| 27 | Approving / Editing Tool Calls | Letting humans review and modify LLM tool calls before execution |
| 28 | Dynamic Breakpoints | Conditionally setting breakpoints based on runtime state values |

---

### 🔴 Level 5 — Multi-Agent Systems

| # | Topic | What You Learn |
|---|-------|---------------|
| 29 | Subgraphs | Embedding one StateGraph as a node inside another graph |
| 30 | Communicating Between Graphs | Shared state keys, input/output mapping between parent and subgraph |
| 31 | Supervisor Pattern | A controller LLM routing tasks to specialized worker agents |
| 32 | Hierarchical Multi-Agent Teams | Supervisors managing sub-teams of worker agents |
| 33 | Agent Handoffs (Swarm) | Peer agents transferring control to each other using `Command` |
| 34 | `Command` Object | `Command(goto=..., update=...)` for dynamic routing and state updates |
| 35 | Network of Agents | Multiple agents collaborating without a central supervisor |

---

### 🟣 Level 6 — Advanced Patterns & Production

| # | Topic | What You Learn |
|---|-------|---------------|
| 36 | Map-Reduce | Fan out tasks in parallel, collect results with reducers |
| 37 | Parallel Node Execution | Run multiple nodes concurrently via graph topology |
| 38 | Custom Reducers | Write your own reducer functions for complex state merge logic |
| 39 | Pydantic State Models | State validation and type safety using Pydantic |
| 40 | Graph Configuration | Passing runtime config (model, temperature, user ID) via `RunnableConfig` |
| 41 | Recursion Limit | Setting `recursion_limit` to prevent infinite loops |
| 42 | Error Handling | Try/except in nodes, fallback edges, retry logic |
| 43 | Testing LangGraph Apps | Unit testing nodes, mocking LLMs, replaying state histories |
| 44 | LangGraph Studio | Visual graph editor, live state inspection, replay & fork |
| 45 | LangGraph Platform | Deploying to LangGraph Cloud, REST API, horizontal scaling |
| 46 | Authentication & Authorization | Securing graph APIs in production |
| 47 | LangSmith Integration | Tracing every node execution, debugging failures, evaluating outputs |

---

> **Learning Tip:** Follow the levels in order.
> Start with a simple `StateGraph` → add conditional edges → add a checkpointer →
> introduce human-in-the-loop → then scale to multi-agent patterns.
> Each level builds directly on the previous one.
