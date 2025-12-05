FROM  quay.io/sclorg/nodejs-20-c9s@sha256:c3d5267520359a3c68d5a4b0a3f1e604ad3334bb4c02a51d17fe6942252308a1 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:9e112fc0fb822631ff3314fcda481e683417f3985af06b6492b6ae55127b6aee AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run