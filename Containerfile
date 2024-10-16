FROM  quay.io/sclorg/nodejs-20-c9s@sha256:94b43f82bb9a0b39447e101baa2fbe2bac5202c49f5b84f938d2e903623f240e AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:427f638f35c494d2d929834f29308e9a2e50f196c9edbd094f44d53f3f5510f8 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run