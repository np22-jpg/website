FROM  quay.io/sclorg/nodejs-20-c9s@sha256:5f71767f5b1240d03c607b0fe5f01185bac9c7fb59359b4f79820f32bbcea22d AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:458fabb8b33d9b8db7a26ac7d410b4bd6a04669612be98b22156a0fb3be4dff0 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run