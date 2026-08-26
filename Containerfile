FROM  quay.io/sclorg/nodejs-20-c9s@sha256:d47b375cd48b6febe6afe43d32f63e01f61ee9f327896de4dff4936d0ef9876a AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:315f12562130c922bfb47efb5d75e06b5a621f19e34fcc126e2398190097e700 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run