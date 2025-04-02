FROM  quay.io/sclorg/nodejs-20-c9s@sha256:4dfe13112cb7f7e779628bbddd808098dfc98bd9cd3280858fcaf86be2029244 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:848d1baa379620f8d870b7c74a3af1e6684ada1d13c7fa9169b81eca6d620ac0 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run