# GeoServer Cluster

GeoServer docker image based on GeoServer 2.15.x series. It's used to compose the SDI of TerraBrasilis Docker cluster.
ActiveMQ Broker user to sync catalog between GeoServer instances on cluster.

The base image is official tomcat:9-jre11

### Building ActiveMQ Broker image

Before build the image you need  ...


```
docker build -t terrabrasilis/geoserver-broker:v1.0 BrokerActiveMQ/
```

### Building GeoServer image

Are two types of image, master and slave.
To build a master image your should pass the env var, IS_MASTER, to docker build.

```
# to build a master image
docker build --build-arg BUILD_TYPE=master -t terrabrasilis/geoserver-master:v1.0 GeoServerDocker/

# to build a slave image, use the value slave to BUILD_TYPE or nothing
docker build --build-arg BUILD_TYPE=slave -t terrabrasilis/geoserver-worker:v1.0 GeoServerDocker/
docker build -t terrabrasilis/geoserver-worker:v1.0 GeoServerDocker/
```

### Running locally

Before you run this docker, you must provide the directories on your server used by the containers to map as the GeoServer data directory among others. See the docker-compose file for all the required volumes.

```
docker-compose up -d
```

GeoServer Default credentials.

admin:geoserver

### Local tests

When we run the cluster using docker compose on localhost, we have some instances to test.

 > http://localhost:8081/geoserver/ (master instance)

 > http://localhost:<port>/geoserver/ (slave instances have a unique port get by auto generates)

*Never change the catalog using slave instance

## Credits

#### For GeoServer

 > Based on https://github.com/oscarfonts/docker-geoserver/

 > Credits to work of: Oscar Fonts <oscar.fonts@geomati.co>

#### For GeoServer Broker

 > Based on https://github.com/groldan/2019_foss4g-ar_taller_geoserver/

 > Credits to work of: Gabriel Roldan <gabriel.roldan@gmail.com>

## Research sources

- https://docs.geoserver.org/latest/en/user/community/jms-cluster/index.html
- https://geoserver.geo-solutions.it/downloads/technical_material/clustering/HighAvailabilityWithGeoServer_Windows.pdf
- http://www.fernandoquadro.com.br/html/2019/07/24/clusterizacao-do-geoserver-com-docker-parte-2/
- https://groldan.github.io/2019_foss4g-ar_taller_geoserver/
- https://hub.docker.com/r/oscarfonts/geoserver/dockerfile
- https://build.geoserver.org/geoserver/2.15.x/community-latest/
- https://hub.docker.com/r/dockercloud/haproxy

