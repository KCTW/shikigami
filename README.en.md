# Shikigami — AI Agent Scrum Team Framework

> 7 AI teammates, each with a specialty, checking and balancing each other — giving your AI development tool a disciplined engineering team.

---

## Concept

You're building alone. No one reviews your code, architecture decisions are gut calls, and security issues don't surface until production.

Shikigami is a **plugin framework** that injects 7 specialized roles (Shikigami) into your AI development tool. They don't just answer questions independently — they form a **governance network of checks and balances**: SRE evaluates Architect's ADRs for operational feasibility, QA reviews your code and challenges architecture decisions, SecOps audits external input handling.

---

## Installation

### Claude Code

Run the following commands inside the Claude Code interactive interface:

```
# 1. Add marketplace (first time only)
/plugin marketplace add KCTW/shikigami

# 2. Install plugin (either way)
/plugin install shikigami          # Command install
/plugin                            # Or open UI → Discover → select shikigami
```

> **Note:** All commands are entered in the Claude Code interactive interface (not the terminal shell). A new session will auto-activate after installation.

---

## 7 Roles

| Role | Responsibility | Trigger |
|---|---|---|
| **Product Owner** | Requirements definition, prioritization, backlog management | Requirements discussion, sprint planning, feature prioritization |
| **Architect** | Architecture decisions, SDD authoring, technology selection | Tech selection, system design, performance bottleneck analysis |
| **Developer** | Feature implementation, TDD development, bug fixes | Sprint execution, coding, technical implementation |
| **QA Engineer** | Code review, test strategy, quality gate | Feature completion, PR review, quality metrics |
| **Security Engineer** | Security scanning, vulnerability assessment, OWASP checks | External input handling, API endpoints, config changes |
| **SRE Engineer** | Deployment checks, monitoring config, environment management | Deployment prep, version release, environment changes |
| **Stakeholder** | Final arbitration, breaking deadlocks | Escalation chain exhausted without resolution |

**The key: they check each other.** Not 7 standalone helpers — a disciplined engineering team.

---

## Available Skills (14)

| Skill | Description |
|---|---|
| **scrum-master** | Automatically orchestrates Agent Scrum Team role assignments and Sprint workflow |
| **sprint-planning** | Start a new Sprint, select Stories from Backlog, plan Sprint goals |
| **sprint-execution** | Execute Sprint Stories, implement features, work through Sprint Backlog |
| **sprint-review** | Conduct Sprint review and retrospective, evaluate Sprint outcomes |
| **backlog-management** | Manage new requirements, handle changes, groom Backlog, product discovery |
| **architecture-decision** | Technical decisions, architecture review, technology selection, ADR creation |
| **quality-gate** | Code review, feature acceptance, PR checks, quality metrics |
| **security-review** | External input handling, API security, config security, vulnerability assessment |
| **deployment-readiness** | Deployment preparation, version release, environment config, production readiness |
| **escalation** | Unresolvable team conflicts, major product pivots, escalation chain activation |
| **systematic-debugging** | Bug investigation, test failure analysis, systematic debugging workflow |
| **git-workflow** | Branch isolation, worktree management, merge/PR workflow after development |
| **parallel-dispatch** | Parallel subagent dispatching for 2+ independent tasks |
| **issue-management** | GitHub Issue management, auto-triage, commenting, and Issue-to-Backlog sync |

---

## Slash Commands

| Command | Description |
|---|---|
| `/sprint` | Start Sprint planning |
| `/standup` | Daily standup meeting |
| `/review` | Sprint review |

---

## How to Use (Semantic Commands)

No commands to memorize — **just say what you want to do** in natural language, and the Scrum Master will automatically dispatch the right roles and workflows.

### Requirements & Planning

| What you say | What Shikigami does |
|---|---|
| "I want to add a new feature..." | PO starts Product Discovery → requirement analysis → produces Backlog |
| "Start a new Sprint" | PO selects Stories → Architect estimates effort → QA confirms AC |
| "Change this requirement..." | PO runs Backlog Grooming → updates priorities |

### Development & Implementation

| What you say | What Shikigami does |
|---|---|
| "Implement this Story" | Developer follows TDD → QA dual-phase review |
| "How do I fix this bug?" | Systematic debugging → form hypothesis → verify fix |
| "Create a feature branch" | Creates Worktree isolation → baseline tests |
| "Done, ready to merge" | Push → create PR → trigger Quality Gate |

### Review & Decisions

| What you say | What Shikigami does |
|---|---|
| "Review this code" | QA code review → quality gate check |
| "Which architecture should we pick?" | Architect creates ADR → QA plays Devil's Advocate |
| "Ready to deploy" | SRE deployment readiness check → environment validation |

### Issue Management

| What you say | What Shikigami does |
|---|---|
| "Handle the GitHub Issues" | Lists open issues → classifies → applies labels |
| "Reply to issue #5" | PO drafts reply → QA reviews → publishes |
| "Convert issue #3 to a Story" | Reads issue → converts to User Story → writes to Backlog |
| "Close issue #7" | Comments with reason → confirms per project level → closes |

