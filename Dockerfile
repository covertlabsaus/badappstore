# ---- build the static site ----
FROM gohugoio/hugo:ext-alpine AS build
# If you want to pin a version later, switch to e.g.:
# FROM gohugoio/hugo:0.147.0-ext-alpine

WORKDIR /src
COPY . /src

# For Hextra (Hugo Modules), make sure modules are fetched
# (git is present in the hugo:ext-alpine image)
RUN hugo mod get -u && hugo --gc --minify

# ---- serve with nginx ----
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /src/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]

