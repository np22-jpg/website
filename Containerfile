FROM  quay.io/sclorg/nodejs-20-c9s@sha256:2115102e482971b7d95e65087859f1d7dbc506183f51254894b381a356b54e19 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:98ec07221c704196bb487ab4d8cc90bba51c20ecaa8bfb2e51cebd2485fb4081 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run