FROM  quay.io/sclorg/nodejs-20-c9s@sha256:d47b375cd48b6febe6afe43d32f63e01f61ee9f327896de4dff4936d0ef9876a AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:a8f8f9f35c35c9ea98dcc440db0aa269c50602395e6e254a47262e2207112227 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run