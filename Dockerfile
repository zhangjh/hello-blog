FROM njhxzhangjh/web_base:2.0

WORKDIR /root/web/hello-blog

COPY ./ /root/web/hello-blog

## comment
RUN cd /root/web/hello-blog
RUN npm run start 
