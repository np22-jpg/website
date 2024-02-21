FROM  quay.io/sclorg/nodejs-20-c9s@sha256:e9ceaac6570fb048afd13e1e5215f808e8d83f688df9bb05a8b0086e539eb047 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:528e0efdade1f78d66364ac2b3d5fa36a4b71f2b5f62e92da310e612214ebfba AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run