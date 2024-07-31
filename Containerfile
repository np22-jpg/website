FROM  quay.io/sclorg/nodejs-20-c9s@sha256:d4a29228d455e8a0f2bbe6c647d4f2ed516598717f2c42f227800ce1266b2f10 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:9844fa8835a9d5310c14f74f804dfb4cc24bb9d2bfd5d8338fea0128971e59ab AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run