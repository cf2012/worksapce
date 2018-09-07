
## tips

使用2个母版. 先编译, 再打包成镜像. 一个 `dockerfile` 完成. 
```
FROM node:8 as build
WORKDIR /app
COPY package.json index.js ./
RUN npm install

FROM node:8-alpine
COPY --from=build /app /
EXPOSE 3000
CMD ["npm", "start"]
```
