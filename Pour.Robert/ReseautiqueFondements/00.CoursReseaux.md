# Cours : Fondamentaux des Réseaux, Protocoles et Écosystème Cisco

Ce document couvre les bases théoriques du modèle OSI, les protocoles standards de l'industrie (TCP/IP, SIP) ainsi que les protocoles propriétaires spécifiques aux équipements Cisco.

## Partie 1 : Les Fondations et le Modèle OSI 🏗️

Le modèle OSI (Open Systems Interconnection) est une norme théorique qui standardise la communication entre systèmes informatiques en la divisant en 7 couches d'abstraction.

### 1.1 Les 7 Couches du Modèle OSI

Le flux de données descend de la couche 7 à 1 lors de l'envoi (encapsulation) et remonte de 1 à 7 lors de la réception (décapsulation).

| Couche | Nom | Rôle Principal | Unité de Donnée (PDU) | Exemples / Matériel |
| :--- | :--- | :--- | :--- | :--- |
| **7** | **Application** | Interface directe avec l'utilisateur et les logiciels. | Donnée | HTTP, FTP, SMTP, SSH |
| **6** | **Présentation** | Traduction, chiffrement et compression des données (formatage). | Donnée | ASCII, JPEG, SSL/TLS |
| **5** | **Session** | Gestion des sessions de communication (ouverture, fermeture). | Donnée | NetBIOS, RPC |
| **4** | **Transport** | Transfert fiable ou non, segmentation et réassemblage. | Segment (TCP) / Datagramme (UDP) | TCP, UDP |
| **3** | **Réseau** | Adressage logique et routage (trouver le chemin). | Paquet | IP (IPv4, IPv6), Routeurs |
| **2** | **Liaison de données** | Adressage physique (MAC), détection d'erreurs sur le lien. | Trame (Frame) | Ethernet, Switchs, VLANs |
| **1** | **Physique** | Transmission binaire sur le support (câble, ondes). | Bit | Câbles (RJ45, Fibre), Hubs |

### [1.2 Le concept d'Encapsulation](1.2.La.Mecanique.du.Modele.md)

Pour qu'une donnée voyage, chaque couche ajoute un en-tête (header) aux données reçues de la couche supérieure.
* **L4** ajoute les ports source/destination.
* **L3** ajoute les adresses IP source/destination.
* **L2** ajoute les adresses MAC source/destination.

---

## [Partie 2 : Les Protocoles "Lingua Franca" (Standards)](Partie.2.Les.Protocoles.md) 🗣️

