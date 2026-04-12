# 🐧 Installes Ubuntu dans Windows 11 (Facile & Rapide)

Ce guide est conçu pour t'aider à installer **Ubuntu** dans une VM qui roule sur Windows 11. On utilise un script sur mesure qui fait tout le travail compliqué pour toi.

## 🛠️ Ce que le script va faire :
*   Installer **VirtualBox** (le logiciel qui fait rouler Ubuntu).
*   Télécharger la version sécurisée d'**Ubuntu LTS** (la plus stable).
*   Créer ta machine virtuelle avec les bons réglages (mémoire, processeur).
*   Créer un **dossier partagé** sur ton bureau pour échanger des fichiers.
*   Configurer les mises à jour automatiques **Ubuntu** pour ta sécurité.

---

## 🚀 Comment l'installer ?

### 1. Télécharger le script
Cliques sur le lien ci-dessous pour récupérer le fichier d'installation Microsoft Powershell :
👉 **[Télécharger Installer.VM.Ubuntu.Automatique.ps1](Installer.VM.Ubuntu.Automatique.ps1)**
*(Note : Fais un clic droit sur le lien et choisis "Enregistrer le lien sous" et sauvegardes le dans ton dossier **Téléchargements**)*

### 2. Lancer l'installation
1.  Vas dans ton dossier **Téléchargements**.
2.  Trouves le fichier `Installer.VM.Ubuntu.Automatique.ps1`.
3.  Fais un **clic droit** de souris dessus et choisis **Exécuter avec PowerShell**.
4.  Si Windows affiche une fenêtre bleue pour demander la permission administrateur, cliques sur **Oui**.

### 3. Patience...
Le script va ouvrir une fenêtre bleue et travailler tout seul. Le téléchargement d'Ubuntu (environ 5 Go) peut prendre 5 à 10 minutes selon ta connexion internet. **Ne ferme pas la fenêtre.**

### 4. Premier démarrage
Une fois terminé :
1.  Une nouvelle icône nommée **Démarrer Ubuntu.2404** va apparaitre sur ton bureau.
2.  Double-cliques dessus pour démarrer la VM Ubuntu.
3.  **Important pour la première fois:** Laisses l'installation (5-10 minutes) d'Ubuntu se terminer à l'intérieur de la fenêtre. **Ne touches à rien à la fenètre tant que tu ne voies pas le bureau avec le fond d'écran Ubuntu apparaitre à la fin du processus initial d'installation**.
4. Quand l'installation initiale du premier démarrage est complétée, cliquer sur le lien ne va prendre que 15 secondes pour démarrer la VM. 

### 5. Démarrer la VM ensuite
1. Cliques sur l'icône nommée **Démarrer Ubuntu.2404** sur ton bureau pour utiliser la VM.
2. Fermer la VM à l'intérieur de la VM à haut à droite dans la VM et choisir éteindre.
3. La fenêtre de la VM va se fermer toute seule quand la VM est fermée et inactive. 

---

## 📁 Partager des fichiers
Le script a créé un dossier spécial sur ton bureau Windows : **Bureau_Ubuntu.2404**.
*   Tout ce que tu déposes dedans sera accessible sur le bureau de la VM Ubuntu.
*   C'est le moyen le plus simple de transférer tes photos ou documents.

---

## 🆘 Dépannage : Message sur la Virtualisation
Si le script s'arrête et affiche un message d'erreur en rouge à propos de virtulisation, c'est qu'une option est bloquée dans ton ordinateur. Voici comment la régler dans le bios d'un ordi **ASUS** :

1.  **Redémarrage :** Accepte l'option du script pour redémarrer vers le BIOS.
2.  **Mode Avancé :** Une fois dans le menu gris, appuie sur **F7** pour le **Mode Avancé / Advanced Mode**.
3.  **Menu CPU :**
    *   Va dans l'onglet **Avancé / Advanced** (en haut).
    *   Clique sur **Configuration du CPU / CPU Configuration**.
4.  **Activer l'option :**
    *   Cherche **SVM Mode**.
    *   Change "Désactivé / Disabled" pour **Activé / Enabled**.
5.  **Quitter :** Appuie sur **F10**, puis confirme avec **Ok**.
6.  **Relancer :** Une fois revenu dans Windows, relance le script une dernière fois.

---
*Guide et script créé pour simplifier la vie d'André.*

