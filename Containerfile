FROM  quay.io/sclorg/nodejs-20-c9s@sha256:ac9e9d0e5d459376e769b9ae8365fed77a74c867b6e0c2822ef5262b689dada4 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:ba7ffe32d5335a405a53afcc1ff16493026e49c8ed8e2e0947587f3ffa189921 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run