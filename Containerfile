FROM  quay.io/sclorg/nodejs-20-c9s@sha256:74c44779e66420cae5efe03cbb24156407b1da6acdb36811ac819d867b22a0c9 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:2d76d3e588dea5577c60f4471c969b9e6abddfb84bd4a80d5abb046a27a0617e AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run