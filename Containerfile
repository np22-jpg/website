FROM  quay.io/sclorg/nodejs-20-c9s@sha256:9bedd7cb574aa557755a2435ecf0bd15c093af40b1138afcf7dd53d9be0ae13c AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:0c2d351574ce2dbced1f753de32cee90f35a997b6934e85de0d7f4dbd9127b8f AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run