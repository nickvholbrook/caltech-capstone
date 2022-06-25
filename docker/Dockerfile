FROM maven:3.5.2-jdk-8-slim AS BUILD
COPY ./complete /usr/src/app
CMD ls /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean package


FROM openjdk:8
COPY --from=BUILD /usr/src/app/target/accessing-data-mysql-complete-0.0.1-SNAPSHOT.jar /usr/app/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","usr/app/app.jar"]

# docker build -t nickholbrook/gs-accessing-data-mysql .

