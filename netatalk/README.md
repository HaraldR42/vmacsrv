# Netatalk AFP File Server and AppleTalk router

**Important: Use this as a inspiration or starting point for your own setup. Adapt to your specific setup. YMMV**

For file service and AppleTalk (Ethernet) routing, [Netatalk](https://netatalk.io) is used.

AFP file service works **both** over AppleTalk and IP!

*Hint: Do not use Netatalk 3.x because AppleTalk support was removed; the project reintroduced it in version 4.x. This container uses Netatalk 4.x.*

## Building the image
For example:
```
docker build -t vmacsrv-netatalk:latest .
```
## Configuration

EtherTalk routing is configured in [config/atalkd.conf](config/atalkd.conf). File services are configured in [config/afp.conf](config/afp.conf).
The docker script creates a user with:
- Login: afpuser
- Password: afpuser
- UID/GID: 9999/9999

You might change these defaults by environment variables when starting the container: 

| Env variable | Default |
|--------------|---------|
| `AFP_USER` | afpuser |
| `AFP_PASS` | afpuser |
| `AFP_UID` | 9999 |
| `AFP_GROUP` | afpgroup |
| `AFP_GID` | 9999 |

## Running the image
For example:
```
docker run  --detach \
            --restart always \
            --network host \
            --cap-add NET_ADMIN \
            --cap-add NET_RAW \
            --name vmacsrv-netatalk \
            --hostname vmacsrv-netatalk \
            --env TZ=Europe/Berlin \
            --volume /var/run/dbus:/var/run/dbus \
            --volume ./config:/etc/netatalk \
            --volume ./dbase:/var/local/netatalk \
            --volume ./volumes/data:/mnt/data \
            --volume ./volumes/software:/mnt/software \
            --dns 172.29.60.1 \
            vmacsrv-netatalk:latest
```