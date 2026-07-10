# Build stage
FROM gradle:7.6-jdk11 as builder

WORKDIR /app
COPY . .

# Build the application using shadowJar to create a fat JAR
RUN gradle shadowJar --no-daemon

# Runtime stage
FROM openjdk:11-jre-slim

WORKDIR /app

# Copy the built JAR from the builder stage
COPY --from=builder /app/build/libs/JAVMovieScraper-*-all.jar app.jar

# Since this is a desktop GUI app, we'll run it in headless mode with a simple HTTP server
# or just output to logs
ENV DISPLAY=:99

# Set entrypoint to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

