FROM  quay.io/sclorg/nodejs-20-c9s@sha256:de192d4f305889338808c01cad0938df39fabfca0c7aac863c950d3046582915 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:8c0bd6c6d2106d74874a6353f391c71938bf5edbf4f36d15b263546904c1a0f4 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run