FROM node:18.16.0 AS builder
WORKDIR /app
COPY . ./
RUN yarn;
RUN yarn build:prod;

FROM nginx:stable
COPY --from=builder /app/dist /usr/share/nginx/html/
EXPOSE 13231
CMD ["nginx", "-g", "daemon off;"]