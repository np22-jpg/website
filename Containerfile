FROM  quay.io/sclorg/nodejs-20-c9s@sha256:fa3a415d34fc554ba2c34f9ebac004a15077359fb0bca1729642006ba3a58885 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:3aaf26294a88c746193e63d6eea406c6cee08dcc086462df7e931e2c5b5c1d6d AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run