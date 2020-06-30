FROM maven:3.6.3-adoptopenjdk-11 AS MAVEN_BUILD
ENV APP_HOME=/build
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY pom.xml $APP_HOME
#Download all required dependencies into one layer
# RUN mvn -B dependency:resolve dependency:resolve-plugins
#Copy source code
COPY src $APP_HOME/src
# Build application
RUN mvn clean install -DskipTests


FROM adoptopenjdk/openjdk11
ENV ARTIFACT_NAME=eurekaserver-0.0.1.jar
ENV APP_HOME=/build
WORKDIR $APP_HOME
COPY --from=MAVEN_BUILD $APP_HOME/target/$ARTIFACT_NAME .
EXPOSE 9999
CMD ["java", "-jar", "eurekaserver-0.0.1.jar"]