### Process Control

| What you say | What Shikigami does |
|---|---|
| "Sprint is done" | Sprint Review → Retrospective → records action items |
| "These two problems are unrelated" | Parallel dispatch — multiple Agents work simultaneously |
| "The team can't resolve this" | Escalates to Stakeholder for arbitration |

> **Tip:** You don't need to match the exact wording above. The Scrum Master analyzes your intent and routes to the right workflow. Just say what you need.

---

## Workflow Overview

```
Discovery → Sprint Planning → Sprint Execution → Sprint Review
```

1. **Discovery**: Discuss requirements with PO, produce ROADMAP and PRODUCT_BACKLOG
2. **Sprint Planning**: Select Stories, Architect produces SDD, QA performs Decision Challenge
3. **Sprint Execution**: Developer follows SDD for TDD development, QA/SRE/SecOps review as needed
4. **Sprint Review**: Accept deliverables, record lessons learned, update Retrospective Log

---

## Project Configuration

After installing the plugin, copy `templates/CLAUDE.md.template` to your project root and rename it to `CLAUDE.md`:

```bash
cp templates/CLAUDE.md.template ./CLAUDE.md
```

Customize the following for your project:
- Project name and tech stack
- Development red lines
- Documentation directory structure
- Quick start commands

### Project Level (Autonomy Strategy)

Set the project level in `CLAUDE.md` to control the AI team's autonomy:

```
shikigami.project_level: medium
```

| Level | Use Case | Behavior |
|-------|----------|----------|
| **low** | Personal projects, experiments | Full autonomy, all operations auto-execute |
| **medium** (default) | General development | Low-risk auto, high-risk auto after QA review |
| **high** | Critical products, public repos | Low-risk auto, high-risk requires human confirmation |

---

## Battle-Tested

This framework has been validated in the following projects:

**[seven-bala](https://github.com/KCTW/seven-bala)** (origin) — A smart coffee pickup service. From MVP to v1.3, 6 Sprints, 12 User Stories, fully developed by an autonomous AI team.

**[Onmyodo](https://github.com/KCTW/onmyodo)** (validation) — An AI Scrum team SaaS platform. 2 Sprints in POC phase, validated multi-role orchestration (PO → Architect → QA relay), 5/5 test pass rate at 100%. Also contributed improvements back to the framework itself.

Combined artifacts:
- 15+ Architecture Decision Records (ADRs)
- Full test coverage — QA gatekeeps quality, no tests = not done
- Sprint Retrospective logs — every mistake recorded, never repeated
- Decision Challenge — QA doubles as Devil's Advocate, challenging Architect's key decisions

---

## FAQ

### Does Shikigami conflict with Plan Mode?

**Yes.** Plan Mode is a built-in Claude Code system feature with higher priority than any plugin. When Plan Mode is active, Shikigami is "sealed" — the Scrum Master is loaded but cannot dispatch Subagents for write operations.

```
┌─────────────────────┐
│ Claude Code System   │  ← Plan Mode lives here (highest priority)
├─────────────────────┤
│ Plugin Layer         │  ← Shikigami lives here
├─────────────────────┤
│ Execution Layer      │  ← Actual work happens here
└─────────────────────┘
```

**Recommendation:** Pick one. If you want Shikigami's Scrum workflow, don't enter Plan Mode — just say what you want to do and let the Scrum Master orchestrate.

### How do I verify Shikigami is active?

After installation, start a new session and look for:
- `shikigami:` prefixed Skills in the system prompt (e.g., `shikigami:scrum-master`)
- Ask "Do you have shikigami superpowers?" — Claude will know if it's loaded
- During work, you'll see Subagent dispatches (e.g., `shikigami:developer`, `shikigami:qa-engineer`)

### What does Shikigami look like when it's working?

| Sign | Description |
|------|-------------|
| Skill invocation | You see `invoke shikigami:xxx` |
| Subagent dispatch | You see `subagent_type: shikigami:developer` etc. |
| Scrum language | Sprint Planning, TDD cycles, Quality Gate, DoD checks |
| Structured docs | Files appear in `docs/prd/`, `docs/adr/`, `docs/sprints/` |
| Role checks | Developer writes → QA reviews, Architect decides → QA challenges |

### Is project level `low` too risky?

`low` is designed for **personal projects and experiments**. All operations auto-execute without confirmation. For public repos with external users, use `medium` (QA reviews high-risk ops) or `high` (human confirmation required).

### Can I use only some features?

Yes. Shikigami doesn't force you through the full Scrum workflow. You can:
- Use only `systematic-debugging` for debugging
- Use only `quality-gate` for code review
- Use only `issue-management` for GitHub Issue management
- For everyday development, the Scrum Master auto-detects no role activation is needed and just helps directly

---

## License

MIT
