FROM  quay.io/sclorg/nodejs-20-c9s@sha256:bd11756fff3d0be8a4ce21e61389b5fbd9e7500f1c745747502010ed616ace71 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:f473fd2b4b8c0c418c67685335d212614b30b705486f81ad46e5b0115a20c7ab AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run