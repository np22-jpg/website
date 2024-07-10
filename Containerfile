FROM  quay.io/sclorg/nodejs-20-c9s@sha256:7f09362c1715a23c1b831afe7aa25fbb48b186745f58abaca605694e0d0c2aae AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:b6bcc2818d84570b44041dcdcd2edce30bebaf5fe5bcd0f0dcd8bd677c7e4a2d AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run