FROM  quay.io/sclorg/nodejs-20-c9s@sha256:2c5da3ff073cedc6926c06c91e4e722fb6cc0a35f1764959c5987334f67a2fd8 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:0be37d02205adb7d71cd8fd1d3ff9225e87fdf85ff75e00434bfaadaaa65d445 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run