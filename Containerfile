FROM  quay.io/sclorg/nodejs-20-c9s@sha256:127fec1a2dc6f8888c4dd3e968b6ed1614d8cca88dd829b7d3314aa9cd493553 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:c35de63b09211950166cc442d7da9900ad82f85a892fbdd47d8578952d3de4ed AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run