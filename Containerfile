FROM  quay.io/sclorg/nodejs-20-c9s@sha256:c3d5267520359a3c68d5a4b0a3f1e604ad3334bb4c02a51d17fe6942252308a1 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:eece92b4c9138acb1084648ed95f5f60b92e4c33488bd9e83c157c2b6e6f5ec9 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run