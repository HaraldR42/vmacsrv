# DNS and DHCP services

**Important: Use this as a inspiration or starting point for your own setup. Adapt to your specific setup. YMMV**

For DNS and DHCP [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html) is used.

To avoid any interference with an existing LAN setup, DNS and especially DHCP is only active on `vintagelan` and `ethoudp`.

## Building the image
For example:
```
docker build -t vmacsrv-dnsmasq:latest .
```
## Configuration

Both DNS and DHCP are configured in [config/dnsmasq.conf](config/dnsmasq.conf).
The DNS zone data is in [config/dnsmasq.hosts](config/dnsmasq.hosts).

## Running the image
For example:
```
docker run  --detach \
            --restart always \
            --network host \
            --cap-add NET_ADMIN \
            --cap-add NET_RAW \
            --name vmacsrv-dnsmasq \
            --hostname vmacsrv-dnsmasq \
            --env TZ=Europe/Berlin \
            --volume ./config/dnsmasq.conf:/etc/dnsmasq.conf:ro \
            --volume ./config/dnsmasq.hosts:/etc/dnsmasq.hosts:ro \
            --volume ./leases:/var/lib/dnsmasq \
            vmacsrv-dnsmasq:latest
```