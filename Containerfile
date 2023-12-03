FROM docker.io/library/node:21.3-bookworm@sha256:04300613a87512b58a0555a122f35b2fb7a7dd528b6435e87b0d34b67f53a86a AS builder

WORKDIR /app
COPY yarn.lock package.json ./
RUN yarn install
COPY ./ ./
RUN yarn build


FROM docker.io/library/nginx:1.25.3-alpine@sha256:3923f8de8d2214b9490e68fd6ae63ea604deddd166df2755b788bef04848b9bc AS release

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80