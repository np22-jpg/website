FROM  quay.io/sclorg/nodejs-20-c9s@sha256:8f89e051b35a9acef5f4b180a7ebf5921c7e51f9f6f3a9694551f7401ea77394 AS build

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