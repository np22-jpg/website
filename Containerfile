FROM  quay.io/sclorg/nodejs-20-c9s@sha256:918f413cb9758df8738f8b4615dffbf59f0d4d10ed9afd32f741645d062a9fe1 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:bccb3a09d4840797e7a3831676d209427a6322c1b456823676578fd04da4111d AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run