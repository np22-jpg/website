FROM  quay.io/sclorg/nodejs-20-c9s@sha256:cbd2bd9e061c15dcda83671abb7db567bd8dfabd516e2a5c04c38ce5e867bfd9 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:935ee18203a50c1a61e405ff91626c8a68daf15cb520ae8be714c5e343b34950 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run