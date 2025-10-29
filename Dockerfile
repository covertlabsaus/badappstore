# ---- build the static site ----
FROM klakegg/hugo:ext-alpine AS build
WORKDIR /src
COPY . /src
# fetch Hugo modules (Hextra) then build
RUN hugo mod get -u && hugo --gc --minify

# ---- serve with nginx ----
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /src/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]

