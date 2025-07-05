FROM  quay.io/sclorg/nodejs-20-c9s@sha256:0046791c436b6d5c40720d9ca0fdc0de267550af991fd6f05bf96767d24c3a66 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:61e5107ac30b610bd555becf8104f0e1816e6ddf007472ec8926b835838f6251 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run