FROM  quay.io/sclorg/nodejs-20-c9s@sha256:e63279b01fa149cfeb05cd3f49bf558df8a641bbeab1c3fc3b1c17425711ce68 AS build

USER root
RUN npm install -g yarn

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install

COPY ./ ./
RUN yarn build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:335517dc49202b4c92173fa3f040979f49b07212603715323d1bcc13f56f2843 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run