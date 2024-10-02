FROM  quay.io/sclorg/nodejs-20-c9s@sha256:bb4fe56f37b2e4b974126cec9fcbf5ba1a3906c1cf4b5058f6097217dfed1414 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:452ddd5a5723a8cb589dacce120df6e7a18e95628c15752cebf9d373198d24c1 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run