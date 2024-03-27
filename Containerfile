FROM  quay.io/sclorg/nodejs-20-c9s@sha256:ab786b6f252b24c23820da981cea0c8b35e65cb2fb4e64bb498397d78ffcf8c8 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:ad5101c4bc87a792b33e0b1482f4683b6f3463dad3f44a7d459d3038668905df AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run