---
description: "Set up or modify CI/CD pipelines, infrastructure-as-code, deployments, or monitoring."
agent: devops
argument-hint: "What to deploy or configure (e.g., 'GitHub Actions CI pipeline' or 'Docker deployment for staging')"
---

The user wants to deploy or configure infrastructure: **$INPUT**

## Mode Detection

- If the input mentions **CI/CD, pipeline, actions, workflow** → **CI/CD Mode** below
- If the input mentions **deploy, release, environment** → **Deployment Mode** below
- If the input mentions **monitor, alert, logging, observability** → **Monitoring Mode** below
- Otherwise → **Infrastructure Mode** below

## Infrastructure Mode

1. **Review architecture** — Read `docs/`, `architecture.md`, `decisions.md` for infrastructure context
2. **Scan existing infra** — Check for existing IaC configs, Dockerfiles, pipeline files
3. **Implement** — Write infrastructure code following project conventions:
   - High-level constructs over low-level primitives
   - `${env}-${project}-${resource}` naming convention
   - Secrets in a secrets manager — never hardcoded
   - Least-privilege permissions
   - Separate stateful from stateless resources
4. **Test** — Run assertion tests or validate configs
5. **Document** — Update `docs/` or `architecture.md` with infrastructure changes

## CI/CD Mode

1. **Assess current state** — Scan for existing pipeline configs
2. **Design pipeline** — Build, test, lint, security scan, deploy stages
3. **Implement** — Write pipeline configs following project conventions
4. **Verify** — Dry-run or test the pipeline
5. **Document** — Note pipeline structure in `docs/`

## Deployment Mode

1. **Review architecture** — Read deployment targets from `docs/` and `decisions.md`
2. **Configure environments** — Dev, staging, production with proper separation
3. **Set up secrets** — Configure secret management for each environment
4. **Implement deployment** — Write deployment scripts or IaC configs
5. **Verify** — Test deployment to a non-production environment
6. **Document** — Update deployment docs

## Monitoring Mode

1. **Identify key metrics** — Based on requirements and architecture
2. **Configure logging** — Structured logging, log aggregation
3. **Set up alerts** — Critical path monitoring, error rate thresholds
4. **Dashboard** — Key health indicators visible at a glance

## Scope Guard

Infrastructure and operations only. Do not write application code (delegate to `@engineer`) or make architecture decisions (delegate to `@architect`). Record infrastructure decisions in `decisions.md`.

## Done When

Infrastructure is deployed/configured, tested, and documented. Record any decisions in `decisions.md`.
