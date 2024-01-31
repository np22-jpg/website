FROM  quay.io/sclorg/nodejs-20-c9s@sha256:8af4269c30b5be7a9b33de0b6bf02de0f42fdecc68d6625702b9ea91467142c4 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:939e868be3f6086f99f76759710f0f561c83ff6387777ee0cec7e6d30f3a84e8 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run