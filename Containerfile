FROM  quay.io/sclorg/nodejs-20-c9s@sha256:e619e247a37bb2ecaa883724a69ac65037c76bc497823ac2423f36af81663b67 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:f3d2f5b8fd1a2d61f7492f6b90ec094ae8295a7d5836d6a2b65b69fbc36a0e66 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run