# IP Router

**Important: Use this as a inspiration or starting point for your own setup. Adapt to your specific setup. YMMV**

For ip routing the host's Linux kernel is used.

The docker image just provides a minimal setup for forwarding/masquerading.
See also [networking.md](../networking.md)

## Building the image
For example by:
```
docker build -t vmacsrv-ip-router .
```
## Configuration

XXX

You might change these defaults by environment variables when starting the container: 
LAN_IF=${LAN_IF:-lan}
VINTAGELAN_IF=${VINTAGELAN_IF:-vintagehost_if}
ETHOUDP_IF=${ETHOUDP_IF:-ethoudp_tap}

XXX

## Running the image
For example by:
```
docker run  --detach \
            --restart always \
            --network host \
            --cap-add NET_ADMIN \
            --cap-add NET_RAW \
            --name vmacsrv-ip-router \
            --hostname vmacsrv-ip-router \
            --env TZ=Europe/Berlin \
            vmacsrv-ip-router:latest
```