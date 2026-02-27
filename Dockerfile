FROM ubuntu:latest AS build

RUN apt-get update && \
    apt-get install -y openjdk-25-jdk maven && \
    apt-get clean

ENV JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

WORKDIR /app

COPY . .

RUN echo "=== VERIFICANDO DEPENDÊNCIAS ===" && \
    cat pom.xml | grep -A 5 -B 5 "lombok" || echo "LOMBOK NÃO ENCONTRADO!"

RUN mvn clean compile -e || true

RUN mvn clean install -DskipTests

FROM eclipse-temurin:25-jre-alpine
EXPOSE 8080

COPY --from=build /app/target/*.jar app.jar

ENTRYPOINT ["sh", "-c", "java -Dserver.port=${PORT:-8080} -jar app.jar"]