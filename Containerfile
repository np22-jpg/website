FROM  quay.io/sclorg/nodejs-20-c9s@sha256:df73eb08d28bea7a5693507af01528584200a7126adc6083bdfb2ff652cb8047 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:6dcd3df290a6daf532740af945929b7c87b1207b5d51520e79e7356107e52def AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run