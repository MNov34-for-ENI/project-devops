# Project TODO — DevOps ToDoList on AKS (C8)

Grading: /20 total — 15 pts technical (C8), 5 pts documentation, evaluated separately.
Documentation delivery deadline: **Friday 12:00** (see step 8 for the exact submission process).

Current state: repo has `frontend/` (Angular 15 + Material) and `backend/` (Express + Sequelize + MySQL)
sources only. Nothing else exists yet — no Dockerfiles, no `.github/workflows`, no `iac/`, no `k8s/`,
no `monitoring/`. Root `README.md` is still a stub.

---

## 1. Local run & validation
Foundation step, not graded directly, but everything after depends on trusting this works.

- [ ] Stand up MySQL locally (Docker Hub image), create `todolist_db`, run `backend/scriptSQL.sql`
- [ ] Fill `backend/.env` (`DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `DB_DIALECT=mysql`, `PORT`)
      — note `config/config.js` reads `DB_DIALECT` from env, not hardcoded
- [ ] `npm install && npm run start` in backend, confirm `/api/docs` and `/api/tasks` work
- [ ] `npm install && npm run start` in frontend, confirm it talks to the API
- [ ] Run `npm test` in both — confirm the existing suites actually pass before wiring CI to them

## 2. Dockerize (2 pts)
- [ ] `backend/Dockerfile` (node base image, install, expose `PORT`, run `server.js`)
- [ ] `frontend/Dockerfile` — build Angular (`ng build`) then serve static output via nginx
- [ ] Build both locally, run with a local MySQL container, confirm the containerized app works
      end-to-end before touching Kubernetes

## 3. Push images to a registry
- [ ] Create DockerHub (or GHCR) repos, tag and push both images manually once to confirm
      access/credentials work — CI will automate this in step 5

## 4. Terraform (`iac/`) (2 pts)
- [ ] `main.tf`, `variables.tf`, `outputs.tf` provisioning an AKS cluster + supporting resources
      (resource group, ACR if using GHCR alternative, etc.)
- [ ] **Every resource must be tagged `user = <myuid>`** — explicit grading requirement, easy to
      miss on a couple of resources
- [ ] `iac/README.md` documenting `terraform init` / `plan` / `apply`

## 5. CI/CD pipeline (`.github/workflows/ci-cd.yml`) (4 pts — heaviest single axis)
- [ ] Run backend + frontend unit tests
- [ ] Build + push Docker images (only reachable if tests pass — gate this explicitly, not just
      via job order)
- [ ] Deploy to AKS only if tests are 100% green
- [ ] Deploy step should update the k8s manifests' image tag so a re-run produces a rolling
      update (feeds into axis 5)

## 6. Kubernetes manifests (`k8s/`) (4 pts)
- [ ] `frontend-deployment.yaml`, `backend-deployment.yaml`, `mysql-deployment.yaml` + matching
      Services
- [ ] Secrets/ConfigMaps for DB credentials and backend env vars (don't hardcode `.env` values
      into images)
- [ ] Ingress (NGINX or the newer AKS-managed API Gateway — pick one, document why)
- [ ] MySQL persistence via PVC (optional per consignes, but cheap points if time allows)
- [ ] Verify a rolling update actually works (bump image tag, `kubectl rollout status`) —
      axis 5, /1.5 pts, easy to skip by accident

## 7. Monitoring (`monitoring/`)
Implicitly required, feeds documentation score.

- [ ] Deploy Prometheus + Grafana (helm chart is fastest) into the cluster
- [ ] At least one working dashboard; screenshot/export it into `monitoring/`
- [ ] Bonus: custom metrics export from the backend

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
