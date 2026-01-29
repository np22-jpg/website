FROM  quay.io/sclorg/nodejs-20-c9s@sha256:a192c60d3d8bf54c8becb4df30a784852a20a12779d1abca76843675e15af6f0 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:ccbb2d2cabf8928ab9a00dd3278fcc9c8145bf99661d27a99d531be8af00a6bd AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run