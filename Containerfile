FROM  quay.io/sclorg/nodejs-20-c9s@sha256:4b6e4919a58eb2fa4bbcca5c42edb0df54e37eec04048bcf8f43a840c5fde947 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:f258fc814342da2f527ac541ae2bb6c7e523861799307e343033f60fa9c3399a AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run