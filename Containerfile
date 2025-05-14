FROM  quay.io/sclorg/nodejs-20-c9s@sha256:56576430d002c9fac6233ea939dbe58ccad9dd7c804299acc0268f7e05fc5b8d AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:a625e9f9a46254681cd4eec8dac2dc54861e5719593cd76cbd4e59fecba8a606 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run