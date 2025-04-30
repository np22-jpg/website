FROM  quay.io/sclorg/nodejs-20-c9s@sha256:ee2b30f2b90d5abad8b531522e2dd0269517c0c5bd354e11f4b27198a4acec8c AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:92ba892b6e41a8e95a1d167b870281afd1c851a25073864198c9e00a8d73ec7b AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run