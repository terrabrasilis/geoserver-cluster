# GeoServer Cluster

GeoServer docker image based on GeoServer 2.15.x series. It's used to compose the SDI of TerraBrasilis Docker cluster.
ActiveMQ Broker user to sync catalog between GeoServer instances on cluster.

The base image is official tomcat:9-jre11

### Building ActiveMQ Broker image

```
docker build -t terrabrasilis/geoserver-broker:v1.0 BrokerActiveMQ/
```

### Building GeoServer image

Are two types of image, master and slave.
To build a master image your should pass the env var, IS_MASTER, to docker build.

```
# to build a master image
docker build --build-arg BUILD_TYPE=master -t terrabrasilis/geoserver-master:v1.0 GeoServerDocker/

# to build a slave image, use the value slave to BUILD_TYPE
docker build --build-arg BUILD_TYPE=slave -t terrabrasilis/geoserver-worker:v1.0 GeoServerDocker/
# or nothing
docker build -t terrabrasilis/geoserver-worker:v1.0 GeoServerDocker/
```

### Prepare the environment

You must note the directory structure required to run the cluster. One of these directories is used to add new plugins from an external location, mounting as a volume on all instances.

![Directory structure needed to run the cluster](./dir_structure.png?raw=true "Directory structure")

On first time, we need to create the two directories. On this example we use the following directories:

- /on/anything/path/you/want/gs_datadir/
- /on/anything/path/you/want/gs_extensions/

Afterrunning the cluster, some directories are created by ActiveMQ and GeoServer, but we should change a few things. So, stop the containers and go to make this changes.

In the /gs_extensions/ directory, you must put the required extension to provide communication between GeoServer instances. Geoserver-2.15-SNAPSHOT-jms-cluster-plugin.zip is the required plug-in and its contents must be unzipped to a new directory in the /gs_extensions/ directory. Note in this example that there is a directory called activeeclustering and its contents are the ZIP file JARs mentioned above.

Therefore, following this example, we can add new extensions to the /gs_extensions/ directory whenever we want to put new extensions in GeoServer. After adding new extensions to this directory, the cluster must be restarted.

To complete the needed changes, use the configuration files provided into the /ClusterConfiguration/ directory to compare with the created files during the first time the cluster runs or read the references to learn more about the GeoServer clusters.

Finally, run the cluster again and test the features.

### Running locally

Before you run this docker-compose, you must provide the directories on your server used by the containers to map the GeoServer data directory among others. See the docker-compose file for all required volumes and read the instructions in the "Preparing the environment" section above.

```
docker-compose up -d
```

GeoServer Default credentials.

admin:geoserver

### Local tests

When we run the cluster using docker compose on localhost, we gain some instances to test.

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

