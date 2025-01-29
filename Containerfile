FROM  quay.io/sclorg/nodejs-20-c9s@sha256:bbc90a422b98273cc0c65db7718fbbbe9e1f96e312019138ee828d5981cbf5f5 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:e1148288c8120177a5bdb1097295b58c5db7d7ed2092b820ee6c2c3a66a9e38c AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run