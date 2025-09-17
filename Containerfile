FROM  quay.io/sclorg/nodejs-20-c9s@sha256:935db93a331df250b75dd9385933ece792920b25027d03c7318a940a2789839a AS build

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