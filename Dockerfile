FROM registry.cn-hangzhou.aliyuncs.com/ns_zyzy/node-amd64:18.16.0 AS builder
WORKDIR /app
COPY . ./
RUN npm config set registry http://registry.npmmirror.com
RUN yarn;
RUN yarn config set  registry https://registry.npmmirror.com
RUN yarn build:prod;

FROM nginx:stable
COPY --from=builder /app/dist /usr/share/nginx/html/
EXPOSE 13231
CMD ["nginx", "-g", "daemon off;"]