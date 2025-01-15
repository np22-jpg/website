FROM  quay.io/sclorg/nodejs-20-c9s@sha256:84aaa81445c10a080374251afc347fc4323cdcee14ed0eaeb634edcaea78ab5f AS build

USER root
RUN npm install -g pnpm

WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

COPY ./ ./
RUN pnpm build


FROM quay.io/sclorg/nginx-122-micro-c9s@sha256:d12abb087a9881b4a6f2c88ef92e1b4922b14b85cbb94a5b96cfcbb007241834 AS release

COPY --from=build --chown=nginx /app/dist /tmp/src

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run