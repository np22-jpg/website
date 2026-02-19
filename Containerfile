FROM  quay.io/sclorg/nodejs-20-c9s@sha256:b44e82ba241fccaadf1205bb71881c2c5936f9cc27ba555b332924e5bb3cce66 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:f7be28adda9be08eec0db4238cc66caf50184b6dc74b00fb3bf9a8746f476894 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run