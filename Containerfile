FROM  quay.io/sclorg/nodejs-20-c9s@sha256:55b747901a5f99d8d96b381009d159902022767214c8217e3ff3c685793a7cab AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:2236f6b6b65ea5951cd999d4bc23ac614eafea5cd517f550adfeaba43ae4f0f1 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run