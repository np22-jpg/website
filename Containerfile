FROM  quay.io/sclorg/nodejs-20-c9s@sha256:6260849b0456cb92f01aaff745eb2ca8b198d5b04eca6b2f3e64dd2d43052660 AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:4f4b5000b4a308de9594fbb0bc6cab80cd0b5be7f1dcba6921519659e88385dc AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run