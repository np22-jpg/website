FROM  quay.io/sclorg/nodejs-20-c9s@sha256:918f413cb9758df8738f8b4615dffbf59f0d4d10ed9afd32f741645d062a9fe1 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:b42e742ad0536a812fef61ada697126b34d601702bb93cb073af9af59df37907 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run