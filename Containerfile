FROM  quay.io/sclorg/nodejs-20-c9s@sha256:7e234584719a7a9e3c1c945285c45fd96e67da3b1201fde15bb3f3f1b47a4b65 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:28319e9a468c105ff4dae8d4a24e3f8d41e6005c74f45a38b23141843a73ac47 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run