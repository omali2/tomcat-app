# Basis-Image mit Java
FROM openjdk:17-jdk-slim

# Tomcat-Version
ENV TOMCAT_VERSION 10.1.40

# Verzeichnis für Tomcat
RUN mkdir /opt/tomcat

RUN /bin/sh -c set -eux; apt-get update; apt-get install -y curl

# entpacke Tomcat
RUN curl -fsSL https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz | \
    tar -xz -C /opt/tomcat --strip-components=1

# variablen
ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN ls -la $CATALINA_HOME/webapps/ROOT/
RUN rm -rf $CATALINA_HOME/webapps/ROOT
ADD sample.war $CATALINA_HOME/webapps/
RUN cd $CATALINA_HOME/webapps/ && jar -xvf $CATALINA_HOME/webapps/*.war
RUN ls -la $CATALINA_HOME/webapps/
RUN mkdir $CATALINA_HOME/ROOT
RUN cp -rf $CATALINA_HOME/webapps/* $CATALINA_HOME/ROOT
RUN mv $CATALINA_HOME/ROOT $CATALINA_HOME/webapps
RUN cd $CATALINA_HOME/bin && chmod +x *.sh
RUN ls -la $CATALINA_HOME/webapps/ROOT/
RUN ls -la $CATALINA_HOME/bin/

# Port
EXPOSE 8080

# Start Skript
CMD ["catalina.sh", "run"]