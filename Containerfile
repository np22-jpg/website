FROM  quay.io/sclorg/nodejs-20-c9s@sha256:ff4a23013add976d58dd31265013a5d9ce71130e4fe45e5bde228772dd174c9e AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:81ee6810ad86625c26b8fac3fa0b819fef8b7a379433fe069adcba9ce9f71901 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run