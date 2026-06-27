FROM  quay.io/sclorg/nodejs-20-c9s@sha256:698ae7ec81ef13847cdf0e97860a80d00f8bd4904f1037233b392e972f2492da AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:2c7601130c452939e0d2410118e184135d2c4bec1425f36519e33a1288ac803e AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run