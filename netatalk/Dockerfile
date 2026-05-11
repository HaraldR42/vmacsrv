FROM debian:trixie-slim

RUN     apt update -y \
     && apt upgrade -y \
     && apt install -y bash netatalk

WORKDIR /app

COPY src/* ./

ENTRYPOINT [ "./run-container.sh" ]
