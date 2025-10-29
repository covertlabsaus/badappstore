# ---- build the static site (Hugo Extended from GHCR) ----
FROM ghcr.io/gohugoio/hugo:0.147.0-ext-alpine AS build
# ^ you can bump the version later; this tag exists on GHCR

WORKDIR /src
COPY . /src

# Ensure git is available for Hugo Modules (Hextra)
RUN apk add --no-cache git \
 && hugo mod get -u \
 && hugo --gc --minify

# ---- serve with nginx ----
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /src/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

