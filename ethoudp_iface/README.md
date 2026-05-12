# Ethernet-over-UDP interface

**Important: Use this as a inspiration or starting point for your own setup. Adapt to your specific setup. YMMV**

For interfacing with SheepShaver/Basilisk II 's udptunnel [ethoudp_iface](https://github.com/HaraldR42/ethoudp_iface) is used.

## Building the image
For example:
```
docker build -t vmacsrv-ethoudp-if .
```
## Configuration

The example below uses the right settngs for the server setup described here.

For further details, see [ethoudp_iface](https://github.com/HaraldR42/ethoudp_iface).

## Running the image
For example:
```
docker run  --detach \
            --restart always \
            --network host \
            --cap-add NET_ADMIN \
            --cap-add NET_RAW \
            --name vmacsrv-ethoudp-if \
            --hostname vmacsrv-ethoudp-if \
            --env TZ=Europe/Berlin \
			--env TAP_IFACE=ethoudp_tap \
			--env BCAST_IFACE=lan \
            vmacsrv-ethoudp-if:latest
```