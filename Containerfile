FROM  quay.io/sclorg/nodejs-20-c9s@sha256:f2be8611e0fb224728456bfe703bb631de8e1b8dc7200f5a8a9996a9eb3ed11e AS build

USER root
RUN npm install -g yarn

WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install

COPY ./ ./
RUN yarn build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:0e439a1adf335ad087deb7583fc227cb991e4f4dfeb86d2bac03eddcd8d8eeb8 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run