FROM  quay.io/sclorg/nodejs-20-c9s@sha256:0264a897b0e5d606dbb18ff1cbac256dbb96039ab3a776c0a639904f987cfa73 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:1dea7b25b44281a707b5a4a9882c351e998bf5b74f296b90567bd86e26cc8c09 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run