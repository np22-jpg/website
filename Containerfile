FROM  quay.io/sclorg/nodejs-20-c9s@sha256:b80662fedaf691096f45ee4d59fe136d482d10d3612e6ee6b7d23981710830d1 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:6d8efa076b565f1563770095510af60d292864bab0f40bf2c1171fcac96b70f9 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run