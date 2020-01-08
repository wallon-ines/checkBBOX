checkBBOX
=========

Script de reboot de la bbox Bouygues Telecom.

Ce script effectue un ping sur un serveur extérieur. En cas d'échec, le
script se connect sur l'interface d'administration de la bbox et demande
un redémarrage de la bbox.

## Configuration ##

1. Copier le fichier config.exemple en config

2. Ajuster la configuration du fichier:

```

  # Mot de passe du compte administrateur
  PASSWORD=
  # Adresse de l'envoi de l'email
  MAIL=

  # HOST à pinger pour vérifier la connexion
  # HOST_TO_PING=www.google.fr
```

3. Programmer l'exécution du script en crontab

