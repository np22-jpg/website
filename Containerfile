FROM  quay.io/sclorg/nodejs-20-c9s@sha256:ddce9bee1670f0f98e1f64c84023d38a996c211bc41d731c4faf86c5a04a7275 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:1500fc3e489963bc84cf69c6b7118cabf05e5b957858cf02d61ead683072f266 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run