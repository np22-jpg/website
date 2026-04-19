FROM  quay.io/sclorg/nodejs-20-c9s@sha256:5dce54e622dd8deb707f424959c3862a49b2875eaf0cd675965baed76185e624 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:e576e584bd5d04cbba14b838b589dc250fabfb4053b4f3d2b87dcc59e6cefc3b AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run