FROM  quay.io/sclorg/nodejs-20-c9s@sha256:605d2477a7d7004f2a1a18581ac913515170d5ccb689e83fdc8655304c3e643a AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:7e15be9a1f00343822e4ab0617e4df4b97ba851302b41f899f8ccae74143cd8b AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run