FROM  quay.io/sclorg/nodejs-20-c9s@sha256:c30181e15711db702efe2d64d0b9995a31379520c8d031ffee21d228a3c20af6 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:fe29e724de8490f84e960f0cfd8a657d430e3119059529a25fb6526b9eba5c24 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run