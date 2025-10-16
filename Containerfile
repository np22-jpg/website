FROM  quay.io/sclorg/nodejs-20-c9s@sha256:25e94e96920b669218aca52bd7e5b8faf67f8eb8ec946f6d13a8626301e5da35 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:463cdce4cf1b7ce9b6c491690eb2ec85c71517680ecaf261df8651a5f93ff4df AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run