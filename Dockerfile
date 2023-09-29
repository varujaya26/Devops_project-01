FROM tomcat:9.0
MAINTAINER Varu
COPY **/*.war /usr/local/tomcat/webapps/
EXPOSE 8080
