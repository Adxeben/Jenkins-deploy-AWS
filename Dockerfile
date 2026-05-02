# ---------- Build Stage ----------
FROM maven:3.9.9-eclipse-temurin-8 AS builder

WORKDIR /app

# Copy only pom.xml first (better caching)
COPY pom.xml .

# Download dependencies (cached unless pom.xml changes)
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests


# ---------- Runtime Stage ----------
FROM openjdk:8-jre-alpine

WORKDIR /app

# Copy only the built JAR from builder
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]