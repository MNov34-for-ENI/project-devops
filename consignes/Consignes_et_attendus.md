
# 📋 Consignes et Attendus du Projet DevOps – ToDoList conteneurisée

## 🎯 Objectifs pédagogiques

Ce projet a pour but de vous faire mettre en œuvre les compétences clés d’un administrateur système DevOps, à travers un cas concret de déploiement d’une application web complète. Vous manipulerez des outils d’intégration continue, de déploiement automatisé, de conteneurisation, d’infrastructure as code et de supervision dans un environnement cloud (Azure).

---

## Compétences évaluées

Ce projet servira à évaluer la compétence **C8 - Automatiser la mise en production d'une application avec une plateforme**.
Les autres compétences ont déjà été évaluées auparavant. Toutefois, nous nous offrons la possibilité de vous évaluer de nouveau sur celles-ci au travers de ce projet. Dans tous les cas, nous ne retiendrions que les notes améliorant votre score précédemment obtenu.

---

## 👥 Modalités de travail

- Le projet se réalise en **équipe de 2 à 3 personnes**.
- **Chaque élève effectue individuellement l’ensemble des manipulations techniques.**
- Le travail en équipe a pour objectif de favoriser l’entraide, l’échange d’idées et la **préparation de la présentation finale**, qui se fera **en groupe**.

---

## 🔗 Sources des projets

Vous disposez de deux dépôts privés dans l’organisation GitHub :

- `projet_devops_frontend` – Application Angular avec Angular Material
- `projet_devops_backend` – API REST Node.js + Express + MySQL

Chaque projet est documenté dans son propre `README.md`. **Prenez le temps de les lire attentivement.**

---

## 🧱 Architecture recommandée pour votre dépôt

Vous devez **créer un nouveau dépôt personnel** et y organiser les sources comme suit :

```
/mon-projet-devops/
│
├── backend/              # Code du backend Express
│   └── Dockerfile
│
├── frontend/             # Code Angular
│   └── Dockerfile
│
├── iac/                  # Code Terraform pour provisionner AKS et ressources Azure
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│
├── k8s/                  # Fichiers de déploiement Kubernetes (yaml)
│   ├── frontend-deployment.yaml
│   ├── backend-deployment.yaml
│   ├── mysql-deployment.yaml
│   └── ...
│
├── .github/workflows/   # Pipelines CI/CD GitHub Actions
│   └── ci-cd.yml
│
├── monitoring/           # Dashboards Grafana, conf Prometheus
│
├── README.md             # Votre documentation principale
└── .env                  # Variables d’environnement
```

---

## 📌 Étapes et attendus

### 🔹 1. Récupération des sources
- Clonez les deux projets frontend et backend dans les répertoires appropriés de votre dépôt.
- Pour tester le bon fonctionnement de l'application, vous pouvez l'exécuter en local. N'hésitez pas à suivre les README.md des deux projets (frontend et backend). La base de données MySQL est à récupérer sur Docker Hub. Pour sa configuration, merci de vous référer au README.md section Base de données du repository projet_devops_backend

### 🔹 2. Conteneurisation
- Créez un `Dockerfile` pour chaque composant (`frontend` et `backend`).
- La base MySQL sera configurée dans Kubernetes.

### 🔹 3. Stockage des images
- Poussez vos images sur un **registry** public ou privé (DockerHub ou GitHub Container Registry).

### 🔹 4. Infrastructure as Code (Terraform)
- Utilisez **Terraform (HCL)** pour créer l'infrastructure sur Azure.
- Provisionnez un **cluster AKS** et toute autre ressource nécessaire.
- Stockez le code dans le dossier `iac/` avec un `README.md` expliquant comment initialiser et appliquer la configuration.

> [!IMPORTANT]  
> Vous devez configurer un tag : "user = <myuid>" pour chaque ressources que vous créez avec Terraform

### 🔹 5. Intégration Continue / Déploiement Continu (CI/CD)
- Mettez en place un pipeline GitHub Actions (`.github/workflows/ci-cd.yml`).
- **Exécutez les tests unitaires** automatiquement.
- **Le déploiement ne doit se faire que si les tests sont 100 % OK.**
- Déployez les conteneurs automatiquement dans un **cluster AKS (Azure Kubernetes Service)**.

