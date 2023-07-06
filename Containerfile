FROM ghcr.io/np22-jpg/fedora-npm:latest AS builder

WORKDIR /app
COPY yarn.lock package.json ./
RUN yarn install
COPY ./ ./
RUN yarn build


FROM cgr.dev/chainguard/nginx:latest AS release

COPY --from=builder /app/dist /usr/share/nginx/html