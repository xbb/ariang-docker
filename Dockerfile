FROM node:lts AS builder

ARG VERSION=1.3.11

RUN useradd -m builder

USER builder

WORKDIR /home/builder

RUN git clone --single-branch --depth 1 \
        --recurse-submodules --shallow-submodules \
        -b "${VERSION}" https://github.com/mayswind/AriaNg

RUN cd AriaNg \
    && npm ci --only=production \
    && bash -c 'npm audit fix || true' \
    && npx gulp clean build

FROM quay.io/xbb/darkhttpd:1.17

COPY --from=builder /home/builder/AriaNg/dist/ /html
