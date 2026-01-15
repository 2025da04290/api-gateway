FROM eclipse-temurin:21-jre-alpine

LABEL maintainer="vk"
LABEL service="api-gateway"

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY build/libs/api-gateway.jar app.jar

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 9080

ENV JAVA_OPTS="-Xms256m -Xmx512m"

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:9080/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]
