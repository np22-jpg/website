FROM  quay.io/sclorg/nodejs-20-c9s@sha256:f3d678e1c95a9dc2704f9a85274d47c9e61ad96f3a201e05a1106a60cf87b854 AS build

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