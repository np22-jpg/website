FROM  quay.io/sclorg/nodejs-20-c9s@sha256:4fb4597023510d4392b73cbe94964754cf7e16e05301cbd62e773b95e4c07dd1 AS build

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