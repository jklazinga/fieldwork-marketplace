# Fieldwork — Notes & Decisions

## Things to keep in mind

### Structural
- Superpowers uses YAML frontmatter in SKILL.md files with `name` and `description`. The description is what the agent reads to decide whether to trigger the skill. This is the key mechanism — get the trigger descriptions right.
- Superpowers uses HARD-GATE blocks to prevent agents from skipping steps. Use these for spec approval and GTM approval gates.
- Output directory structure matters — downstream skills need to know where to find upstream outputs. Use consistent paths and document them in each SKILL.md.

### PM outputs vs engineering outputs
- Engineering outputs (spec, plan, tasks) are grounded in the codebase — file paths, architecture, tech stack.
- PM outputs (GTM, marketing, launch brief) are grounded in the opportunity — user personas, value props, channels, timing.
- Both need to reference each other. The GTM plan should link to the spec. The spec should reference the opportunity.
- Don't make PM outputs generic. They should reference actual product details from the codebase and context files.

### MCP integrations
- Keep MCP integrations optional. Skills should degrade gracefully if an MCP isn't configured.
- Priority MCPs: GitHub (task scaffolding), Linear (issue creation), Slack (launch comms), Confluence (spec publishing).
- Each skill should check for MCP availability and offer alternatives (e.g. write to file if GitHub MCP not present).

### Naming
- "Fieldwork" is a placeholder. Needs to be:
  - PM-flavoured (fieldwork = research, discovery, being close to the customer)
  - Not already taken as a GitHub repo / npm package
- Other candidates: Groundwork, Waypoint, Compass, Cartographer, Surveyor

### Distribution
- Superpowers uses a plugin marketplace model (`/plugin marketplace add obra/superpowers-marketplace`). This is the right model for Claude Code.
- For v1, git clone is fine. Marketplace submission comes after skills are stable.
- Skills should be self-contained — no external dependencies beyond optional MCPs.

### Relationship to Skip the Sprint
- Fieldwork is a natural companion product / case study for Skip the Sprint.
- The guide can walk through building Fieldwork as a worked example.
- Consider whether Fieldwork is a free open-source tool or a paid product bundled with Skip the Sprint.


### Relationship to Superpowers
- Superpowers starts at approved design. Fieldwork hands off to it at the end of `/write-plan`.
- The `write-plan` skill output should be compatible with Superpowers' `executing-plans` skill.
- Consider a `/handoff-to-superpowers` skill that formats the plan correctly.

---

## Decisions

**DECISION [2026-03-05]:** Scaffold Fieldwork in /home/ubuntu/vault/fieldwork/ as a new project. Working name "Fieldwork". PM-native skills framework for Claude Code/Cursor. Fills the PM gap that engineering-focused frameworks leave behind. Extends into GTM and marketing outputs.

**DECISION [2026-03-05]:** Split context into three files: project-context.md (codebase/tech), product-context.md (OKRs/personas/positioning/channels), constraints.md (team/deadlines/tech debt). All skills load only what they need.

**DECISION [2026-03-05]:** discover skill produces two outputs: opportunity.md AND assumptions.md (2x2 importance/evidence map across desirability/viability/feasibility/usability). write-spec loads assumptions.md directly — does not re-derive assumptions.

**DECISION [2026-03-05]:** Status vocabulary standardised across all output documents: draft | approved | shipped. Skills check frontmatter status before proceeding — do not rely on user's word.

**DECISION [2026-03-05]:** review-spec applies fixes directly to spec.md (not a separate file). Maintains a resolution log in spec-review.md. Marks spec as approved only when all BLOCKERs resolved.

**DECISION [2026-03-05]:** write-plan output is Superpowers-compatible. After plan is written, agent checks if Superpowers is installed and offers to invoke superpowers:executing-plans directly. If not installed, offers scaffold-tasks.

**DECISION [2026-03-05]:** scaffold-tasks checks MCP availability from project-context.md BEFORE attempting any MCP calls. Tells user upfront which system it will use. Falls back to local tasks.md with explicit message.

**DECISION [2026-03-05]:** write-gtm derives positioning from product-context.md personas and channels before asking any questions. Only asks questions that can't be answered from context files.

**DECISION [2026-03-05]:** write-launch-brief derives pre-launch checklist from spec acceptance criteria directly. Does not create a separate checklist. Warns explicitly if marketing-brief.md is missing — does not silently skip comms section.

**DECISION [2026-03-05]:** close-feature updates frontmatter status to `shipped` in spec.md, gtm-plan.md, and launch-brief.md. Appends learnings to project-context.md and constraints.md — does not rewrite.

**DECISION [2026-03-05]:** Added writing-skills skill — guide for creating custom skills. Covers trigger description rules, HARD-GATE usage, output file conventions, status vocabulary, chaining rules, and testing methodology.

**DECISION [2026-03-05]:** Added CLAUDE.md template to repo root — exact text for users to add to their project's CLAUDE.md. Covers skill priority (Fieldwork before Superpowers), context file loading, output directory, status values, Superpowers compatibility.

**DECISION [2026-03-05]:** Added fieldwork.config.json — project name, MCP availability flags, integration toggle for Superpowers.

**DECISION [2026-03-05]:** Added complete worked example in example/ — Acme Anvils (B2B SaaS for blacksmiths). Covers all skill outputs from opportunity through retro. Reference for what good outputs look like.

---

## Open questions

1. Name — "Fieldwork" vs alternatives (Groundwork, Waypoint, Compass)
2. Is this open source (MIT) or a paid product?
3. Should it include a discovery layer, or strictly start post-discovery?
4. How opinionated should the GTM/marketing outputs be? Templates vs. fully generated?
5. Should `/write-plan` produce Superpowers-compatible output, or its own format?
6. Phase 1 scope: which skills ship in v1?
