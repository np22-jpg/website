FROM  quay.io/sclorg/nodejs-20-c9s@sha256:140d818af503783b953dc0b5a564c708c079d717021b1ac1d8f5e7a0f8f4740b AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:4ac75d8aba9b2a755cff7972eefd8a4140d05f6d52e991359c353041ce0312f6 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run