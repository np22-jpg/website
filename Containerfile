FROM  quay.io/sclorg/nodejs-20-c9s@sha256:5d5ae04b5c26051506f6d82784fbe285d7b8263f4f3e77b33a60c3a6b715c444 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:7a33fab3c7cd16dbf531414b654a3ac8ba3c071b44140ca34af12dddb4125665 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run