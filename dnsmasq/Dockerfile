FROM alpine:latest
RUN apk add --no-cache dnsmasq
RUN mkdir -p /var/lib/dnsmasq
ENTRYPOINT ["dnsmasq", "--no-daemon", "--log-facility=-"]
