FROM  quay.io/sclorg/nodejs-20-c9s@sha256:a40601e7c1842e8fbac734ef478c1a768742f259a1f1ced3f12be6a560f26cfe AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:8232bf8c5950140343c9e5eeabaf5c46c8475115af9a61a0afb72c417c6a88b3 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run