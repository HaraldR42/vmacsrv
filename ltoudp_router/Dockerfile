FROM python:alpine

RUN apk update && apk add --no-cache git bash socat

# upgrade pip to avoid warnings during the docker build
RUN     pip install --root-user-action=ignore --upgrade pip \
    &&  pip install --root-user-action=ignore --no-cache-dir pyserial

WORKDIR /app

# Force invalidating the cache before git clone
ARG BUILD_DATE=-1
RUN echo "$BUILD_DATE"

RUN git clone --branch main https://github.com/lampmerchant/tashrouter.git
RUN mv tashrouter git-src \
  && ln -s git-src/tashrouter tashrouter

COPY src/* ./

ENTRYPOINT [ "./run-container.sh" ]
