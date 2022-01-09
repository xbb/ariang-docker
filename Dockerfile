FROM public.ecr.aws/docker/library/node:14-alpine AS builder

ARG VERSION=1.2.2

COPY npm-shrinkwrap.json /npm-shrinkwrap.json

RUN apk add --upgrade --no-cache git \
    && git clone --single-branch --depth 1 \
        --recurse-submodules --shallow-submodules \
        -b "${VERSION}" https://github.com/mayswind/AriaNg \
    && cd AriaNg \
    && ln -s /npm-shrinkwrap.json \
    && npm install \
    && (npm audit || (npm audit fix --package-lock-only && (npm audit || true))) \
    && ./node_modules/.bin/gulp clean build

FROM quay.io/xbb/darkhttpd:1.13

COPY --from=builder /AriaNg/dist/ /html
