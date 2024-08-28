FROM  quay.io/sclorg/nodejs-20-c9s@sha256:6297f057bd2eaa365d7715530d68366ec2e94aabce9cc969e027b5c387b44297 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:c9be51076c5c8779c415e45e1df15bc1205cdae9b8d66d5d1c9929b6ed32cfd4 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run