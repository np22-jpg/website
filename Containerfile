FROM  quay.io/sclorg/nodejs-20-c9s@sha256:6297f057bd2eaa365d7715530d68366ec2e94aabce9cc969e027b5c387b44297 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:f473fd2b4b8c0c418c67685335d212614b30b705486f81ad46e5b0115a20c7ab AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run