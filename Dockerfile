FROM ubuntu:latest AS build

RUN apt-get update && \
    apt-get install -y openjdk-25-jdk maven && \
    apt-get clean

ENV JAVA_HOME=/usr/lib/jvm/java-25-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

WORKDIR /app

COPY . .

# Diagnóstico completo
RUN echo "=== ESTRUTURA DE PACOTES ===" && \
    find src/main/java -type f -name "*.java" | sort && \
    echo "\n=== PRIMEIRAS LINHAS DOS ARQUIVOS JAVA ===" && \
    find src/main/java -name "*.java" -exec head -5 {} \; -exec echo "\n---\n" \; && \
    echo "\n=== GROUP ID NO POM ===" && \
    grep -A 2 "<groupId>" pom.xml || echo "GroupId não encontrado"

# Tentar compilar apenas um arquivo para teste
RUN javac -d . $(find src/main/java -name "*.java" | head -1) || echo "Falha na compilação Java"

# Tentar compilar com Maven
RUN mvn clean compile -e || true

FROM eclipse-temurin:25-jre-alpine
EXPOSE 8080
COPY --from=build /app/target/*.jar /app/
ENTRYPOINT ["java", "-jar", "app.jar"]