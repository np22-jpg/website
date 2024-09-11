FROM  quay.io/sclorg/nodejs-20-c9s@sha256:0f387514f00af0ac08f4281a7a1457623dbb3533d50eee7451ec928347df476c AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:6fba33f37c1040b305034dc457c602fee27c2eda5cdfc0dc552cb02537d9e761 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run