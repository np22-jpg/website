FROM  quay.io/sclorg/nodejs-20-c9s@sha256:0f8a4a1aa343029842423c202d728e7b2064df164b94c80095fea36e851100e5 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:5bb2e77d709935ad0de845dece7e7d27a1003babdd2c82d30da91a4b66bc13e2 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run