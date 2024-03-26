FROM  quay.io/sclorg/nodejs-20-c9s@sha256:9deed70c39fa2f945ab43fb8b7f3033745aa2b6c751146f83cc029daceaecc62 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:409e97bfa8c7c0ebbf83762a3b17a5ea795c7ad33bcfe1ee89ce4c91cd66a534 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run