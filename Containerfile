FROM  quay.io/sclorg/nodejs-20-c9s@sha256:dee4e3553c8b872a8ff0497b9742bf8e3cf80c8485510d0c6ed1579008cca34f AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:e47bc640e8c940701dba3107f53087022d864a03c88dec81d44c018f7de1f778 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run