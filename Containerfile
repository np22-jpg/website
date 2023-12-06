FROM docker.io/library/node:21.4-bookworm@sha256:db2672e3c200b85e0b813cdb294fac16764711d7a66b41315e6261f2231f2331 AS builder

WORKDIR /app
COPY yarn.lock package.json ./
RUN yarn install
COPY ./ ./
RUN yarn build


FROM docker.io/library/nginx:1.25.3-alpine@sha256:3923f8de8d2214b9490e68fd6ae63ea604deddd166df2755b788bef04848b9bc AS release

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80