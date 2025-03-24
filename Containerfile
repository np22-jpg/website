FROM  quay.io/sclorg/nodejs-20-c9s@sha256:d2629c2fd7a9fb727dda696a93130f3f3ec8f3cdd50e313db61c039be150c029 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:56ad77b97a6a3314022eae66e106cb00f8bd1b8ebb6eb9e4b1498967663a2c30 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run