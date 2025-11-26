# 1. 前端构建阶段
FROM alpine AS builder
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
    && apk add --no-cache nodejs npm

COPY ./frontend /src/frontend
WORKDIR /src/frontend
RUN npm install --registry=https://registry.npmmirror.com && npm run build

# 2. 后端构建阶段
FROM maven:3.9.5-eclipse-temurin-17 AS packager
COPY ./backend /src/backend
COPY --from=builder /src/frontend/dist /src/backend/src/main/resources/static
WORKDIR /src/backend
RUN ["mvn","clean","package","-Dmaven.test.skip=true"]

# 3. 生产阶段
FROM openjdk:17-jdk-alpine
COPY --from=packager /src/backend/target/*.jar /app.jar
WORKDIR /
ENTRYPOINT ["java","-jar","app.jar"]

