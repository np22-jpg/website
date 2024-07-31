FROM  quay.io/sclorg/nodejs-20-c9s@sha256:d4a29228d455e8a0f2bbe6c647d4f2ed516598717f2c42f227800ce1266b2f10 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:449eaff7b71cde6a816517aee89e7f0f8717a3bc886f943c66a46451682e6153 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run