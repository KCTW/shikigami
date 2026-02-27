# 式神 Shikigami — Summon Your Agent Scrum Team

> A Scrum-driven governance framework for AI agent collaboration

An open-source framework that makes AI agents collaborate like a real Scrum team. 6 functional roles, each with clear responsibilities. Day-to-day development runs autonomously — humans only set direction and review.

Like an Onmyoji summoning Shikigami — you are the Maker, they are your shadow team.

---

## Why You Need This

You're building alone, but you need:
- **PO** to clarify requirements and prioritize
- **Architect** to make tech decisions and write ADRs
- **QA** to review code and write tests
- **SRE** to handle deployment and monitoring
- **SecOps** to run security audits
- **Stakeholder** to break deadlocks when the team is stuck

More importantly, they **review each other** — SRE reviews Architect's ADRs, QA reviews the main agent's code, SecOps reviews external input handling. Not 6 independent assistants, but a governance network of checks and balances.

Shikigami defines these 6 roles as Claude Code sub-agents, triggered automatically by conditions.

---

## Use Cases

### 1. Building a New Product from Scratch
Have an idea but no team? AI team runs Discovery → Backlog → Sprint, delivering demo-ready results every week.

### 2. Inheriting a Legacy Codebase
Inherited a system with no docs and no tests? Architect maps the architecture, QA adds tests, SRE sets up monitoring, SecOps runs scans — Sprint by Sprint, paying down tech debt.

### 3. Solo Company / Side Project
Want engineering discipline without the headcount. The AI team runs ceremonies, all decisions are recorded in ADRs, fully traceable at any time.

### 4. Teaching & Research
Demonstrate AI agents collaborating on real software engineering. Each role is grounded in industry standards (ISTQB, OWASP, Google SRE Book, RICE).

---

## Quick Start

### 1. Copy the Framework

```bash
# Copy role definitions and process docs
cp -r docs/team/ your-project/docs/team/

# Copy Claude Code sub-agent prompts
cp -r .claude/agents/ your-project/.claude/agents/

# Copy templates
cp -r templates/ your-project/docs/
```

### 2. Customize

- Copy `CLAUDE.md.template` to your project root, rename to `CLAUDE.md`, fill in project info
- Edit `## Project-Specific Rules` in `.claude/agents/*.md` with your tech stack, file paths, and business rules
- Adjust `docs/team/RACI.md` decision authority as needed

### 3. Product Discovery

Tell Claude your product vision, let PO run Discovery:

```
You: "I want to build xxx, target users are xxx"
 ↓
PO: Divergent discussion → drafts ROADMAP.md + PRODUCT_BACKLOG.md
 ↓
You: Review → confirm direction or adjust
 ↓
Architect: Identifies Stories needing tech decisions → drafts ADRs
 ↓
You: Review → approve
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
Sprint Review (acceptance + retrospective → update Retrospective_Log)
 ↓
Next Planning cycle
```

Each Sprint:
- **Planning**: PO selects Stories from Backlog; Stories need ADR (reviewed by SRE) before entering Sprint
- **Design**: Architect produces SDD for each Story; main agent follows SDD
- **Execution**: SDD → write tests → implement (TDD); QA reviews code, SecOps reviews security
- **Review**: Verify against DoD, record lessons in Retrospective Log
- See [scrum_process.md](docs/team/scrum_process.md) for full details

---

## Framework Architecture

```
docs/team/
├── scrum_process.md       # Full process: Discovery → Sprint → Role Triggers → DoD
├── RACI.md                # Decision matrix: who's responsible, who decides, who's informed
└── roles/                 # 6 role definitions (with industry standard references)
    ├── product-owner.md
    ├── architect.md
    ├── qa-engineer.md
    ├── sre-engineer.md
    ├── security-engineer.md
    └── stakeholder.md

.claude/agents/            # Claude Code sub-agent prompts
├── po.md
├── architect.md
├── qa.md
├── sre.md
├── secops.md
└── stakeholder.md

templates/                 # Ready-to-use templates
├── PROJECT_BOARD.md
├── PRODUCT_BACKLOG.md
├── ROADMAP.md
└── sprint_template.md
```

### Two-Layer Architecture

