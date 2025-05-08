XML_TMP=./src/main/resources/META-INF/persistence.xml/persistence.temp.xml
XML_OUT=./src/main/resources/META-INF/persistence.xml

envsubst "`printf '${%s} ' $(sh -c "env|cut -d'=' -f1")`" < $XML_TMP > $XML_OUT
