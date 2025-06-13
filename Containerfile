FROM  quay.io/sclorg/nodejs-20-c9s@sha256:74c44779e66420cae5efe03cbb24156407b1da6acdb36811ac819d867b22a0c9 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:1bbdcef54e566a1226f8c6ea07243a650596d8abf6b554e18c9d93e5298b83fc AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run