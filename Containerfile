FROM  quay.io/sclorg/nodejs-20-c9s@sha256:3d59106a0791b040615e7df315c8fbdfdf8fc2f976f54d8eae3cb80f06ebcfa3 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:6b7f32d18cf4222179346c39f9dffb2285b523515d05294c55b8551604e4451a AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run