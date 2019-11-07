# GeoServer Cluster

GeoServer docker image based on GeoServer 2.15.x series. It's used to compose the SDI of TerraBrasilis Docker cluster.
ActiveMQ Broker user to sync catalog between GeoServer instances on cluster.

The base image is official tomcat:9-jre11

### To build ActiveMQ Broker image

Before build the image you need  ...


```
docker build --rm -t terrabrasilis/geoserver-broker:v1.0 BrokerActiveMQ/
```

### To build GeoServer image

Before build the image you need  ...


```
docker build --rm -t terrabrasilis/geoserver-worker:v1.0 GeoServerDocker/
```

### To RUN locally

Before you run this docker, you must provide the directories on your server used by the containers to map as the GeoServer data directory among others. See the docker-compose file for all the required volumes.

```
docker-compose up -d
```

GeoServer Default credentials.

admin:geoserver

### To test

http://localhost:8080/gsworker/


## Credits

#### For GeoServer

 > Based on https://github.com/oscarfonts/docker-geoserver/
 > Credits to work of: Oscar Fonts <oscar.fonts@geomati.co>

#### For GeoServer Broker

 > Based on https://github.com/groldan/2019_foss4g-ar_taller_geoserver/
 > Credits to work of: Gabriel Roldan <gabriel.roldan@gmail.com>