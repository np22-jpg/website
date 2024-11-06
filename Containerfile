FROM  quay.io/sclorg/nodejs-20-c9s@sha256:d1e7250f60a0fd3bb748f78cc21c37b3a9bb8edfcb36ed4425dec04ee94a4ebf AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:36bde2955f32292528886ad769ff3e3a60c143b9b691e8d7161d581ed35cc161 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run