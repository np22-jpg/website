FROM  quay.io/sclorg/nodejs-20-c9s@sha256:77dfc06487f4427fce30f945cbf7e01b62fb19da45d3a2cebae047bd529b5332 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:31b5c11e70957e2e6eb32c0c1f9ba5c2ce8cff105aa23a99b946fa4242d15178 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run