### 🔹 6. Infrastructure Kubernetes
- Créez les fichiers YAML nécessaires au déploiement des composants dans AKS.
- Gérez les services, ingress, volumes, secrets, configMaps, etc.
- La base de données MySQL devra être **persistante** (optionnel).

> [!TIP]
> Pour rendre vos applications disponibles à l'extérieur du cluster, vous avez le choix d'utiliser NGINX ou API Gateway.
> - [NGINX](https://learn.microsoft.com/fr-fr/azure/aks/app-routing-nginx-configuration?tabs=azure-cli&pivots=nginx-ingress-controller) est la façon historique d'exposer un service à l’extérieur, mais elle sera dépréciée en novembre 2026.
> - [Api Gateway](https://learn.microsoft.com/fr-fr/azure/aks/managed-gateway-api) est la nouvelle solution d'ingress recommandée par Kubernetes.

### 🔹 7. Monitoring
- Intégrez un système de supervision avec **Prometheus + Grafana**.
- Fournissez au moins **un dashboard** fonctionnel.
- L’export de métriques personnalisées est un **plus**.

### 🔹 8. Documentation
- Chaque dépôt d’origine contient une documentation technique.
- Vous devez rédiger un **README.md complet** dans votre dépôt global comprenant :
  - L’architecture de l’application
  - Les choix techniques
  - La démarche CI/CD
  - La configuration AKS
  - L’infrastructure déclarée avec Terraform
  - Le monitoring
  - Les difficultés rencontrées
- Ce document fera **l’objet d’une évaluation. Il sera à livrer le vendredi à 12h au plus tard**. Attention donc au respect des délais.
- La livraison de la documentation se fait de la manière suivante :
  - Créer une copie de votre README.md et renommer-là avec votre prénom et votre nom. (ex. : `johndoe.md`)
  - Cloner le repository **https://github.com/ENI-Projet-DevOps/projet_documentation_evaluation** 
  - Créer une branche à son nom (ex. : johndoebranch)
  - Insérer la copie de la documentation dans le dossier **/docs**
  - Faire une **pull request** sur la branche **main**
  - Le workflow va s'exécuter automatiquement après validation de la PR
  - Après une dernière validation du formateur, le score apparaitra dans le dossier **/scores** avec un feedback
  - La note est sur 5. Elle est obtenue automatiquement mais le formateur supervisant le projet a toute autorité pour réviser cette note.
---

## 🧪 Tests unitaires

- Le projet frontend et le backend possèdent déjà des tests.
- Vous devez intégrer leur exécution dans le workflow CI.
- **Tout test doit réussir avant tout déploiement.**
- (Optionnel) Générer un rapport de couverture.

---

## 🗣️ Présentation finale

- La soutenance est **collective**, mais chaque membre doit avoir participé aux manipulations.
- **Durée : 10 minutes par équipe**
- Support : PowerPoint (ou équivalent)
- **Thème** : *Automatiser la mise en production d'une application avec une plateforme*

### 🧾 Contenu de la présentation :
1. **Présentation synthétique du projet et du contexte** (2 min)
2. **Spécifications techniques et schéma d’architecture déployée** (2 min)
3. **Démarche et outils utilisés** (2 min)
4. **Script et fichiers YAML significatifs concernant l'Automatisation de la mise en production d'une application avec une plateforme, choix justifiés** (3 min)
5. **Conclusion : bilan de l’expérience et difficultés rencontrées** (1 min)

---

## 📝 Évaluation

Un document dédié à l’évaluation est fourni dans le fichier `notation.md`.

---

## 💡 Conseils

- Commencez par tester vos images et conteneurs **localement** avec Docker.
- N'oubliez pas que ce projet servira à évaluer la compétence **C8 - Automatiser la mise en production d'une application avec une plateforme**. Vous devrez porter une attention particulière sur ces aspects du projet.
- Tenez à jour votre documentation en temps réel.

Bon courage ! 🚀
