FROM maven:3.8.3-openjdk-17

WORKDIR /app

COPY target/spring-petclinic-3.2.0-SNAPSHOT.jar /app/spring-petclinic-3.2.0-SNAPSHOT.jar

CMD ["java", "-jar", "spring-petclinic-3.2.0-SNAPSHOT.jar"]


