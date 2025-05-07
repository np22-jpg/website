FROM  quay.io/sclorg/nodejs-20-c9s@sha256:fcf0b5ce281fe5e5755049dbb08e3912853e95f2f80327771a27b7459957b4f4 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:ddd3652120a212be218671274839ea014654f96f58586ef25fcc10cc400430ce AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run