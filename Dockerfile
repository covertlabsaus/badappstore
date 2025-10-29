# ---- build the static site ----
FROM klakegg/hugo:0.127.0-ext-alpine AS build
WORKDIR /src
COPY . /src
# If you set baseURL in hugo.yaml, this is enough:
RUN hugo --gc --minify
# If you prefer to override at build time, you could instead:
# ARG BASE_URL
# RUN hugo --gc --minify -b ${BASE_URL}

# ---- serve with nginx ----
FROM nginx:alpine
# (Optional) smaller, stricter Nginx config
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /src/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]

