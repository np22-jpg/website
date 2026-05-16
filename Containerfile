FROM  quay.io/sclorg/nodejs-20-c9s@sha256:66f202bfc33d67756a3fae560a88fd8323f0f36d69996618126eedcddc723a65 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:798065643b02ccf737e4f4258c20392743964f5f25b680139a04c7585166f9a1 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run