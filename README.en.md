# Shikigami — Your AI Engineering Team

![Version](https://img.shields.io/badge/Version-0.3.0-success)
![Claude Code](https://img.shields.io/badge/Claude_Code-Compatible-blue)
![Roles](https://img.shields.io/badge/Roles-6_AI_Teammates-purple)
![License](https://img.shields.io/badge/License-MIT-green)

> Let Claude Code do more than write code — it also makes architecture decisions, reviews code, and guards security.

You're building alone. No one reviews your code, architecture decisions are gut calls, and security issues don't surface until production.

Shikigami gives you 6 AI teammates, each with a specialty, and they **review each other's work** — not 6 chatbots answering questions independently, but a disciplined engineering team.

---

## What It Does

You develop normally in Claude Code. Shikigami automatically activates the right role in the background:

| What happens | Who shows up | What they do |
|---|---|---|
| You want to build a new feature | **PO** | Clarifies requirements, prioritizes backlog |
| You need a tech decision | **Architect** | Writes ADRs (Architecture Decision Records) with options and rationale |
| Code is written | **QA** | Reviews automatically — finds bugs, checks test coverage, challenges architecture decisions |
| Time to deploy | **SRE** | Checks deployment config, sets up monitoring |
| External input handling | **SecOps** | Scans for security vulnerabilities (OWASP Top 10) |
| Team disagreement | **Stakeholder** | Final arbitration, breaks deadlocks |

**The key: they review each other.** SRE reviews Architect's ADRs, QA reviews your code, SecOps reviews external input. Not 6 standalone helpers — a governance network of checks and balances.

---

## Real-World Results

This framework has been validated in two projects:

**[seven-bala](https://github.com/KCTW/seven-bala)** (origin) — A smart coffee pickup service. From MVP to v1.3, 6 Sprints, 12 User Stories, fully developed by an autonomous AI team.

**[Onmyodo](https://github.com/KCTW/onmyodo)** (validation) — An AI Scrum team SaaS platform. 2 Sprints in POC phase, validated multi-role orchestration (PO → Architect → QA relay), 5/5 test pass rate at 100%. Also contributed improvements back to the framework (Retro verification, TDD exemption, Decision Challenge).

Combined artifacts:
- 15+ Architecture Decision Records (ADRs) — every tech choice documented, not left to memory
- Full test coverage — QA gatekeeps quality, no tests = not done
- Sprint Retrospective logs — every mistake recorded, never repeated
- **Decision Challenge** — QA doubles as Devil's Advocate, challenging Architect's key decisions

---

## Use Cases

1. **Building a new product from scratch** — Have an idea but no team? AI team runs Discovery → Sprint, delivering demo-ready results every week
2. **Inheriting a legacy codebase** — Architect maps the architecture, QA adds tests, SRE sets up monitoring — Sprint by Sprint, paying down tech debt
3. **Solo company / side project** — Want engineering discipline without the headcount, all decisions recorded and fully traceable
4. **Teaching & research** — Demonstrate AI agents collaborating on real software engineering, each role grounded in industry standards

---

## Quick Start

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed (Anthropic's official CLI)
- A Git repo for your project

### 1. Copy the Framework

```bash
# Copy role definitions and process docs
cp -r docs/team/ your-project/docs/team/

# Copy Claude Code sub-agent prompts
cp -r .claude/agents/ your-project/.claude/agents/

# Copy templates
cp -r templates/ your-project/templates/

# Copy automation scripts
cp -r scripts/ your-project/scripts/
```

### 2. Customize

- Copy `CLAUDE.md.template` to your project root, rename to `CLAUDE.md`, fill in project info
- Edit `## Project-Specific Rules` in `.claude/agents/*.md` with your tech stack and business rules
- Adjust `docs/team/RACI.md` decision authority as needed

### 3. Start Using It

Tell Claude what you want to build. The right roles activate automatically:

```
You: "I want to build xxx, target users are xxx"
 ↓
PO: Divergent exploration → produces DISCOVERY.md (iterates with you)
 ↓
You + PO: Conversational iteration → gradually converge on direction
 ↓
Direction confirmed → produces ROADMAP.md + PRODUCT_BACKLOG.md
 ↓
Architect: Identifies Stories needing tech decisions → drafts ADRs
 ↓
You: Review → approve
 ↓
Discovery Retro: Record lessons learned → update Retrospective_Log
```

### 4. Run Sprints

```
Sprint Planning (select Stories)
 ↓
Architect produces SDD (Software Design Document)
 ↓
Main agent writes tests → implements (TDD)
 ↓
QA / SRE / SecOps review as needed
 ↓
Sprint Review (acceptance)
 ↓
Sprint Retro → record lessons
 ↓
Next Planning cycle
```

See [scrum_process.md](docs/team/scrum_process.md) for full details.

---

## Framework Architecture

```
docs/team/                     # Role definitions & process (tool-agnostic)
├── scrum_process.md           # Full process: Discovery → Sprint → DoD
├── RACI.md                    # Decision matrix
└── roles/                     # 6 role definitions (with industry standards)
    ├── product-owner.md
    ├── architect.md
    ├── qa-engineer.md
    ├── sre-engineer.md
    ├── security-engineer.md
    └── stakeholder.md

.claude/agents/                # Claude Code sub-agent prompts
├── po.md
├── architect.md
├── qa.md
├── sre.md
├── secops.md
└── stakeholder.md

templates/                     # Ready-to-use templates
├── PLAYBOOK.md               # Tactical manual (red lines, workflow, team rules)
├── PROJECT_BOARD.md
├── PRODUCT_BACKLOG.md
├── ROADMAP.md
└── sprint_template.md

scripts/                       # Automation scripts
├── install_hooks.sh           # Git hooks installer
├── validate_commit.sh         # Pre-commit quality gate
└── preflight_check.sh         # Environment validation (pre-Agent)
```

**Two-layer design**: Layer 1 (`docs/team/`) is tool-agnostic — switch to any AI tool and it still works. Layer 2 (`.claude/agents/`) is Claude Code-specific.

---

## Design Principles

1. **Autonomy first** — The team solves problems on its own; humans only set direction
2. **Event-driven** — Roles activate on trigger conditions, not every task summons all 6
3. **Docs as governance** — All decisions documented (ADR, SDD), no verbal consensus
4. **Test first** — No design doc = don't start; no tests = not done
5. **Standard terminology** — Uses Scrum standard names so humans can take over without relearning
6. **Pragmatic simplicity** — Every process includes practical execution notes, readable by both AI and humans

---

## Tips & Best Practices

From [Anthropic's field report](https://www.anthropic.com/engineering/claude-code-best-practices) and the seven-bala project experience.

### CLAUDE.md Is the Soul

The framework's effectiveness depends on how detailed your `CLAUDE.md` is. Include:
- Startup checklist (files to read at start of every conversation)
- Development red lines (rules that must never be broken)
- Project-specific business rules and terminology
- File path quick reference

### The Slot Machine Method

Don't try to fix unsatisfactory results:
```
git commit (save) → let Claude run → keep if good, git revert if not
```
Frequent commits are your save points. Starting over is faster than patching.

### One Step at a Time

- Discovery phase: no code, only produce documents
- Finish one Story, tests passing, before starting the next
- Avoid changing multiple unrelated things at once

### Screenshots Are the Best Bug Reports

For frontend issues, just paste a screenshot. Claude can see and understand UI problems.

### Plan Before You Build

For important features, discuss with PO / Architect first, then start coding:
```
Discovery (think it through) → ADR (tech decisions) → SDD (design) → TDD (implement)
```

---

## FAQ

<details>
<summary><b>No frontend/backend engineers? Who writes the code?</b></summary>
<br>

**The main agent is the developer.** All 6 roles are governance roles — they don't write code.

| Role | Identity | What They Do |
|---|---|---|
| You (human) | The boss | Set direction, review |
| Main agent | Developer | Day-to-day development, coding, running tests |
| 6 sub-agents | Shikigami | Summoned only when specialized judgment is needed |

The main agent can already code. The 6 roles provide **perspective switching** — same LLM with different prompts, offering viewpoints you wouldn't normally consider.

> Shikigami is not a development team framework — it's a **governance guardian for makers**.

</details>

<details>
<summary><b>Can I add custom roles?</b></summary>
<br>

Yes. Add a role definition in `docs/team/roles/`, then add a corresponding prompt in `.claude/agents/`.

</details>

<details>
<summary><b>AI writing and reviewing its own code — does that work?</b></summary>
<br>

It works, with limits. QA uses a different prompt to switch perspective (focused on finding bugs, security vulnerabilities, test coverage), catching blind spots from development. It's **multi-angle self-review from the same LLM** — better than no review, but not the same as independent human review.

The pragmatic approach:
- **Day-to-day**: QA self-review + automated tests hold the baseline
- **Key milestones**: Humans review at Sprint Review
- **Bottom line**: Tests pass + QA finds no major issues = safe to merge

> The premise: humans don't have time to review everything — that's why you need Shikigami.

</details>

<details>
<summary><b>Can I use this without Claude Code?</b></summary>
<br>

Layer 1 (`docs/team/`) is tool-agnostic — works with any AI collaboration tool. Layer 2 (`.claude/agents/`) is Claude Code-specific; switching tools requires rewriting this layer.

</details>

---

## License

MIT
