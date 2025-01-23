# Partage de Secret de Shamir avec Différentes Méthodes d'Interpolation

Ce dépôt contient des scripts R pour **générer** et **reconstruire** un secret en utilisant le **Partage de Secret de Shamir (SSS)** avec différentes méthodes d'interpolation. L'objectif est de diviser un secret en plusieurs parts de manière sécurisée et de le reconstruire en utilisant un nombre minimal de parts (le seuil `t`). Plusieurs méthodes d'interpolation sont implémentées pour s'adapter à différents cas d'utilisation.

---

## 📋 Aperçu

Le Partage de Secret de Shamir est un algorithme cryptographique qui :

1. **Divise un secret** en plusieurs parts distribuées aux participants.
2. **Reconstruit le secret** uniquement si un nombre suffisant de parts (le seuil `t`) est fourni.
3. Utilise **l'interpolation polynomiale** pour reconstruire le secret à partir des parts.

Ce dépôt implémente plusieurs méthodes d'interpolation pour reconstruire le polynôme et retrouver le secret :

- **Différences finies** : Pour des parts avec des valeurs `x` régulièrement espacées.
- **Interpolation de Lagrange** : Pour des parts avec des valeurs `x` quelconques.
- **Interpolation de Newton** : Une alternative efficace pour des valeurs `x` régulières ou irrégulières.

## Vidéo d'Explication

[![Vidéo d'Explication](https://img.youtube.com/vi/iFY5SyY3IMQ/0.jpg)](https://youtu.be/iFY5SyY3IMQ?si=Si8yz_5YX1kzEN20)
