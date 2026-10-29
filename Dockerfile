FROM postman/newman:5.3-alpine

USER root

RUN apk update && apk upgrade && apk add --no-cache curl zip iputils  && npm install --global newman-reporter-csvallinone  && npm cache clean --force  && rm -rf /var/cache/apk/* /root/.npm

COPY resolv.conf /etc/resolv.conf

ENV NODE_PATH=/usr/local/lib/node_modules

WORKDIR /etc/newman

ENTRYPOINT ["newman"]

