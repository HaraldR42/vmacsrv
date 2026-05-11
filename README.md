# Vintage Mac Server

**IMPORTANT: This is not meant as a "ready to deploy and run" project. The purpose is to give some hints about how a compact communication server for vintage Macs (physical and virtual) could look.**

## Features

- LocalTalk
- EtherTalk
- AppleTalk routing
- TCP/IP routing and masquerading
- File server (netatalk)
- DNS (dnsmasq)
- DHCP (dnsmasq)

---
## Supported emulators

All emulators were run on MacBook Neo, MacOS Tahoe 26.4.1. Host connectivity was WiFi.

| Emulator    | Tested  | System | Net SW | Connection | Via |
|-------------|---------|--------|--------|------------|-----|
| Mini vMac   | &#9989; | 6.0.7 | Classic | LocalTalk | ltoudp |
| Basilisk II | &#9989; | 7.5.5 | OpenTransport 1.3 | EtherTalk+TCP/IP | ethoutp |

SheepShaver should work similar to Basilisk II but is currently untested.

## Supported real Macs

Currently all untested. A Mac SE and a Mac IIci are waiting to be recaped.

---
---
# Setup description

## Host requirements
The current setup uses:
- Physical or virtual machine (mine is running on a [Proxmox](https://www.proxmox.com/) server)
- Two separate Ethernet connections
    - should be separate broadcast domains
    - can be real network cards or VLANs on the same physical network
- Debian Trixie
    - no GUI installed
    - Docker installed

Using Docker here is debatable, especially because the containers require many privileges. It's just my personal preference for keeping dependencies separate between applications.

## Networks
The setup features 4 networks: 
- Two of them with real interfaces: These exist because I wanted to have the possibility to separate the vintage Mac traffic (which stems from the time where networks used to be innocent) from today's ordinary LAN traffic.
- Two overlay/tunnel networks.

In greater detail:

| Interface    | Transport                         | Description                                  |
|--------------|-----------------------------------|----------------------------------------------|
| `lan`        | Ethernet                          | The ordinary LAN.                            |
| `vintagelan` | Ethernet                          | Local network for physical vintage machines. |
| `ethoutp`    | Ethernet frames over UDP broadbast  | SheepShaver / Basilisk II VMs using udptunnel| 
| `ltoudp`     | LocalTalk over UDP multicast        | LocalTalk over UDP                           |

See [host subdir](host/) for setup details

