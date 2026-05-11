# LocalTalk over UDP router

**Important: Use this as a inspiration or starting point for your own setup. Adapt to your specific setup. YMMV**

For LocalTalk to EtherTalk routing [TashRouter](https://github.com/lampmerchant/tashrouter/tree/main) is used.

On the LocalTalk side, currently only [LocalTalk over UDP](https://web.archive.org/web/20260102054321/https://windswept.home.blog/2019/12/10/localtalk-over-udp/) is supported.<br>
Please see [TashRouter](https://github.com/lampmerchant/tashrouter/tree/main) how to adapt the python script [XXX](XXX) accordingly to support [TashTalk](https://github.com/lampmerchant/tashtalk).

## Building the image
For example by:
```
docker build -t vmacsrv-ltoudp-rt:latest .
```
## Configuration

usage: ltoudp_router.py [-h] [--tap-iface VALUE] [--ltoudp-zone VALUE] [--ltoudp-net VALUE]

LToUDP router configuration

options:
  -h, --help           show this help message and exit
  --tap-iface VALUE    LToUDP TAP interface name [env: TAP_IFACE] (default: 'ltoudp_tap')
  --ltoudp-zone VALUE  LToUDP network zone name [env: LTOUDP_ZONE] (default: 'LToUDP zone')
  --ltoudp-net VALUE   LToUDP seed network number [env: LTOUDP_NET] (default: 62)


EtherTalk routing is configured in [config/atalkd.conf](config/atalkd.conf)<BR/>
File service are configured in [config/afp.conf](config/afp.conf) <BR/>
The docker script creates a user with:
- Login: afpuser
- Password: afpuser
- UID/GID: 9999/9999

You might change these defaults by environment variables when starting the container: 
- `AFP_USER`
- `AFP_PASS`
- `AFP_UID`
- `AFP_GROUP`
- `AFP_GID`

XXXX

  -h, --help           show this help message and exit
  --tap-iface VALUE    LToUDP TAP interface name [env: TAP_IFACE] (default: 'ltoudp_tap')
  --ltoudp-zone VALUE  LToUDP network zone name [env: LTOUDP_ZONE] (default: 'LToUDP zone')
  --ltoudp-net VALUE   LToUDP seed network number [env: LTOUDP_NET] (default: 62)

## Running the image
For example by:
```
docker run  --detach \
            --restart always \
            --network host \
            --cap-add NET_ADMIN \
            --cap-add NET_RAW \
            --name vmacsrv-ltoudp-rt \
            --hostname vmacsrv-ltoudp-rt \
            --env TZ=Europe/Berlin \
            vmacsrv-ltoudp-rt:latest
```