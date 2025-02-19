FROM  quay.io/sclorg/nodejs-20-c9s@sha256:cfca94e9ff11b9f9cd49120d0cc8a0c346fcfd4e254c55bce60e7b026ba764d9 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:b25063fec538477e0234b990620dde815444e0eceda8f9f56fcf421debda8248 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run