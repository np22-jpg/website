FROM  quay.io/sclorg/nodejs-20-c9s@sha256:3b83c2b9a2a4454669f9fd59c57871d47009849bbcaa2130c462ecbac79e670b AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:512f99877e4309e652cffb05f317d235ab950862c7083d7ae2c89a709268a25f AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run