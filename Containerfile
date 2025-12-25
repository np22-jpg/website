FROM  quay.io/sclorg/nodejs-20-c9s@sha256:df73eb08d28bea7a5693507af01528584200a7126adc6083bdfb2ff652cb8047 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:b95eb8f5d2634d610069c462e39acd978722d9550c85488ae12988c2f145e4c1 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run