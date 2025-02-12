FROM  quay.io/sclorg/nodejs-20-c9s@sha256:b92d9d7617496288676478e8a487126f50e3a6cf3da989e2e0e3c38edb4aa80e AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:0d66f8393150745078b0ce7ba53d0f507f274f8eea953d302985d1ef699d3513 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run