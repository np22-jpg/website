FROM  quay.io/sclorg/nodejs-20-c9s@sha256:530075841e1fe5353ff27fa6e5fac3b833767b3dfc03f9316db4246fa1b1e97e AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:ffa68c881002aca493da4ffbae47d3b3705d1004e83fb928b241d03ce8085ae8 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run