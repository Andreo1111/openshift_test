FROM nginx

#LABEL maintainer="ReliefMelone"

WORKDIR /app
COPY . .

# Install node.js
RUN apt update && \
    apt install nodejs npm python make curl g++


# Build Application
RUN npm install
RUN ./node_modules/@angular/cli/bin/ng build --configuration=${BUILD_CONFIG}
RUN cp -r ./dist/. /usr/share/nginx/html

# Configure NGINX
COPY ./openshift/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./openshift/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

RUN chgrp -R root /var/cache/nginx /var/run /var/log/nginx && \
    chmod -R 770 /var/cache/nginx /var/run /var/log/nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
#Note that under the Build Application section I now do

RUN cp -r ./dist/. /usr/share/nginx/html
#instead of

#COPY ./dist/my-app /usr/share/nginx/html
