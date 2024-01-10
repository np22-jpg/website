FROM  quay.io/sclorg/nodejs-20-c9s@sha256:2265fa4dd7ad4f35d48c3a3a697d0ebb9bd64d96397b9d0e2a79f84b27ec8ab3 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:90cdf8d3e7bc2b451ba0dcb58175f460235cd47d6d671e44bd8ab86b946d52f2 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run