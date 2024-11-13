FROM  quay.io/sclorg/nodejs-20-c9s@sha256:8ca4f074f83adeb7cfa6f2da8466f428f3479efcb94ae9eb00b242f9aa24e237 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:3b77f7a31438f0b49e15bb9efffc948e78734e86dd3da199f6d6bab3311bb5d2 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run