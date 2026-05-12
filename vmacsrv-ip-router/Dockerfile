FROM debian:trixie-slim

RUN     apt update -y \
     && apt upgrade -y \
     && apt install -y bash vim jq iproute2 iptables

WORKDIR /app

COPY src/* ./

ENTRYPOINT [ "./vmacsrv-ip-router.sh" ]
