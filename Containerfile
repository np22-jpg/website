FROM  quay.io/sclorg/nodejs-20-c9s@sha256:f3d678e1c95a9dc2704f9a85274d47c9e61ad96f3a201e05a1106a60cf87b854 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:162cc481dd9c757e1285821ff83d736c1bc2feacf9d52cb47a5a5e893049a318 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run