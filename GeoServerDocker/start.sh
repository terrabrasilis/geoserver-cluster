#!/bin/bash

if [ -n "${CUSTOM_UID}" ];then
  echo "Using custom UID ${CUSTOM_UID}."
  usermod -u ${CUSTOM_UID} tomcat
  find / -user 1099 -exec chown -h tomcat {} \; 
fi

if [ -n "${CUSTOM_GID}" ];then
  echo "Using custom GID ${CUSTOM_GID}."
  groupmod -g ${CUSTOM_GID} tomcat
  find / -group 1099 -exec chgrp -h tomcat {} \;
fi

# From build command to config the output image as a master or slave
if [ ! "${BUILD_TYPE}" = "master" ];then
  echo "Building WORKER image."
  cd ${GEOSERVER_INSTALL_DIR}/WEB-INF/lib
  # remove some libs related with GWC
  #ls ./ |grep -i 'gwc' |xargs rm
fi

# We need this line to ensure that data has the correct rights
# WARNING: This command is executed for a long time if your data is big like my.
#chown -R tomcat:tomcat ${GEOSERVER_DATA_DIR}
chown -R tomcat:tomcat ${GEOSERVER_EXT_DIR}

for ext in `ls -d "${GEOSERVER_EXT_DIR}"/*/`; do
  su tomcat -c "cp "${ext}"*.jar /usr/local/geoserver/WEB-INF/lib"
done

su tomcat -c "/usr/local/tomcat/bin/catalina.sh run"