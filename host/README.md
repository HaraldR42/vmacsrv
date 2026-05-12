# Host and network setup

**Important: Use this as a inspiration or starting point for your own setup. Adapt to your specific setup. YMMV**

For Debian systems, a /etc/network/[interfaces](interfaces) file is provided.

## Adaptation

The following parts most like need adaption to your individual setup:
1. Physical interfaces:<br>
In the lines `rename ens18=lan` and `rename ens19=vintagelan`, replace the ens* interface names with your real interface names.
2. Definition of `lan`:<br>
Adapt the address details of your host living in your LAN. You also might use DHCP here.

---
---
# Host network setup details

This machine sits at the intersection of four independent networks. Together they enable modern infrastructure, legacy hardware connectivity, and tunnelled virtual networking to coexist on a single host.

## The Four Networks

### 1. `lan`

The main network interface, `lan`, connects the machine to the LAN network. It has a conventional static IP configuration. This is the machine's "front door" — how it is reached from the rest of the LAN network and how it reaches the internet.

### 2. `vintagelan`

The vintage network is built around `vintagelan`, a physical interface that connects to real vintage hardware — think classic Macs or other retro equipment communicating over EtherTalk protocols. 

### 3. `ethoudp`

The third network is entirely virtual overlay network for SheepShaver/Basilisk II. `ethoudp_tap` is a TAP interface that encapsulates Ethernet frames (EtherTalk and IPv4) inside UDP packets, allowing emulators to be reached over the LAN network. 

It is explicitly kept standalone — not joined to any bridge.

### 4. `ltoudp`

The fourth network is also an overlay network over LAN, but in this case carry LocalTalk frames inside UDP. `ltoudp_tap` is a TAP interface that carries EtherTalk traffic getting routed in to LocalTalk and then sent by LocalTalk-over-UDP tunnelling to remote nodes.

## Why the Bridge?

The `vintage_br` bridge is the heart of the vintage network. A bridge operates at Layer 2 (Ethernet frames), meaning it forwards raw network traffic between its member interfaces without caring about IP addresses. This is essential here because vintage protocols like EtherTalk do not use IP at all — they need to be forwarded at the Ethernet/data-link level.

By bridging `vintagelan`, `ltoudp_tap`, and `vintagehost_br` together, the setup makes all three look like they are on the same physical wire. A packet arriving from a real vintage Mac on `vintagelan` is forwarded transparently to the `ltoudp_tap` router (and onwards to remote vintage nodes) and to the host machine itself, all without any routing or IP translation involved.

Keep in mind that `ethoudp_iface` must not be connected to the bridge. This is a standalone interface that must be routed. See [ethoudp_iface on github](https://github.com/HaraldR42/ethoudp_iface).

## Why the veth Pair?

A veth (virtual Ethernet) pair is a pair of virtual network interfaces that are directly connected to each other — whatever goes in one end comes out the other. It is the standard Linux way to connect a bridge to the host's own network stack.

Assigning IP addresses to a bridge itself is imho a bad practice. It mixes layer 2 and layer 3 in an ambigous way. The veth pair solves this cleanly:

- `vintagehost_br` is plugged into the bridge, acting like a virtual cable into the vintage network segment.
- `vintagehost_if` sits outside the bridge in the host's normal network stack, and carries the IP address `172.29.60.1`.

This way application on the host can communicate with vintage devices as a first-class participant on the vintage network, while the bridge continues to forward traffic between all other members without confusion.

