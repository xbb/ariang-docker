FROM public.ecr.aws/docker/library/node:14 AS builder

ARG VERSION=1.2.3

RUN apt update && apt upgrade -y && \
    useradd -m builder

USER builder

WORKDIR /home/builder

RUN git clone --single-branch --depth 1 \
        --recurse-submodules --shallow-submodules \
        -b "${VERSION}" https://github.com/mayswind/AriaNg \
    && cd AriaNg \
    && npm install \
    && (npm audit || (npm audit fix --package-lock-only && (npm audit || true))) \
    && ./node_modules/.bin/gulp clean build

FROM quay.io/xbb/darkhttpd:1.13

COPY --from=builder /home/builder/AriaNg/dist/ /html
