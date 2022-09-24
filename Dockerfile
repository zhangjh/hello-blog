FROM node:10.24.1

WORKDIR /hello-blog
COPY ./ /hello-blog

## comment
RUN npm i 
EXPOSE 4000

CMD ["npm", "run", "start"]
