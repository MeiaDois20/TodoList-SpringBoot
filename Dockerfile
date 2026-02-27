FROM ubuntu:latest AS build

# Instalar Java e Maven
RUN apt-get update && \
    apt-get install -y openjdk-25-jdk maven && \
    apt-get clean

# Definir JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

WORKDIR /app

COPY . .

RUN echo "=== VERIFICANDO POM.XML ===" && \
    cat pom.xml

RUN mvn clean install -DskipTests

FROM eclipse-temurin:25-jre-alpine
EXPOSE 8080


COPY --from=build /app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]