FROM maven:3-jdk-9-slim AS builder
COPY src /opt/src
COPY pom.xml /opt
WORKDIR /opt
RUN mvn -f /opt/pom.xml compile package

FROM  openjdk:9
COPY --from=builder /opt/target/*.jar /opt/assets/spring-boot.jar
WORKDIR /opt/assets
ENV ZOOKEEPER=localhost:2181
EXPOSE 8081
CMD java -Dserver.port=8081 -Dzk.url=${ZOOKEEPER} -Dleader.algo=2 -jar spring-boot.jar
