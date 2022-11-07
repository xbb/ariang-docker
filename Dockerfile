FROM node:14 AS builder

ARG VERSION=1.3.0

RUN apt update && apt upgrade -y && \
    useradd -m builder

USER builder

WORKDIR /home/builder

RUN git clone --single-branch --depth 1 \
        --recurse-submodules --shallow-submodules \
        -b "${VERSION}" https://github.com/mayswind/AriaNg \
    && cd AriaNg \
    && sed -i -E 's/"git:/"git+https:/' package.json package-lock.json \
    && npm install \
    && npx gulp clean build

FROM quay.io/xbb/darkhttpd:1.14

COPY --from=builder /home/builder/AriaNg/dist/ /html
