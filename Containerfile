FROM  quay.io/sclorg/nodejs-20-c9s@sha256:a1ab7d138cf07231e0e14a5ff44f3625dfa06ad02d4e3c267320afe00972c43b AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:2ba0a37e9e4bc4b5546196edf1ca3950c0dbaba5ad366de42b22f3f09d58100c AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run