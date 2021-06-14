FROM node:14-alpine AS build-stage

ARG VERSION=1.2.2

RUN set -xe \
    && apk add --no-cache git \
    && wget -O AriaNg.zip "https://github.com/mayswind/AriaNg/archive/${VERSION}.zip" \
    && unzip AriaNg.zip \
    && mv "AriaNg-${VERSION}" AriaNg \
    && node -v \
    && npm -v

COPY npm-shrinkwrap.json /AriaNg

WORKDIR /AriaNg

RUN set -xe \
    && npm install \
    && (npm audit || (npm audit fix --package-lock-only && (npm audit || true))) \
    && ./node_modules/.bin/gulp clean build

FROM xbblabs/darkhttpd:1.13

COPY --from=build-stage /AriaNg/dist/ /html
