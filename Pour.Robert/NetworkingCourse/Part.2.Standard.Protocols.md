## Part 2: Standard "Lingua Franca" Protocols 🗣️

Once the physical infrastructure is in place, machines must speak the same language. This is the role of the **TCP/IP** protocol suite.

### 2.1 Transport Layer (Layer 4): Choosing the Vehicle

Layer 4 is responsible for end-to-end data delivery. It must make a crucial choice for each application: prioritize **reliability** or **speed**?

#### A. TCP (Transmission Control Protocol) - Reliability First
TCP is a meticulous protocol. It doesn't just send data; it ensures it arrives, and in the right order.

**The "Three-Way Handshake"**
Before sending a single byte of data, TCP establishes an official connection in 3 steps:
1.  **SYN (Synchronize):** The client sends "I want to connect, here is my initial sequence number".
2.  **SYN-ACK (Synchronize-Acknowledge):** The server replies "I received your request, I agree, here is my sequence number".
3.  **ACK (Acknowledge):** The client replies "Received, the connection is established".

*If one step fails, the connection is not made.*

**Mechanisms for Reliability:**
* **Sequencing:** If packets arrive out of order (1, 3, 2), TCP reorders them (1, 2, 3) before giving them to the application.
* **Acknowledgment (ACK):** For each segment received, the recipient sends back an "ACK". If the sender doesn't receive the ACK, it resends the data.
* **Flow Control (Windowing):** If the recipient is overwhelmed, it tells the sender "Slow down!" (reduces the window size).

**Usage:** Web Browsing (HTTP), Email, File Transfers. "I want to be sure everything arrives."

#### B. UDP (User Datagram Protocol) - Pure Speed
UDP is a "Fire and Forget" protocol. There is no handshake, no verification, no reordering.

* **Advantage:** No waiting time (minimal latency).
* **Disadvantage:** If a packet is lost en route, it is lost forever.
* **Usage:** Streaming, Online Gaming, Voice over IP (VoIP), DNS. "I want it to arrive fast, it doesn't matter if I lose a frame."

---

### 2.2 Infrastructure Services (Application Layer)

Before you can browse the Web, your computer needs two things: an identity (IP) and a directory (DNS).

#### A. DHCP (Dynamic Host Configuration Protocol): Getting an Address
When you plug in a computer, it has no IP address. It uses the **DORA** process to find one automatically:

1.  **D - Discover:** The computer shouts on the network (Broadcast): "Is there a DHCP server here? I need an IP!"
2.  **O - Offer:** The DHCP server hears the request and replies: "Here, I can offer you IP 192.168.1.10".
3.  **R - Request:** The computer replies: "Great, I'll take 192.168.1.10, is it official?".
4.  **A - Acknowledge:** The server confirms: "Noted, it's yours for 24 hours (Lease)".

#### B. DNS (Domain Name System): The Phonebook
Computers only understand numbers (IPs), humans prefer names (google.com). DNS does the translation.

**The Recursive Resolution Process:**
1.  You type `www.cisco.com`.
2.  Your computer asks its local DNS server (often your router or ISP): "What is the IP for cisco.com?"
3.  If the server doesn't know, it asks the **Root Servers (.)**, which refer it to the **TLD Servers (.com)**, which refer it to the **Cisco Name Server**, which finally gives the IP.
4.  The result is cached to avoid repeating the process next time.
