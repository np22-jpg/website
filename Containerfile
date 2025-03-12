FROM  quay.io/sclorg/nodejs-20-c9s@sha256:caa017f84aeb7235c12395fe76728222b38116e783ad1b1e0c75e5b51b21e8e0 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:ef64b21a01f6720aab992b4244ad81eef2e51c830f3debca3afad18261ebee34 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run