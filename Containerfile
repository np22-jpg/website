FROM  quay.io/sclorg/nodejs-20-c9s@sha256:9da898dc70f852105445219f4119ab7d2819a2e31b08b023e96f9d02ccc496db AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:58ef382eea3a8f59c5d11b31e749ecb5a00edfbe9c8255cc3f79576385917ff1 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run