Sur Internet et dans les réseaux modernes, on utilise principalement le modèle **TCP/IP** (une version simplifiée de l'OSI en 4 couches). Voici les protocoles essentiels.

### 2.1 Protocoles de Transport (Couche 4)

C'est le moteur du transport des données. Il existe deux approches principales :

* **TCP (Transmission Control Protocol) :**
    * **Type :** Orienté connexion.
    * **Caractéristiques :** Fiable, garantit l'ordre des paquets, renvoie les paquets perdus, contrôle de flux.
    * **Usage :** Web (HTTP), E-mail, Transfert de fichiers. "Je veux être sûr que tout arrive."
* **UDP (User Datagram Protocol) :**
    * **Type :** Non orienté connexion ("Best effort").
    * **Caractéristiques :** Rapide, léger, aucune garantie de livraison ou d'ordre.
    * **Usage :** Streaming, Jeux en ligne, Voix sur IP (VoIP), DNS. "Je veux que ça arrive vite, tant pis si je perds une image."

### 2.2 Protocoles d'Application et de Service

* **DNS (Domain Name System) :** L'annuaire d'Internet. Traduit un nom (www.google.com) en adresse IP (142.250.x.x). Utilise généralement UDP port 53.
* **DHCP (Dynamic Host Configuration Protocol) :** Distribue automatiquement les adresses IP, masques de sous-réseau et passerelles aux appareils qui se connectent au réseau.
* **ARP (Address Resolution Protocol) :** Fait le lien entre la couche 3 (IP) et la couche 2 (MAC). Il demande "Qui a l'IP 192.168.1.1 ?" pour obtenir l'adresse MAC correspondante.

### 2.3 Focus : Le Protocole SIP (Session Initiation Protocol)

Le SIP est le standard pour la **VoIP (Voix sur IP)** et la communication multimédia.

* **Rôle :** C'est un protocole de *signalisation*. Il ne transporte pas la voix elle-même, mais il gère l'établissement, la modification et la terminaison des sessions (appels).
* **Fonctionnement :** Similaire à HTTP (texte lisible). Il utilise des méthodes comme `INVITE` (appeler), `ACK` (confirmer), `BYE` (raccrocher).
* **Transport de la voix :** Une fois que SIP a établi la connexion ("décroché le téléphone"), la voix passe par un autre protocole appelé **RTP (Real-time Transport Protocol)** qui utilise souvent UDP pour la vitesse.

---

## [Partie 3 : L'Écosystème Cisco (Protocoles Propriétaires)](Partie.3.L.Ecosysteme.Cisco.md) 🏢

Cisco a développé ses propres protocoles pour optimiser la communication entre ses équipements. Bien que des standards ouverts existent souvent en parallèle, il est crucial de connaître les versions Cisco.

### 3.1 Protocoles de Découverte et Gestion (Couche 2)

* **CDP (Cisco Discovery Protocol) :**
    * Protocole propriétaire activé par défaut.
    * Permet à un équipement Cisco de voir ses voisins directs (modèle, IP, version d'IOS, VLAN natif). Très utile pour le diagnostic.
    * *Équivalent standard : LLDP (Link Layer Discovery Protocol).*

### 3.2 Protocoles de Commutation (Switching - Layer 2)

* **VTP (VLAN Trunking Protocol) :**
    * Permet de propager la configuration des VLANs (création, suppression, renommage) d'un switch "Serveur" vers des switchs "Clients" automatiquement. Évite de configurer les VLANs manuellement sur 50 switchs.
* **DTP (Dynamic Trunking Protocol) :**
    * Négocie automatiquement si un lien entre deux switchs doit être un "Trunk" (laisser passer tous les VLANs) ou un "Access" (un seul VLAN).
* **PAgP (Port Aggregation Protocol) :**
    * Protocole Cisco pour créer un **EtherChannel** (agréger plusieurs câbles physiques en un seul lien logique pour plus de vitesse).
    * *Équivalent standard : LACP (Link Aggregation Control Protocol - 802.3ad).*
* **PVST+ (Per-VLAN Spanning Tree Plus) :**
    * Version Cisco du STP (Spanning Tree Protocol). Il crée une instance de Spanning Tree *pour chaque VLAN*. Cela permet d'utiliser des liens différents pour des VLANs différents (équilibrage de charge), contrairement au STP standard qui bloque le même port pour tout le monde.

### 3.3 Protocoles de Routage et Redondance (Layer 3)

* **EIGRP (Enhanced Interior Gateway Routing Protocol) :**
    * Protocole de routage dynamique avancé.
    * Considéré comme "hybride" (vecteur de distance avancé).
    * **Avantages :** Convergence très rapide, calcul de métrique complexe (bande passante + délai), supporte l'équilibrage de charge inégal.
    * *Équivalent standard : OSPF (Open Shortest Path First).*
* **HSRP (Hot Standby Router Protocol) :**
    * Protocole de redondance de passerelle par défaut (First Hop Redundancy Protocol).
    * Permet à deux routeurs de partager une "IP virtuelle". Si le routeur principal tombe, le routeur de secours prend le relais instantanément via l'IP virtuelle, sans que les utilisateurs ne s'en aperçoivent.
    * *Équivalent standard : VRRP (Virtual Router Redundancy Protocol).*

---

### Résumé pour l'examen ou la pratique

1.  **OSI :** C'est la carte routière théorique. Retenez surtout les couches 1, 2, 3 et 4 pour le dépannage réseau.
2.  **TCP/IP :** TCP pour la fiabilité, UDP pour la vitesse (VoIP/Streaming).
3.  **Cisco :** Aime automatiser et faciliter la vie (CDP, VTP) et offrir de la robustesse (EIGRP, HSRP), mais enferme souvent dans son écosystème propriétaire.
