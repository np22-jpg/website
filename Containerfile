FROM  quay.io/sclorg/nodejs-20-c9s@sha256:ae7b79ac83b5504771d55d579a6212f8ac46a249854d9259a7387039398f233d AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:35eb17bf9b56cad1d466ac3aedfeadc521a90969a740ba4e041f488e6e2a0cee AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run