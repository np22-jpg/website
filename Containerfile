FROM  quay.io/sclorg/nodejs-20-c9s@sha256:d5c6b809620252c6a4f1b4d9155138ab578aab4756e4b5d1b724814774b9905e AS build

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