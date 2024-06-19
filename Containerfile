FROM  quay.io/sclorg/nodejs-20-c9s@sha256:52d38889d907c5d9aabe8e86dec06b11685b6e59799091a5459e566b1f0ecf27 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:37bf071e79024305a59704ec59bae7037d47e7396ca91cb667b7bbccaf0fc09f AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run