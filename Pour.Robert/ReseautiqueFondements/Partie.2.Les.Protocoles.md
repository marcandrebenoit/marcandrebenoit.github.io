## Partie 2 : Les Protocoles Standards « Lingua Franca » 🗣️

Une fois que l'infrastructure physique est en place, les machines doivent parler le même langage. C'est le rôle de la suite de protocoles **TCP/IP**.

### 2.1 La Couche Transport (Layer 4) : Le choix du véhicule

La couche 4 est responsable de la livraison des données de bout en bout. Elle doit faire un choix crucial pour chaque application : privilégier la **fiabilité** ou la **vitesse** ?

#### A. TCP (Transmission Control Protocol) - La Fiabilité avant tout
TCP est un protocole méticuleux. Il ne se contente pas d'envoyer des données ; il s'assure qu'elles arrivent, et dans le bon ordre.

**Le « Three-Way Handshake » (L'initialisation)**
Avant d'envoyer le moindre octet de donnée, TCP établit une connexion officielle en 3 étapes (comme une poignée de main) :
1.  **SYN (Synchronize) :** Le client envoie « Je veux me connecter, voici mon numéro de séquence initial ».
2.  **SYN-ACK (Synchronize-Acknowledge) :** Le serveur répond « J'ai bien reçu ta demande, je suis d'accord, voici mon numéro de séquence ».
3.  **ACK (Acknowledge) :** Le client répond « Bien reçu, la connexion est établie ».

*Si une étape échoue, la connexion ne se fait pas.*

**Mécanismes de fiabilité :**
* **Séquençage :** Si les paquets arrivent dans le désordre (1, 3, 2), TCP les remet dans l'ordre (1, 2, 3) avant de les donner à l'application.
* **Accusé de réception (ACK) :** Pour chaque segment reçu, le destinataire renvoie un « ACK ». Si l'émetteur ne reçoit pas l'ACK, il renvoie la donnée.
* **Contrôle de flux (Windowing) :** Si le destinataire est débordé, il dit à l'émetteur « Ralentis ! » (réduit la taille de la fenêtre).

**Usage :** Navigation Web (HTTP), Courriel, Transfert de fichiers. « Je veux être certain que tout arrive. »

#### B. UDP (User Datagram Protocol) - La Vitesse pure
UDP est un protocole « Fire and Forget » (Tire et oublie). Il n'y a pas de poignée de main, pas de vérification, pas de remise en ordre.

* **Avantage :** Pas de délai d'attente (latence minimale).
* **Inconvénient :** Si un paquet est perdu en route, il est perdu à jamais.
* **Usage :** Diffusion en continu (streaming), Jeux en ligne, Voix sur IP (VoIP), DNS. « Je veux que ça arrive vite, tant pis si je perds une image. »

---

### 2.2 Les Services d'Infrastructure (Application Layer)

Avant de pouvoir naviguer sur le Web, votre ordinateur a besoin de deux choses : une identité (IP) et un répertoire (DNS).

#### A. DHCP (Dynamic Host Configuration Protocol) : Obtenir une adresse
Quand vous branchez un ordinateur, il n'a pas d'adresse IP. Il utilise le processus **DORA** pour en trouver une automatiquement :

1.  **D - Discover (Diffusion) :** L'ordinateur crie sur le réseau (Broadcast) : « Y a-t-il un serveur DHCP ici ? J'ai besoin d'une IP ! »
2.  **O - Offer :** Le serveur DHCP entend la demande et répond : « Tiens, je peux te proposer l'IP 192.168.1.10 ».
3.  **R - Request :** L'ordinateur répond : « Super, je prends la 192.168.1.10, c'est officiel ? ».
4.  **A - Acknowledge :** Le serveur confirme : « C'est noté, elle est à toi pour 24 heures (Bail) ».

#### B. DNS (Domain Name System) : Le Bottin
Les ordinateurs ne comprennent que les chiffres (IP), les humains préfèrent les noms (google.com). Le DNS fait la traduction.

**Le processus de résolution récursive :**
1.  Vous tapez `www.cisco.com`.
2.  Votre ordinateur demande à son serveur DNS local (souvent votre routeur ou celui de votre fournisseur d'accès) : « C'est quoi l'IP de cisco.com ? »
3.  Si le serveur ne sait pas, il demande aux **Serveurs Racines (.)**, qui le renvoient vers les serveurs **TLD (.com)**, qui le renvoient vers le serveur de **Cisco**, qui donne enfin l'IP.
4.  Le résultat est mis en **cache** (mémoire tampon) pour ne pas refaire tout le chemin la prochaine fois.
