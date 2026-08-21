FROM  quay.io/sclorg/nodejs-20-c9s@sha256:60dc5b48884980386bf8b54f9ab4633a7953f60506467e4bd614ba8ecf2c33b5 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:a3880f4c12c6578ff6dd993e5e7ea7b44a92f497ca5e7faaf492520aac4546b9 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run