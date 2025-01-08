FROM  quay.io/sclorg/nodejs-20-c9s@sha256:9ff84fb6eb5322f1562dd915cffa3123013755208e30117a96654824967e4c4c AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:d6fc49904e65a7ceb0f10f33c9ad63c89215c855bb1c38427191e3ad38202ca2 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run