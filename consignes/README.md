# 📘 Projet DevOps – ToDoList conteneurisée et déployée sur Azure

## 🎯 Objectifs pédagogiques

Ce projet a pour but de vous faire mettre en œuvre l’ensemble des compétences attendues d’un administrateur système DevOps, en vous plaçant dans un contexte réaliste : déploiement d’une application web complète (frontend Angular, backend Express.js, base MySQL) sur un cluster Kubernetes managé (AKS – Azure Kubernetes Service), avec automatisation des processus CI/CD et mise en place d’un monitoring.

## 🧱 Architecture de l'application

L’application est constituée de trois composants :

- `projet_devops_frontend` : interface Angular avec Angular Material
- `projet_devops_backend` : API REST Node.js + Express
- `database` : base de données MySQL

Les sources sont disponibles dans les dépôts GitHub suivants :

- [projet_devops_frontend](https://github.com/ENI-Projet-DevOps/projet_devops_frontend)  
- [projet_devops_backend](https://github.com/ENI-Projet-DevOps/projet_devops_backend)  
- [projet_devops_consignes]() (ce dépôt)

> ⚠️ Vous n'avez pas les droits d'écriture sur les dépôts `frontend` et `backend`. Voir plus bas pour comprendre comment travailler dessus.

## 🔄 Étapes à réaliser

### 1. 📦 Récupération des sources

**Reproduire la structure dans vos propres dépôts (fork)**  
- Forkez les dépôts `projet_devops_frontend` et `projet_devops_backend` dans votre compte GitHub personnel  
- Clonez localement chaque fork


### 2. 🛠️ Objectifs techniques

| Compétence        | Tâches attendues                                               |
|-------------------|----------------------------------------------------------------|
| Conteneurisation  | Création des fichiers Dockerfile pour chaque composant        |
| CI/CD             | Pipelines GitHub Actions pour build, test et push d’images     |
| Déploiement Azure | Déploiement via Terraform et conteneurisation via AKS           |
| Supervision       | Intégration de Prometheus + Grafana                            |
| Documentation     | README détaillé et structuré expliquant chaque étape           |

> 📝 Un document de consignes détaillées vous sera fourni dans ce dépôt pour vous guider dans chaque étape.

## 🚦 Règles d’usage des dépôts de l’organisation

### 🔒 Accès en lecture seule

En tant que membre de l’organisation GitHub, vous bénéficiez :

- d’un accès en lecture seule aux dépôts `projet_devops_frontend`, `projet_devops_backend` et `projet_devops_consignes`
- de la possibilité de consulter le code, la documentation et les issues

### 🆘 Utilisation des issues

Vous êtes autorisés à créer des issues pour :

- Signaler un bug ou une incohérence
- Poser une question technique
- Suggérer une amélioration

> Merci de formuler un **titre clair** et un **message précis**.  
> Exemples :  
> ✅ `[BUG] L’API renvoie 500 à la suppression d’une tâche`  
> ✅ `[QUESTION] Peut-on utiliser Docker Compose pour tester localement ?`

### ❌ Interdictions

- Ne modifiez **jamais** les fichiers directement dans les dépôts `frontend`, `backend` ou `projet_consignes`
- Ne créez **aucune branche** dans ces dépôts
- Ne poussez **aucun commit** dans ces dépôts

## 🧠 Conseils pour réussir

- Travaillez en itérations : d’abord en local, puis via conteneurs, puis via Kubernetes
- Documentez vos choix dans votre README.md : variables, ports, workflows, erreurs rencontrées
- Soyez rigoureux dans le nommage des fichiers et l’organisation de vos dossiers
- Utilisez les issues pour poser vos questions (aucune question n’est idiote !)

## ✍️ Suivi pédagogique

Des points d’étape seront prévus avec votre formateur pour :

- Valider la progression
- Vous débloquer si besoin
- Évaluer la qualité de votre code, de votre infrastructure et de votre documentation

## 🙏 Remerciements

Ce projet est mis à disposition dans le cadre du module DevOps de la formation **Administrateur Système DevOps**. Merci de respecter les règles de fonctionnement de l’organisation.

---

🔗 Bon courage, soyez curieux, et amusez-vous avec l’infra ! 🚀
