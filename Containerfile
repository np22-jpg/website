FROM  quay.io/sclorg/nodejs-20-c9s@sha256:cb57363f86cc5c7473d4f54b4d3a110e06aab85f2ab3651225ac4f08dd4813fd AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:2fceb0b0c8a35f693b861a013dc481452831bc4c201663811f7c1dcc65d530d8 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run