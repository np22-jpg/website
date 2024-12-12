FROM  quay.io/sclorg/nodejs-20-c9s@sha256:b7d0553c51881f1a9716442da476be26d834a3d2586c327249a8fec6cc0e813d AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:973626e91f6270421cb9872ffc820e9e3e1d6961219dbee174258e590666625d AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run