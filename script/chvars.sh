XML_OUT=./src/main/resources/META-INF/persistence.xml

envsubst "`printf '${%s} ' $(sh -c "env|cut -d'=' -f1")`" < $XML_OUT > $XML_OUT

