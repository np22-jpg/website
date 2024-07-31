FROM  quay.io/sclorg/nodejs-20-c9s@sha256:dab18c488bb953621c23129c55f7c984b0020118ab8907b5d205f1c77e4cb8f0 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:449eaff7b71cde6a816517aee89e7f0f8717a3bc886f943c66a46451682e6153 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run