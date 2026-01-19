## Part 3: The Cisco Ecosystem (Proprietary Protocols) 🏢

Cisco has developed its own protocols to optimize communication between its devices. Although open standards often exist in parallel, it is crucial to know the Cisco versions as they are often enabled by default.

### 3.1 Discovery and Management Protocols (Layer 2)

These protocols are used by devices to introduce themselves to their neighbors.

* **CDP (Cisco Discovery Protocol):**
    * **Function:** A proprietary protocol enabled by default. It allows a Cisco device to see its direct neighbors connected by a cable.
    * **Shared Info:** Hostname, IP address, hardware model, IOS version, and Native VLAN.
    * **Utility:** The number one diagnostic tool for mapping an unknown network.
    * *Standard Equivalent: LLDP (Link Layer Discovery Protocol).*

### 3.2 Switching Protocols (Layer 2)

This is where Cisco stands out by automating switch management.

* **VTP (VLAN Trunking Protocol):**
    * **Function:** Allows propagating VLAN configurations (creation, deletion, renaming) from a "Server" switch to "Client" switches automatically.
    * **Advantage:** Avoids manually configuring VLANs on dozens of switches.
    * **Warning:** A bad configuration can wipe out all VLANs on a network (the famous "VTP Bomb").

* **DTP (Dynamic Trunking Protocol):**
    * **Function:** Automatically negotiates the mode of a port between two switches.
    * **Modes:** It decides if the link should be a "Trunk" (allowing multiple VLANs) or an "Access" port (single VLAN).

* **PAgP (Port Aggregation Protocol):**
    * **Function:** Allows aggregating multiple physical cables into a single logical link (EtherChannel) to increase bandwidth and redundancy.
    * **Operation:** It manages the dynamic addition and removal of links in the group.
    * *Standard Equivalent: LACP (Link Aggregation Control Protocol - 802.3ad).*

* **PVST+ (Per-VLAN Spanning Tree Plus):**
    * **Function:** Cisco version of STP (Spanning Tree Protocol). Unlike the standard which blocks a port for the entire network to prevent loops, PVST+ creates a Spanning Tree instance *for each VLAN*.
    * **Advantage:** Allows for Load Balancing. VLAN 10 can take the left path, while VLAN 20 takes the right path.

### 3.3 Routing and Redundancy Protocols (Layer 3)

For routing and high availability, Cisco offers robust solutions.

* **EIGRP (Enhanced Interior Gateway Routing Protocol):**
    * **Type:** Advanced dynamic routing protocol (Hybrid).
    * **Advantages:**
        * **Fast Convergence:** Finds a new path almost instantly in case of failure.
        * **Intelligent Metric:** Calculates the best route based on bandwidth and delay (latency), unlike others that only count hops.
        * **Multi-protocol Support:** Designed to support IPv4 and IPv6 simultaneously.
    * *Standard Equivalent: OSPF (Open Shortest Path First).*

* **HSRP (Hot Standby Router Protocol):**
    * **Function:** Ensures Default Gateway redundancy (First Hop Redundancy Protocol).
    * **Mechanism:** Two routers (one active, one standby) share a **Virtual IP**. Network computers use this Virtual IP as their gateway.
    * **Failure Scenario:** If the main router fails, the backup router takes over automatically via the Virtual IP. For the user, the outage is invisible.
    * *Standard Equivalent: VRRP (Virtual Router Redundancy Protocol).*

---

### Summary for your documentation

1.  **OSI:** The theoretical roadmap essential for understanding data flow.
2.  **TCP/IP:** Universal standards (TCP for reliability, UDP for real-time).
3.  **Cisco:** An ecosystem aiming to automate management (VTP, DTP) and maximize availability (EIGRP, HSRP, PVST+).
