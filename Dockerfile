FROM python:3.8-alpine
LABEL maintainer="Spielage Software <dev@spiegale.com>"

ENV PYTHONUNBUFFERED 1

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
COPY ./mycert.crt /usr/local/share/ca-certificates/mycert.crt
RUN update-ca-certificates

COPY ./requirments.txt /requirments.txt
RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev
RUN pip install -r /requirments.txt
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN adduser -D user
USER user