| Layer | Location | Purpose |
|---|---|---|
| Layer 1 (Tool-agnostic) | `docs/team/` | Role definitions, process, RACI — works with any tool |
| Layer 2 (Claude Code) | `.claude/agents/` | Sub-agent prompts — bound to Claude Code execution |

---

## Core Design Principles

1. **Autonomy First** — Team self-manages; Stakeholder only handles strategic pivots and escalation deadlocks
2. **Event-Driven** — Roles activate on trigger conditions, not every task summons all 6
3. **Docs as Governance** — All decisions leave a trail (ADR, SDD, Retro Log), no verbal consensus
4. **Test First** — SDD → write tests → implement (TDD); no design doc = don't start, no tests = not done
5. **Standard Terminology** — Keeps Scrum standard names so humans can take over without relearning
6. **Pragmatic Simplicity** — Every ceremony includes practical execution notes, readable by both AI and humans

---

## Real-World Example

This framework was extracted from the [seven-bala](https://github.com/KCTW/seven-bala) project — a UCP-driven smart coffee pickup service. That project used this framework from v1.0 MVP through v1.3, across 6 Sprints and 12 User Stories, fully developed by an autonomous AI team.

---

## Tips & Best Practices

From [Anthropic's internal field report](https://www.anthropic.com/engineering/claude-code-best-practices) and the seven-bala project experience.

### CLAUDE.md Is the Soul

The framework's effectiveness depends on how detailed your `CLAUDE.md` is. Include:
- Startup checklist (files to read at start of every conversation)
- Development red lines (rules that must never be broken)
- Project-specific business rules and terminology
- File path quick reference

### The Slot Machine Method

Don't try to fix unsatisfactory results — instead:
```
git commit (save) → let Claude run → keep if good, git revert if not
```
Frequent commits are your save points. Starting over is faster than patching.

### One Step at a Time

Break large tasks into small, verifiable steps. Align with Sprint thinking:
- Discovery phase: no code, only produce documents
- Finish one Story, tests passing, before starting the next
- Avoid changing multiple unrelated things at once

### Screenshots Are the Best Bug Reports

For frontend issues, skip the text description — just paste a screenshot. Claude can see and understand UI problems, much faster than describing "the button is in the wrong place."

### Plan Before You Build

For important features, discuss with PO / Architect in conversation first, then start coding. Maps to the framework flow:
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
| You (human) | Onmyoji | Set direction, review |
| Main agent | The core | Day-to-day development, coding, running tests |
| 6 sub-agents | Shikigami | Summoned only when specialized judgment is needed |

This is by design:
- **The main agent can already code** — creating a Developer sub-agent would just delegate to a clone, pointless
- **The 6 roles provide "perspective switching"** — same LLM with different system prompts offers viewpoints the main agent wouldn't normally consider
- **No frontend/backend split** — AI agents don't have human skill specialization limits; splitting actually increases coordination overhead

> Shikigami is not a full development team framework — it's a **governance guardian for makers**.
> The main agent handles all development; the Shikigami ensure quality, security, architecture, and requirements stay on track.

</details>

<details>
<summary><b>Can I add custom roles?</b></summary>
<br>

Yes. Add a role definition in `docs/team/roles/`, then add a corresponding sub-agent prompt in `.claude/agents/`. The framework doesn't limit the number of roles.

</details>

<details>
<summary><b>AI writing and reviewing its own code — does that work?</b></summary>
<br>

It works, with limits. The QA sub-agent uses a different system prompt to switch perspective (focused on finding bugs, security vulnerabilities, test coverage), catching blind spots from the main agent's development. It's essentially **multi-angle self-review from the same LLM** — better than no review, but not the same as independent human review.

The pragmatic approach:
- **Day-to-day**: QA sub-agent self-review + automated tests hold the baseline
- **Key milestones**: Humans review results and PRs at Sprint Review, no need to read every line
- **Bottom line**: Tests pass + QA finds no major issues = safe to merge; humans review later when available

> The premise of this framework: humans don't have time to review everything — that's why you need Shikigami.

</details>

<details>
<summary><b>Can I use this without Claude Code?</b></summary>
<br>

Layer 1 (`docs/team/`) is tool-agnostic — role definitions, RACI, and processes can be applied to any AI collaboration tool. Layer 2 (`.claude/agents/`) is Claude Code-specific; switching tools requires rewriting this layer.

</details>

---

## License

MIT
