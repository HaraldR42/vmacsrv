# Networking

## Overview

| Interface    | IP net | Atalk net | Zone name | Description                                  |
|--------------|--------|-----------|-----------|----------------------------------------------|
| `vintagelan` | 172.29.60.0/24 | 60 | EtherTalk zone | Local network for physical vintage machines. |
| `ethoutp`    | 172.29.61.0/24 | 61 | EthOverUDP zone | SheepShaver / Basilisk II VMs using udptunnel | 
| `ltoudp`     | -              | 62 | LToUDP zone     | LocalTalk over UDP                           |


## Routing
### AppleTalk routing

AppleTalk routing is done by two routers.

1. netatalk router
    - Routes between `vintagelan` and `ethoutp`
    - Seeding router for both networks
1. ltoudp router
    - Routes between `vintagelan` and `ltoudp`
    - Seeding router for `ltoudp`
    - `vintagelan` side gets configured by the upstream netatalk router

Every network gets its own zone name. See the table below.

### IP routing

The Linux kernel is used for routing and masquerading IP traffic.
1. Direct routes between `vintagelan` and `ethoutp`
1. Masqueraded traffic for
    - `vintagelan` to `lan` (and onward to the internet)
    - `ethoutp` to `lan` (and onward to the internet)

