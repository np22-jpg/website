FROM  quay.io/sclorg/nodejs-20-c9s@sha256:e21fde8279d4e34b3e4bf1a9e62b869119d8bf01004a73b00836ade36f98dafe AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:fbe8114def99b93ef5db6adca17180f71adb684fc855541a0ba130fe5eb37cd1 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run