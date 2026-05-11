# Netatalk AFP File Server and AppleTalk router

**Important: Use this as a inspiration or starting point for your own setup. Adapt to your specific setup. YMMV**

For file service and AppleTalk (Ethernet) routing [netatalk](https://netatalk.io) is used.

AFP file service works **both** over AppleTalk and TCP/IP!

*Hint: Do not use netatalk 3.x because there AppleTalk was removed. The project re-introduced it in version 4.x! This container uses 4.x .*

## Building the image
For example by:
```
docker build -t vmacsrv-netatalk:latest .
```
## Configuration

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

## Running the image
For example by:
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
            vmacsrv-netatalk:latest
```