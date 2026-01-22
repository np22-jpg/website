FROM  quay.io/sclorg/nodejs-20-c9s@sha256:3d86e7aea718fcbaf38a4a16b9b95437a1bb679211791a99dee1a9ee72d4aa88 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:cea0fea75726d75f139b931341aa2bdbf80260c95e485493d94362586827b9b3 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run