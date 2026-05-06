FROM  quay.io/sclorg/nodejs-20-c9s@sha256:052e11a3d5fedfb7562a0dcda9905d7e7a8c7bd59ef1f05a498e72205fbfab5b AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:81b828a1727d8ea6fe527ba495b4baa278a3591047eab12b96f035cd127a8d77 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run