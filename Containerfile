FROM  quay.io/sclorg/nodejs-20-c9s@sha256:3e454658b8f0ba83a0a062ed0a8817a9720e9cd0e6fa0f813fe38dc4f4bb91a8 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:e7cc79c886a4c793081bd0c8be47dc563e7aa21878fbf9780acbb5869f5734cb AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run