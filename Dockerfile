# Build stage
FROM gradle:7.6-jdk11 AS builder

WORKDIR /app
COPY . .

# Build the application using shadowJar to create a fat JAR
RUN gradle shadowJar --no-daemon

# Runtime stage
FROM eclipse-temurin:11-jre

WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /app/build/libs/JAVMovieScraper-*-all.jar app.jar

# Since this is a desktop GUI app, we'll run it in headless mode
ENV DISPLAY=:99

# Set entrypoint to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

