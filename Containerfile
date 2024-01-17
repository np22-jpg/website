FROM  quay.io/sclorg/nodejs-20-c9s@sha256:1655e12813667062152b4ac0cf36c6a46a482833b6e24ce4f80cda1c505bf03d AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:066103de898363634a8164a49e5919e90c38e033b17c205f72f39c678adeea6c AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run