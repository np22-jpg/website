FROM  quay.io/sclorg/nodejs-20-c9s@sha256:4df3f1743485a3e6a9f9b226a49954dd6c88bc20af173073f976868642b24b18 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:a1518ea1add9590d0b4d814ebc9d341db86f91c4ab9d0016a28cca1a48cff02f AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run