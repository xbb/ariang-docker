FROM node:18 AS builder

ARG VERSION=1.3.3

RUN apt update && apt upgrade -y && \
    useradd -m builder

USER builder

WORKDIR /home/builder

RUN git clone --single-branch --depth 1 \
        --recurse-submodules --shallow-submodules \
        -b "${VERSION}" https://github.com/mayswind/AriaNg \
    && cd AriaNg \
    && npm install \
    && npx gulp clean build

FROM quay.io/xbb/darkhttpd:1.14

COPY --from=builder /home/builder/AriaNg/dist/ /html
