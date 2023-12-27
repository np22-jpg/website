FROM  quay.io/sclorg/nodejs-20-c9s@sha256:0807440859f8c46de47a304f03e579eeb97272fd630c92d9695a2fdfb46da7d8 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:bd8e6afaa7a0b3c667a92c50d8fefaf0ce69ad47195eb7e48c637dcf9005c1e1 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run