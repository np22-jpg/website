FROM  quay.io/sclorg/nodejs-20-c9s@sha256:83960db0bc14915aa4835b5a5d132a161bdc1708d3af1e667eabca8f808484b0 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:6b7f0b903e1d4f3eda0de50d19996f151a343de4968ef8ae22b6b4dbd610abb2 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run