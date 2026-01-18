## Partie 3 : L'Écosystème Cisco (Protocoles Propriétaires) 🏢

Cisco a développé ses propres protocoles pour optimiser la communication entre ses équipements. Bien que des standards ouverts existent souvent en parallèle, il est crucial de connaître les versions Cisco, car elles sont activées par défaut ou offrent des fonctionnalités exclusives.

### 3.1 Protocoles de Découverte et Gestion (Couche 2)

Ces protocoles servent aux équipements à se présenter à leurs voisins.

* **CDP (Cisco Discovery Protocol) :**
    * **Fonction :** C'est un protocole de voisinage activé par défaut. Il permet à un appareil Cisco de voir ses voisins directs connectés par un câble.
    * **Informations partagées :** Le nom de l'appareil (Hostname), l'adresse IP, le modèle matériel, la version du système (IOS) et le VLAN natif.
    * **Utilité :** Outil de diagnostic numéro un pour cartographier un réseau inconnu.
    * *Équivalent standard : LLDP (Link Layer Discovery Protocol).*

### 3.2 Protocoles de Commutation (Switching - Layer 2)

C'est ici que Cisco se distingue par l'automatisation de la gestion des commutateurs (switches).

* **VTP (VLAN Trunking Protocol) :**
    * **Fonction :** Permet de propager la configuration des VLANs (création, suppression, renommage) d'un commutateur « Serveur » vers des commutateurs « Clients » automatiquement.
    * **Avantage :** Évite de devoir configurer manuellement les VLANs sur des dizaines de commutateurs.
    * **Attention :** Une mauvaise configuration peut effacer tous les VLANs d'un réseau (le fameux « VTP Bomb »).

* **DTP (Dynamic Trunking Protocol) :**
    * **Fonction :** Négocie automatiquement le mode d'un port entre deux commutateurs.
    * **Modes :** Il décide si le lien doit être un « Trunk » (laisser passer plusieurs VLANs) ou un port « Access » (un seul VLAN).

* **PAgP (Port Aggregation Protocol) :**
    * **Fonction :** Permet de regrouper plusieurs câbles physiques en un seul lien logique (EtherChannel) pour augmenter la bande passante et la redondance.
    * **Fonctionnement :** Il gère l'ajout et le retrait dynamique des liens dans le groupe.
    * *Équivalent standard : LACP (Link Aggregation Control Protocol - 802.3ad).*

* **PVST+ (Per-VLAN Spanning Tree Plus) :**
    * **Fonction :** Version Cisco du STP (Spanning Tree Protocol). Contrairement au standard qui bloque un port pour tout le réseau afin d'éviter les boucles, PVST+ crée une instance de Spanning Tree *pour chaque VLAN*.
    * **Avantage :** Permet l'équilibrage de charge (Load Balancing). Le VLAN 10 peut passer par le chemin de gauche, et le VLAN 20 par le chemin de droite.

### 3.3 Protocoles de Routage et Redondance (Layer 3)

Pour le routage et la haute disponibilité, Cisco propose des solutions robustes.

* **EIGRP (Enhanced Interior Gateway Routing Protocol) :**
    * **Type :** Protocole de routage dynamique avancé (Hybride).
    * **Avantages :**
        * **Convergence rapide :** Trouve un nouveau chemin presque instantanément en cas de panne.
        * **Métrique intelligente :** Calcule la meilleure route en se basant sur la bande passante et le délai (latence), contrairement à d'autres qui ne comptent que le nombre de sauts.
        * **Support multi-protocoles :** Conçu pour supporter IPv4 et IPv6 simultanément.
    * *Équivalent standard : OSPF (Open Shortest Path First).*

* **HSRP (Hot Standby Router Protocol) :**
    * **Fonction :** Assure la redondance de la passerelle par défaut (First Hop Redundancy Protocol).
    * **Mécanisme :** Deux routeurs (un actif, un en attente) partagent une **IP virtuelle**. Les ordinateurs du réseau utilisent cette IP virtuelle comme passerelle.
    * **Scénario de panne :** Si le routeur principal tombe en panne, le routeur de secours prend le relais automatiquement via l'IP virtuelle. Pour l'utilisateur, la coupure est invisible.
    * *Équivalent standard : VRRP (Virtual Router Redundancy Protocol).*

---

### Synthèse pour votre documentation

1.  **OSI :** La carte routière théorique indispensable pour comprendre le flux.
2.  **TCP/IP :** Les standards universels (TCP pour la fiabilité, UDP pour le temps réel).
3.  **Cisco :** Un écosystème qui vise à automatiser la gestion (VTP, DTP) et maximiser la disponibilité (EIGRP, HSRP, PVST+).
