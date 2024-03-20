FROM  quay.io/sclorg/nodejs-20-c9s@sha256:b5fe5ca42bbce8ba939c6439625203f857f9f80ab3c978af75cfc444fe669568 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:e8d43d2854aac6e3543e65f76b5b06752f6e5a0e7b0a1b5a55904b38a076a1be AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run