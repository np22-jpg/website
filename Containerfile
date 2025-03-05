FROM  quay.io/sclorg/nodejs-20-c9s@sha256:80e7106bc12befa0881550a58a919860cee98b3c35f4a58bf41da9e442348e03 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:ec6e063e86cda4f083d62ee56f77db3aaf0c741d556d2b3844c44858dcb3022e AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run