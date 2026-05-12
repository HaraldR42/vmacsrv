FROM python:alpine

RUN apk update && apk add --no-cache git bash

WORKDIR /app

RUN git clone --branch main https://github.com/HaraldR42/ethoudp_iface.git .

ENTRYPOINT ["python3", "-u", "ethoudp_iface.py"]

