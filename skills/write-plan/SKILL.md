---
name: write-plan
description: "Triggers after a spec is approved (status: approved) and the team is ready to begin implementation. Produces an implementation plan grounded in the spec and codebase. Output is Superpowers-compatible. Does NOT trigger if spec status is draft or missing — run write-spec and review-spec first."
---

# Write Plan

## Overview

Produce an implementation plan grounded in the approved spec and actual codebase. This is not a project plan — it is a sequenced list of engineering tasks with enough context for an AI agent or engineer to execute without asking questions.

**Announce at start:** "I'm using the Fieldwork write-plan skill to produce the implementation plan."

<HARD-GATE>
Do NOT write the plan if:
- spec.md status is not `approved` — check frontmatter, do not rely on the user's word
- context/project-context.md is missing — run onboard first

The plan is the handoff point to engineering. A plan built on a draft spec will cause rework.
</HARD-GATE>

## Pre-flight check

1. Load `outputs/specs/{feature-name}/spec.md` — confirm `status: approved`. If not, stop.
2. Load `outputs/opportunities/{feature-name}/opportunity.md` — for problem context.
3. Load `context/project-context.md` — for architecture, test setup, key files.
4. Load `context/constraints.md` — for tech debt and non-negotiables.
5. Check `fieldwork.config.json` for Superpowers integration flag.
6. Create directory `outputs/plans/{feature-name}/` if it does not exist.

## Checklist

### 1. Read the relevant codebase
Before writing any tasks, read the files listed in the spec's technical notes section. Confirm they exist. If a file path in the spec doesn't exist, flag it — do not write tasks that reference phantom files.

Also read:
- Test files for adjacent features (to understand test conventions)
- Any migration or schema files if data changes are involved
- Feature flag infrastructure if a flag is involved

### 2. Sequence the work
Break the spec into phases. Each phase should be independently shippable or testable. Typical sequence:
1. Data layer (schema, migrations, models)
2. Backend logic (services, APIs, business rules)
3. Frontend (components, state, routing)
4. Tests (unit, integration, e2e)
5. Feature flag / rollout configuration
6. Cleanup (remove scaffolding, update docs)

Not every feature needs all phases. Skip phases that don't apply. Say why.

### 3. Write tasks
Each task must be:
- **Atomic** — one engineer, one session, completable without waiting on another task
- **Grounded** — references real file paths from the codebase
- **Testable** — has a clear done condition
- **Ordered** — dependencies are explicit

### 4. Check Superpowers availability
Load `fieldwork.config.json`. If `integrations.superpowers.enabled: true`:
- Format the plan output to be Superpowers-compatible (see output format below)
- After saving, offer: "Superpowers is installed. Want me to invoke `superpowers:executing-plans` now?"

If Superpowers is not installed:
- Save the plan as-is
- Offer: "Want me to run `scaffold-tasks` to break this into tracked tasks?"

### 5. Get approval
Present a summary: number of phases, number of tasks, estimated complexity, top risk.
Ask: "Does this plan look right before I hand it off?"
On approval: update frontmatter status to `approved`.

## Output: outputs/plans/{feature-name}/plan.md

```markdown
---
feature: {feature-name}
status: draft | approved
date: YYYY-MM-DD
spec: outputs/specs/{feature-name}/spec.md
superpowers-compatible: true | false
---

# Implementation Plan: {Feature Name}

## Overview
[One paragraph: what we're building, why this sequence, top risk to watch]

## Phases

### Phase 1: [Name]
**Goal:** [What this phase achieves — why it's first]
**Done when:** [Specific, testable condition]

#### Tasks
- [ ] **[Task name]**
  - File(s): `exact/path/to/file`
  - What: [Specific change — not "update the file" but "add X method to Y class"]
  - Done when: [Testable condition]
  - Depends on: [Task name, or "nothing"]

- [ ] **[Task name]**
  - File(s): `exact/path/to/file`
  - What: [Specific change]
  - Done when: [Testable condition]
  - Depends on: [Task name]

### Phase 2: [Name]
**Goal:** [What this phase achieves]
**Done when:** [Specific, testable condition]

#### Tasks
- [ ] ...

## Risks
| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| [Risk from spec or codebase read] | High/Med/Low | High/Med/Low | [Specific mitigation] |

## Open questions
_Must be resolved before or during implementation — not after_
- [Question — owner]

## Superpowers handoff
_If Superpowers is installed, this section is used by `superpowers:executing-plans`_

```yaml
plan:
  feature: {feature-name}
  phases:
    - name: {phase-name}
      tasks:
        - id: {task-id}
          description: {task description}
          files: [{file-path}]
          done_when: {done condition}
          depends_on: [{task-id}]
```
```

## After write-plan

If Superpowers available:
"Plan saved to `outputs/plans/{feature-name}/plan.md`.
Superpowers is installed. Want me to invoke `superpowers:executing-plans` to begin execution?"

If Superpowers not available:
"Plan saved to `outputs/plans/{feature-name}/plan.md`.
Want me to run `scaffold-tasks` to create tracked issues in GitHub/Linear, or work from this file directly?"
