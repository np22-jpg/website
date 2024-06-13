FROM  quay.io/sclorg/nodejs-20-c9s@sha256:a3a7d2953a29262cc3d6ed9ff18eb4983067985636c7f21b179e95b063e923ef AS build

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