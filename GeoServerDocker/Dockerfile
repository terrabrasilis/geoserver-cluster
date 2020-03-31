# Based on https://github.com/oscarfonts/docker-geoserver/
# Credits to work of: Oscar Fonts <oscar.fonts@geomati.co>
FROM tomcat:9-jdk11

ARG VERSION="1.0"
ARG GS_BASE_VERSION=2.16
ARG GS_PATCH_VERSION=2

LABEL "br.inpe.dpi"="INPE/DPI-TerraBrasilis"
LABEL br.inpe.dpi.terrabrasilis="service"
LABEL version=${VERSION}
LABEL geoserver.version=${GS_BASE_VERSION}.${GS_PATCH_VERSION}
LABEL author="Andre Carvalho"
LABEL author.email="andre.carvalho@inpe.br"
LABEL description="This service provides an instance of GeoServer used to compose the master and slave nodes on cluster."

# Used to configure the output image as MASTER or SLAVE. See: README.md file
ARG BUILD_TYPE
ENV BUILD_TYPE ${BUILD_TYPE}

ENV GEOSERVER_VERSION ${GS_BASE_VERSION}.${GS_PATCH_VERSION}
ENV GEOSERVER_DATA_DIR /var/local/geoserver
ENV GEOSERVER_INSTALL_DIR /usr/local/geoserver
ENV GEOSERVER_EXT_DIR /var/local/geoserver-exts

# GeoServer
ADD conf/geoserver.xml /usr/local/tomcat/conf/Catalina/localhost/geoserver.xml
RUN rm -rf /usr/local/tomcat/webapps/* \
    && mkdir ${GEOSERVER_DATA_DIR} \
	&& mkdir ${GEOSERVER_INSTALL_DIR} \
	&& cd ${GEOSERVER_INSTALL_DIR} \
	&& wget "http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip" \
	&& unzip geoserver-${GEOSERVER_VERSION}-war.zip \
	&& unzip geoserver.war \
	&& mv data/* ${GEOSERVER_DATA_DIR} \
	&& rm -rf geoserver-${GEOSERVER_VERSION}-war.zip geoserver.war target *.txt

# Enable CORS
RUN sed -i '\:</web-app>:i\
<filter>\n\
    <filter-name>CorsFilter</filter-name>\n\
    <filter-class>org.apache.catalina.filters.CorsFilter</filter-class>\n\
    <init-param>\n\
        <param-name>cors.allowed.origins</param-name>\n\
        <param-value>*</param-value>\n\
    </init-param>\n\
    <init-param>\n\
        <param-name>cors.allowed.methods</param-name>\n\
        <param-value>GET,POST,HEAD,OPTIONS,PUT</param-value>\n\
    </init-param>\n\
</filter>\n\
<filter-mapping>\n\
    <filter-name>CorsFilter</filter-name>\n\
    <url-pattern>/*</url-pattern>\n\
</filter-mapping>' ${GEOSERVER_INSTALL_DIR}/WEB-INF/web.xml

# Tomcat environment to set the JVM parameters. (https://manpages.debian.org/testing/openjdk-11-jre-headless/java.1.en.html)
ENV CATALINA_OPTS "-Djava.awt.headless=true -Dfile.encoding=UTF-8 -server \
	-Xms1024m -Xmx3072m -Xss1024k -XX:NewSize=768m \
    -XX:+UseParallelGC -XX:MaxGCPauseMillis=500 \
	-DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR}"

ADD start.sh /usr/local/bin/start.sh

# Create tomcat user to avoid root access. 
RUN addgroup --gid 1099 tomcat && useradd -m -u 1099 -g tomcat tomcat \
    && chown -R tomcat:tomcat . \
    && chown -R tomcat:tomcat ${GEOSERVER_DATA_DIR} \
    && chown -R tomcat:tomcat ${GEOSERVER_INSTALL_DIR} \
    && chmod +x /usr/local/bin/start.sh

ENTRYPOINT [ "/usr/local/bin/start.sh" ]

VOLUME ["${GEOSERVER_DATA_DIR}", "${GEOSERVER_EXT_DIR}"]

EXPOSE 8080