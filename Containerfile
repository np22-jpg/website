FROM  quay.io/sclorg/nodejs-20-c9s@sha256:f43282b46cf5d2596c5ac0faab31c09824c36f020805615d287bf3276d804f70 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:4d4d8d149e4e195f44264cbbf6952d1149d5906df4690b4aefcdafbf04f524ae AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run