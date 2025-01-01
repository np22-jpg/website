FROM  quay.io/sclorg/nodejs-20-c9s@sha256:43c10d280399c0b8b7fe8c23977693fa2427bd4cba92ce158bbd77f2556b93fd AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:e4dcc97017be905bd92d6ced2070d1323e6d1b63a8aa798e72185d6f7762c03b AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run