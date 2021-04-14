FROM adoptopenjdk/openjdk11
VOLUME /tmp
ARG JAVA_OPTS
ENV JAVA_OPTS=$JAVA_OPTS
COPY z-api.jar z-api.jar
ENV HOUSEDB_URL "jdbc:postgresql://<host>:<port>/<database>"
ENV HOUSEDB_USERNAME "must set username"
ENV HOUSEDB_PASSWORD "must set password"
EXPOSE 7000
ENTRYPOINT exec java $JAVA_OPTS -jar z-api.jar
# For Spring-Boot project, use the entrypoint below to reduce Tomcat startup time.
#ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar housedb.jar
