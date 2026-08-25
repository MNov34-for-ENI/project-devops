# project-devops
Groupe Maël Corentin B. et Nicolas

## 1) architecture de l’application
- `frontend/Dockerfile` : build multi-stage — `node:18-alpine` compile l'app Angular en mode production (`ng build`), puis l'artefact statique est servi par `nginx:alpine`

- `frontend/nginx.conf` : configuration nginx minimale avec fallback SPA (`try_files ... /index.html`) pour que le routing Angular fonctionne.

- L'URL de l'API backend (`apiUrl`) est injectée au moment du build CI dans `environment.prod.ts` avec la valeur `/api`, en s'appuyant sur l'Ingress AKS pour router `/api/*` vers le service backend (reverse proxy). 
> pas a reconstruire l'image pour changer d'environnement côté Ingress

### 1.5) Backend (Node/Express)

- `backend/Dockerfile` : image simple `node:18-alpine`, dépendances installées en mode production (`npm ci --omit=dev`), exécution via `node src/server.js`, port `3000` exposé.

- La configuration (connexion MySQL, port) reste entièrement pilotée par variables d'environnement (`DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `DB_DIALECT`, `PORT`), ce qui permettra de les injecter facilement via ConfigMap/Secret Kubernetes plus tard.

## 2) choix techniques
### 2.5) Validation locale

- Les deux images ont été testées sur une LXC Proxmox dédiée (Docker installé nativement dans le conteneur, nécessitant l'activation des features `nesting` et `keyctl`, plus un profil AppArmor `unconfined` au niveau de l'hôte Proxmox).

- Test end-to-end réalisé manuellement : conteneur MySQL + conteneur backend + conteneur frontend sur un même réseau Docker, avec exécution du script `scriptSQL.sql` et vérification que l'API répond correctement (`GET /api/tasks`).

## 3) démarche CI/CD

- Un pipeline GitHub Actions existait déjà mais était mal placé (`frontend/.github/workflows/`, non détecté par GitHub vu que j'ai merge les repo "frontend", "backend" et "consignes") et ciblait la branche `master` au lieu de `main`. (Je l'ai déplacé à la racine du dépôt (`.github/workflows/ci-cd.yml`) + corrigé (branche `main`, `working-directory: frontend`).)

- Ce pipeline exécute les tests unitaires Angular (`ng test --browsers ChromeHeadless`) puis construit le bundle de production. 

- Ajout d'un job `backend-test` au pipeline GitHub Actions (`.github/workflows/ci-cd.yml`), car absent (les consignes demandent l'exécution des tests des deux projets frontend + backend)

- Ce job démarre un service MySQL 8 éphémère (`services: mysql`) avec un health-check (`mysqladmin ping`) pour garantir que la base est prête avant le lancement des tests

- Les variables d'environnement (`DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `DB_DIALECT`, `PORT`) sont injectées pour correspondre à la configuration attendue par `src/config/db.config.js` (et le .env est partagé sur le repo)

- Deux tests exécutés : les tests unitaires du service (`task.service.test.js`) et les tests d'intégration des routes REST (`task.routes.test.js`, via Supertest). 

- Renamed : 
`test` vers `frontend-test`, 
`build` vers `frontend-build`
`frontend-build` dépend désormais à la fois de `frontend-test` **et** `backend-test`, 
Comme ça le build ne se déclenche que si l'intégralité des tests (frontend + backend) est au vert et pas à chaque push/test/buid
## 4) configuration AKS

- Manifests `k8s/` adaptés à partir d'un ancien projet de formation AKS (`k8s/webapp/` du cours Kubernetes), réutilisation par type de ressource :
  - `deployment.yaml` > template pour `frontend-deployment.yaml` et `backend-deployment.yaml` (`resources.requests/limits`, `readinessProbe`/`livenessProbe`, `envFrom.secretRef`)
  - `service.yaml` > template pour `frontend-service.yaml`, `backend-service.yaml`, `mysql-service.yaml` (`ClusterIP`)
  - `ingress.yaml` > template pour l'Ingress, mais avec deux règles de path au lieu d'une seule : `/api` > service backend, `/` > service frontend (c'est ce que suppose déjà le choix `apiUrl: '/api'` fait côté CI/CD)
  - `secret.yaml` > template pour les credentials MySQL du backend (`DB_PASSWORD`) via `stringData` + `envFrom.secretRef`
  - `configmap.yaml` > template pour les variables d'env non-secrètes du backend (`DB_HOST`, `DB_NAME`, `DB_DIALECT`, `PORT`) via `envFrom.configMapRef`
  - `deployment-nodeselector.yaml` (nodeSelector/tolerations pour cibler un node pool spécifique) → pas réutilisé, un seul node pool `system` dans ce projet
  - `hpa.yaml` > pas réutilisé pour l'instant (bonus optionnel, pas demandé par les consignes)
- `mysql-deployment.yaml` + PVC pour la persistance : rien à réutiliser du projet de formation (leur app était du nginx statique sans base de données), à écrire de zéro.

## 5) infrastructure Terraform
## 6) monitoring
## 7) difficultés rencontrées

- Repérer et lever le conflit entre deux stratégies possibles d'injection de l'URL API (substitution runtime vs. génération au build CI) avant qu'il ne cause une régression silencieuse.

- Docker ne démarrait pas nativement dans la LXC Proxmox (erreur `sysctl net.ipv4.ip_unprivileged_port_start: permission denied`) : nécessité d'activer `nesting`/`keyctl` et d'ajouter `lxc.apparmor.profile: unconfined` côté hôte Proxmox.

- Une synchronisation de fichiers via `tar` vers la LXC a temporairement recréé un working tree Git divergent, sur un clone séparé du dépôt présent sur la LXC — résolu par un `git checkout --` ciblé plutôt qu'un reset destructif.
