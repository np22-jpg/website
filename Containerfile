FROM  quay.io/sclorg/nodejs-20-c9s@sha256:c0b7c665d87264e8baf136a82b91f52e306e6ad0ba7d7cf7d50c66bc33b6d71b AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:6d8efa076b565f1563770095510af60d292864bab0f40bf2c1171fcac96b70f9 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run