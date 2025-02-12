FROM  quay.io/sclorg/nodejs-20-c9s@sha256:a2a5c0e89f5d1dbff5d6aac8f0270ffd49a8e7578d13a8cc2fb3a689b9081006 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:0d66f8393150745078b0ce7ba53d0f507f274f8eea953d302985d1ef699d3513 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run