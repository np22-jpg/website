FROM  quay.io/sclorg/nodejs-20-c9s@sha256:e619e247a37bb2ecaa883724a69ac65037c76bc497823ac2423f36af81663b67 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:0e58602c3c79b9e67626a88b6d4e2e813c9b50db7995341b0b1c2de8637b3959 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run