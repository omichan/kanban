FROM tomcat:8.5-alpine

RUN rm -rf /usr/local/tomcat/webapps/*
ADD ./ROOT.war /usr/local/tomcat/webapps/
RUN pwd
EXPOSE 8085
CMD ["catalina.sh", "run"]
