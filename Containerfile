FROM  quay.io/sclorg/nodejs-20-c9s@sha256:1cd07f35d16ff0940b2916a75d0f8e80c29d5bb3a8f1712912b22f9c8c7500b6 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:af0bb59d601b8ed038ea9cb8b171e26ee14998aabd5d77e7f6618b6394490355 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run