# Project TODO — DevOps ToDoList on AKS (C8)

Grading: /20 total — 15 pts technical (C8), 5 pts documentation, evaluated separately.
Documentation delivery deadline: **Friday 12:00** (see step 8 for the exact submission process).

Current state: repo has `frontend/` (Angular 15 + Material) and `backend/` (Express + Sequelize + MySQL)
sources only. Nothing else exists yet — no Dockerfiles, no `.github/workflows`, no `iac/`, no `k8s/`,
no `monitoring/`. Root `README.md` is still a stub.

---

## 1. Local run & validation
Foundation step, not graded directly, but everything after depends on trusting this works.

- [X] Stand up MySQL locally (Docker Hub image), create `todolist_db`, run `backend/scriptSQL.sql`
- [X] Fill `backend/.env` (`DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `DB_DIALECT=mysql`, `PORT`)
      — note `config/config.js` reads `DB_DIALECT` from env, not hardcoded
- [X] `npm install && npm run start` in backend, confirm `/api/docs` and `/api/tasks` work
- [X] `npm install && npm run start` in frontend, confirm it talks to the API
- [X] Run `npm test` in both — confirm the existing suites actually pass before wiring CI to them

## 2. Dockerize (2 pts)
- [X] `backend/Dockerfile` (node base image, install, expose `PORT`, run `server.js`)
- [X] `frontend/Dockerfile` — build Angular (`ng build`) then serve static output via nginx
- [X] Build both locally, run with a local MySQL container, confirm the containerized app works
      end-to-end before touching Kubernetes

## 3. Push images to a registry
- [X] Create DockerHub (or GHCR) repos, tag and push both images manually once to confirm
      access/credentials work — CI will automate this in step 5

## 4. Terraform (`iac/`) (2 pts)
- [X] `main.tf`, `variables.tf`, `outputs.tf` provisioning an AKS cluster + supporting resources
      (resource group, ACR if using GHCR alternative, etc.)
- [X] **Every resource must be tagged `user = <myuid>`** — explicit grading requirement, easy to
      miss on a couple of resources
- [X] `iac/README.md` documenting `terraform init` / `plan` / `apply`

## 5. CI/CD pipeline (`.github/workflows/ci-cd.yml`) (4 pts — heaviest single axis)
- [X] Run backend + frontend unit tests
- [X] Build + push Docker images (only reachable if tests pass — gate this explicitly, not just
      via job order)
- [X] Deploy to AKS only if tests are 100% green — matrix job (Corentin/Nicolas/Mael), each own
      GitHub Environment + own cluster, OIDC via per-person Managed Identity (no stored secrets)
- [X] Deploy step updates the k8s manifests' image tag (sed → commit SHA) before `kubectl apply`
- [ ] Corentin's deploy confirmed green end-to-end (tests → images → k8s → monitoring). Nicolas's
      and Mael's `deploy` jobs still failing on the Azure OIDC login step (AADSTS700211/700213 —
      federated identity credential not syncing to the AAD backend despite matching config;
      delete+recreate attempted, still investigating). Both deployed manually via `kubectl apply`
      in the meantime so their apps are live regardless of the CI issue.

## 6. Kubernetes manifests (`k8s/`) (4 pts)
- [X] `00-namespace.yaml`, `01-database.yaml` (mysql Secret+PVC+Deployment+Service),
      `02-backend.yaml`, `03-frontend.yaml`, `04-ingress.yaml`
- [X] Secrets/ConfigMaps for DB credentials (`mysql-credentials`) — backend env vars sourced from
      it directly, no hardcoded `.env` values in images
- [X] Ingress (nginx, `ingress-nginx` via Helm) — path-based routing `/api` → backend, `/` → frontend
- [X] MySQL persistence via PVC (5Gi, AKS default StorageClass / Azure Disk)
- [X] Verified working end-to-end on Corentin's cluster: pods healthy, write path confirmed through
      the public Ingress IP (including proper UTF-8/accented data)

## 7. Monitoring (`monitoring/`)
Implicitly required, feeds documentation score.

- [X] Prometheus + Grafana (`kube-prometheus-stack` via Helm) — now installed automatically by the
      CI `deploy` job, not just manually
- [ ] At least one working dashboard; screenshot/export it into `monitoring/` (dir doesn't exist yet)
- [ ] Custom metrics: `/metrics` endpoint (`prom-client`) coded + tested in backend, but no
      `ServiceMonitor` wired up yet to actually scrape it, and no dashboard built around it

## 8. Documentation (5 pts, separate from technical /15)
- [ ] Root `README.md`: architecture, tech choices, CI/CD flow, AKS config, Terraform infra,
      monitoring, difficulties encountered
- [ ] Delivery (separate step per person, don't lose track of this):
  1. Copy README → `prenomnom.md`
  2. Clone `https://github.com/ENI-Projet-DevOps/projet_documentation_evaluation`
  3. Branch named `prenomnombranche`
  4. Drop the file in `/docs`
  5. PR to `main`
  6. Workflow runs automatically after PR validation; score lands in `/scores` after
     formateur review
  - **Due Friday 12:00.**

## 9. Presentation prep (group, 10 min)
Each teammate must be able to speak to manipulations they personally did — individual grading
component inside a group deliverable.

- [ ] Slides: project/context (2m) → architecture diagram + tech specs (2m) → approach/tools (2m)
      → key YAML/scripts + justified choices (3m) → retro/difficulties (1m)

---

## Reference docs
- `consignes/Consignes_et_attendus.md` — full instructions
- `consignes/Notation.md` — grading rubric
- `backend/README.MD` — backend env vars, DB setup, endpoints
