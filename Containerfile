FROM  quay.io/sclorg/nodejs-20-c9s@sha256:15de34550ed4c48f202f8a5371575070472fb748aaab1e825b86cab3d4d3ba73 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:35cc3772bbf30874739717304edc0fa25b6d26bf5eb9ce109731277e945ebee3 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run