FROM  quay.io/sclorg/nodejs-20-c9s@sha256:cfca94e9ff11b9f9cd49120d0cc8a0c346fcfd4e254c55bce60e7b026ba764d9 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:9e5cb3714ee800d9409aa4f77f24620b498d14b33c9e7d26a896d0f39179fc0b AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run