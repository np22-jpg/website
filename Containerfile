FROM  quay.io/sclorg/nodejs-20-c9s@sha256:2265fa4dd7ad4f35d48c3a3a697d0ebb9bd64d96397b9d0e2a79f84b27ec8ab3 AS build

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