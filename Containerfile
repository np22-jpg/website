FROM  quay.io/sclorg/nodejs-20-c9s@sha256:b672069eefe162733706250390c528650549c2bcb998e0d9c37e9036c364cbf4 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:458fabb8b33d9b8db7a26ac7d410b4bd6a04669612be98b22156a0fb3be4dff0 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run