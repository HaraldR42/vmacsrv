# LocalTalk over UDP router

**Important: Use this as a inspiration or starting point for your own setup. Adapt to your specific setup. YMMV**

For LocalTalk-to-EtherTalk routing [TashRouter](https://github.com/lampmerchant/tashrouter/tree/main) is used.

On the LocalTalk side, currently only [LocalTalk over UDP](https://web.archive.org/web/20260102054321/https://windswept.home.blog/2019/12/10/localtalk-over-udp/) is supported.
Please see [TashRouter](https://github.com/lampmerchant/tashrouter/tree/main) for how to adapt the Python script to support [TashTalk](https://github.com/lampmerchant/tashtalk).

## Building the image
For example:
```
docker build -t vmacsrv-ltoudp-rt:latest .
```
## Configuration

You might change the container's defaults by environment variables when starting the container: 

| Env variable | Default |
|--------------|---------|
| `TAP_IFACE` | ltoudp_tap |
| `LTOUDP_ZONE` | LToUDP zone |
| `LTOUDP_NET` | 62 |


## Running the image
For example:
```
docker run  --detach \
            --restart always \
            --network host \
            --cap-add NET_ADMIN \
            --cap-add NET_RAW \
            --name vmacsrv-ltoudp-rt \
            --hostname vmacsrv-ltoudp-rt \
            --device /dev/net/tun \
            --env TZ=Europe/Berlin \
            vmacsrv-ltoudp-rt:latest
```
