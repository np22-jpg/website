FROM  quay.io/sclorg/nodejs-20-c9s@sha256:94b43f82bb9a0b39447e101baa2fbe2bac5202c49f5b84f938d2e903623f240e AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:664f9d6eb29f938cba13b0b13425fe8babe37f583706b87df7e3697b1302818d AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run