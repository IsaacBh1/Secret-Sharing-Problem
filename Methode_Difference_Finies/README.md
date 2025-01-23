# Partage de Secret par Différences Finies

Ce dépôt contient des scripts R pour **générer** et **reconstruire** un secret à l'aide de la méthode des **différences finies**, inspirée du _Partage de Secret de Shamir (SSS)_. L'objectif est de diviser un secret en plusieurs parts (_shares_) de manière sécurisée, puis de le reconstruire en combinant un nombre minimal de parts (le _seuil_).

## 🛠️ Fonctionnalités

1. **Génération de parts** :
   - Crée un polynôme de degré `t-1` dont le terme constant est le secret.
   - Génère des parts `(x, y)` avec des valeurs `x` régulièrement espacées.
2. **Validation des parts** :
   - Vérifie que les valeurs `x` sont **régulièrement** espacées (nécessaire pour la méthode des différences finies).
3. **Reconstruction du secret** :
   - Utilise les différences finies pour retrouver les coefficients du polynôme.
   - Extrait le secret (le terme constant du polynôme).
4. **Visualisation** :
   - Trace le polynôme reconstruit et les parts pour vérification.
