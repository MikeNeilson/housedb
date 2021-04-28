FROM adoptopenjdk:11-jdk-hotspot
VOLUME /tmp
COPY . /
ARG JAVA_OPTS
ENV JAVA_OPTS=$JAVA_OPTS
ARG HOUSEDB_URL
ARG HOUSEDB_USERNAME
ARG HOUSEDB_PASSWORD
RUN ./gradlew :z-api:build -PDBURL=${HOUSEDB_URL} -PDBUSER=${HOUSEDB_USERNAME} -PDBPASSWORD=${HOUSEDB_PASSWORD}

# For Spring-Boot project, use the entrypoint below to reduce Tomcat startup time.
#ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar housedb.jar


FROM adoptopenjdk:11-jre-hotspot
ARG JAVA_OPTS
ENV JAVA_OPTS=${JAVA_OPTS}
ENV HOUSEDB_URL "jdbc:postgresql://<host>:<port>/<database>"
ENV HOUSEDB_USERNAME "must set username"
ENV HOUSEDB_PASSWORD "must set password"
COPY --from=0 z-api/build/libs/z-api.* ./z-api.jar
EXPOSE 7000
ENTRYPOINT exec java $JAVA_OPTS -jar z-api.jar
