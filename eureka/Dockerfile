FROM openjdk:17
CMD ["./gradlew", "clean", "bootJar"]
COPY build/libs/*.jar app.jar

EXPOSE 8761
ENTRYPOINT ["java", "-jar", "app.jar"]