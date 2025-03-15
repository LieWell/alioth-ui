FROM node:18.16.0 AS builder
WORKDIR /app
COPY . ./
RUN npm run build

FROM nginx:stable
COPY --from=builder /app/dist /usr/share/nginx/html/
EXPOSE 13231
CMD ["nginx", "-g", "daemon off;"]