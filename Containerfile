FROM  quay.io/sclorg/nodejs-20-c9s@sha256:2e910446c922a0949be93d2c5756285257ff67db00f83d1918268c564fbc3b02 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:c5f505cec0a250e5537d5756207257f88b5b462ee6a597f9334224dd0e8bc097 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run