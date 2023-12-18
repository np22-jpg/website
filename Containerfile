FROM  quay.io/sclorg/nodejs-20-c9s@sha256:e63279b01fa149cfeb05cd3f49bf558df8a641bbeab1c3fc3b1c17425711ce68 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:2c71f05970676a37d36b6b1a9bc7709ccb0ad860bd355b8a9cc3cbe5784e7b99 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run