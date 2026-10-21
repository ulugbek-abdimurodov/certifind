# syntax=docker/dockerfile:1

# =============================================================================
# Stage 1: Builder
# Compiles dependencies and packages the Spring Boot application into a fat JAR.
# =============================================================================
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /build

# Copy Maven wrapper artifacts and project descriptor
COPY .mvn/ .mvn/
COPY mvnw mvnw.cmd pom.xml ./

# Normalize line endings (in case checked out on Windows) and ensure execution bit
RUN sed -i 's/\r$//' mvnw && chmod +x mvnw

# Pre-fetch and cache project dependencies offline
RUN ./mvnw dependency:go-offline -B

# Copy application source code
COPY src ./src

# Build production fat JAR without executing tests
RUN ./mvnw clean package -DskipTests

# =============================================================================
# Stage 2: Runner
# Minimal runtime environment executing as an unprivileged non-root user.
# =============================================================================
FROM eclipse-temurin:21-jre-alpine AS runner

WORKDIR /app

# Create non-root system group and user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy fat JAR from builder stage
COPY --from=builder --chown=appuser:appgroup /build/target/*.jar app.jar

# Run container as unprivileged user
USER appuser:appgroup

EXPOSE 8080

ENTRYPOINT ["java", "-XX:+UseG1GC", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]
