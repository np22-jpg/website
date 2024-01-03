FROM  quay.io/sclorg/nodejs-20-c9s@sha256:0807440859f8c46de47a304f03e579eeb97272fd630c92d9695a2fdfb46da7d8 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:b6bd662b5115a21d888ae42c925c99860e73f04095f16216f2a0aaf31ebc77f4 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run