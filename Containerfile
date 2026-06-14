FROM  quay.io/sclorg/nodejs-20-c9s@sha256:114da5f7d93079edaaf80126f979c8ec649924b4908ef20cdc6a93134bedc62e AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:72abb3dcc5a2d90b40609b3e9b1d08a58a497a100ae4756538b84d73f473811a AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run