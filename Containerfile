FROM  quay.io/sclorg/nodejs-20-c9s@sha256:2662a942299eafe7b4664891e1796436e3c9ec40715f7061da3d4d9cf37c3642 AS build

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