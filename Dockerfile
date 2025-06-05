FROM node:18.16.0 AS builder
WORKDIR /app
COPY . ./
RUN rm -rf node_modules package-lock.json
RUN npm install
RUN npm run build

FROM nginx:stable
COPY --from=builder /app/dist /usr/share/nginx/html/
EXPOSE 80
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]