FROM  quay.io/sclorg/nodejs-20-c9s@sha256:2b473a7c7fab09519c3b8295775f01c9f3141956f35b3ca9f91936c8a6082052 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:75c0ce0bf5ee4fa2a701517144dd0eaee5737e7b141c8608944ce0623625675b AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run