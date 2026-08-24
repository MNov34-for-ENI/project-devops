// Ce fichier est régénéré par le pipeline CI/CD (voir .github/workflows/ci-cd.yml)
// juste avant le build de production, au cas où l'URL de l'API devrait changer.
// La valeur ci-dessous est celle utilisée par défaut (Ingress AKS et proxy nginx
// local via docker-compose routent tous les deux /api vers le service backend).
export const environment = {
  production: true,
  apiUrl: '/api'
};
