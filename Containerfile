FROM  quay.io/sclorg/nodejs-20-c9s@sha256:3fb57e72abccc6c3097c894bb5e1845c232626cc589ba2acdb7736d4e7ba2448 AS build

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