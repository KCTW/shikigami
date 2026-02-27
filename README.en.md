# Shikigami — AI Agent Scrum Team Framework

> 7 AI teammates, each with a specialty, checking and balancing each other — giving your AI development tool a disciplined engineering team.

---

## Concept

You're building alone. No one reviews your code, architecture decisions are gut calls, and security issues don't surface until production.

Shikigami is a **plugin framework** that injects 7 specialized roles (Shikigami) into your AI development tool. They don't just answer questions independently — they form a **governance network of checks and balances**: SRE evaluates Architect's ADRs for operational feasibility, QA reviews your code and challenges architecture decisions, SecOps audits external input handling.

---

## Installation

### Claude Code

```bash
claude plugins add shikigami
# Or specify GitHub source
claude plugins add github:KCTW/shikigami
```

### Cursor

Search for `shikigami` in Cursor's plugin settings and click install.

### Codex

Refer to `.codex/INSTALL.md`

### OpenCode

Refer to `.opencode/INSTALL.md`

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

## Available Skills (10)

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

---

## Slash Commands

| Command | Description |
|---|---|
| `/sprint` | Start Sprint planning |
| `/standup` | Daily standup meeting |
| `/review` | Sprint review |

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

---

## Relationship with Superpowers

Shikigami is an independent plugin that can coexist with Superpowers. Shikigami focuses on **AI Agent Scrum Team role orchestration and process governance**, while Superpowers focuses on enhancing general capabilities of AI development tools. They do not conflict with each other.

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

## License

MIT
