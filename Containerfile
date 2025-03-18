FROM  quay.io/sclorg/nodejs-20-c9s@sha256:a3b5cce75a52d2c08326556f6a832abcfbafab3b6444713e8a85f0e3bd63c9af AS build

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