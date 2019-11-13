
# Based on https://github.com/groldan/2019_foss4g-ar_taller_geoserver/
# Credits to work of: Gabriel Roldan <gabriel.roldan@gmail.com>
FROM tomcat:9-jre11

LABEL "br.inpe.dpi"="INPE/DPI-TerraBrasilis"
LABEL br.inpe.dpi.terrabrasilis="service"
LABEL version="v1.0"
LABEL author="Andre Carvalho"
LABEL author.email="andre.carvalho@inpe.br"
LABEL description="This service provides an instance of ActiveMQ Broker to sync catalog between GeoServer instances on cluster."

ENV GEOSERVER_VERSION 2.15-SNAPSHOT
ENV GEOSERVER_DATA_DIR /var/local/geoserver
ENV GEOSERVER_INSTALL_DIR /usr/local/broker

ENV BROKER_FILE geoserver-${GEOSERVER_VERSION}-activeMQ-broker-plugin.zip
ENV BROKER_URL https://build.geoserver.org/geoserver/2.15.x/community-latest/${BROKER_FILE}

RUN rm -rf /usr/local/tomcat/webapps/* \
    && mkdir -p /usr/local/tomcat/conf/Catalina/localhost && echo "<Context path=\"/broker\" docBase=\"/usr/local/broker\"></Context>" > /usr/local/tomcat/conf/Catalina/localhost/broker.xml \
    && mkdir ${GEOSERVER_DATA_DIR} \
	&& mkdir ${GEOSERVER_INSTALL_DIR} \
    && mkdir -p /usr/local/tomcat/webapps/gsworker \
	&& cd ${GEOSERVER_INSTALL_DIR} \
	&& wget ${BROKER_URL} \
	&& unzip ${BROKER_FILE} \
	&& unzip activemqBroker-${GEOSERVER_VERSION}.war \
	&& rm *.war *.zip

# Tomcat environment
ENV CATALINA_OPTS "-server -Djava.awt.headless=true -Dfile.encoding=UTF-8 \
	-Xms768m -Xmx1560m -XX:+UseConcMarkSweepGC -XX:NewSize=48m \
	-DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR} \
    -Dactivemq.transportConnectors.server.uri=\"tcp://0.0.0.0:61666?maximumConnections=1000&wireFormat.maxFrameSize=104857600&jms.useAsyncSend=true&transport.daemon=true\""

VOLUME ["${GEOSERVER_DATA_DIR}"]

CMD catalina.sh run

EXPOSE 61666
