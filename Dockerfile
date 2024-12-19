# docker build --network=host -t alioth-ui:nightly .
FROM nginx:stable

COPY dist/ /usr/share/nginx/html/

EXPOSE 13231

CMD ["nginx", "-g", "daemon off;"]