FROM ubuntu:latest AS build

RUN apt-get update && \
    apt-get install -y openjdk-25-jdk maven && \
    apt-get clean

ENV JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

WORKDIR /app

COPY . .

RUN mvn clean install -DskipTests

RUN ls -la /app/target/

FROM eclipse-temurin:25-jre-alpine
EXPOSE 8080

COPY --from=build /app/target/*.jar app.jar

RUN ls -la app.jar || echo "JAR não encontrado!"

ENTRYPOINT ["java", "-jar", "app.jar"]