FROM docker.io/library/node:21.3-bookworm AS builder

WORKDIR /app
COPY yarn.lock package.json ./
RUN yarn install
COPY ./ ./
RUN yarn build


FROM docker.io/library/nginx:1.25.3-alpine AS release

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80