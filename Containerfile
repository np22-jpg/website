FROM  quay.io/sclorg/nodejs-20-c9s@sha256:b4356e77651f89db91cb88c3854e0c956d41cb798021f4b7d1aab1a492d19b26 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:7bc455ab6491d640a5eac0cce26638bcbd25d962d19a485f7f994ecaf5ac4153 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run