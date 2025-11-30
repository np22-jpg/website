FROM  quay.io/sclorg/nodejs-20-c9s@sha256:4cd0b8f3a0554f39ff25e555c96c09809a171a759621bd082fba6a51c333a0cc AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:b275d94b6c61c3966209400e154a04500519da7476ea2b9b47cfebf5808ebb09 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run