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

- La pipeline GitHub Actions (`.github/workflows/ci-cd.yml`) exécute les tests unitaires Angular (`ng test --browsers ChromeHeadless`) puis construit le bundle de production. 

- Ajout d'un job `backend-test` au pipeline qui démarre un service MySQL 8 éphémère (`services: mysql`) avec un health-check (`mysqladmin ping`) pour garantir que la base est prête avant le lancement des tests. Les variables d'environnement (`DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `DB_DIALECT`, `PORT`) sont injectées. Deux tests sont exécutés : les tests unitaires du service (`task.service.test.js`) et les tests d'intégration des routes REST (`task.routes.test.js`, via Supertest). 

- L'architecture du workflow repose sur des dépendances strictes : `frontend-build` dépend de `frontend-test` **et** `backend-test`. Le build et le push des images Docker (vers GitHub Container Registry `ghcr.io`) ne se déclenchent que si l'intégralité des tests est au vert.

- Ajout d'un job `deploy` automatisé vers AKS. Ce job s'authentifie via Azure CLI, récupère le contexte AKS, remplace dynamiquement le tag `latest` par le Git SHA dans les manifests Kubernetes (via `sed`), et applique la configuration (`kubectl apply`). Les credentials et noms de ressources (RG, Cluster) sont gérés via les secrets GitHub (`AZURE_CREDENTIALS`, `AKS_RG`, `AKS_CLUSTER`).

## 4) configuration AKS

- Manifests organisés dans `k8s/` et appliqués de manière séquentielle grâce à un préfixe numérique pour garantir l'ordre de création (Namespace > Secret/PVC > Déploiements) :
  - `00-namespace.yaml` : création du namespace `todolist`.
  - `01-database.yaml` : Secret Kubernetes pour les credentials, PVC pour la persistance, Déploiement et Service MySQL.
  - `02-backend.yaml` / `03-frontend.yaml` : Déploiements utilisant les images poussées sur GHCR (`imagePullPolicy: IfNotPresent`) et Services (Node.js port 3000, Nginx port 80).
  - `04-ingress.yaml` : Ingress NGINX routant `/api` vers le backend et `/` vers le frontend.

## 5) infrastructure Terraform

- Prérequis: Terraform version 1.5.0 ou supérieur, une interface AZURE CLI et une "Subscription ID" valide.
- Etape 1 : se connecter à l'interface AZURE CLI.
- Etape 2 : cloner le repo dans le CLI et se mettre dans le dossier "iac".
- Etape 3 : modifier le template en remplissant les champs "ressource_group_name" et "myuid" et en le renommant "terraform.tfvars"
- Etape 4 : lancer le déploiement terraform (init, plan, apply).
- Etape 5 : récupérer les credentials pour Graphana avec `az aks get-credentials`.
  
## 6) monitoring

- Création d'un pod Graphana et d'un pod Prometheus via commandes helm et kubectl.
- Récupération du mdp Graphana avec la commande
  ```
  kubectl get secret --namespace prometheus prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
  ```
- Les communications sont en HTTPS ce qui nécessite l'utilisation de certificats (auto-signé ou non).

## 7) difficultés rencontrées

- Repérer et lever le conflit entre deux stratégies possibles d'injection de l'URL API (substitution runtime vs. génération au build CI) avant qu'il ne cause une régression silencieuse.

- Docker ne démarrait pas nativement dans la LXC Proxmox (erreur `sysctl net.ipv4.ip_unprivileged_port_start: permission denied`) : nécessité d'activer `nesting`/`keyctl` et d'ajouter `lxc.apparmor.profile: unconfined` côté hôte Proxmox.

- Une synchronisation de fichiers via `tar` vers la LXC a temporairement recréé un working tree Git divergent, sur un clone séparé du dépôt présent sur la LXC — résolu par un `git checkout --` ciblé plutôt qu'un reset destructif.

- Gérer les droits d'accès et d'écriture sur le projet par les github actions qui ont été mis en place.

- Erreur de taille de noeuds lors du déploiement de l'iac avec Terraform => modification de la valeur de `default_node_pool` dans le fichier `iac/main.tf` et mettre `temporary_name_for_rotation = "tempdefault"` puis faire un terraform destroy \ plan \ apply pour purger, réparer et recréer l'infra.
