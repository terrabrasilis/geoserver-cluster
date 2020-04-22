# GeoServer Cluster

GeoServer docker image based on GeoServer 2.16.x series. It's used to compose the SDI of TerraBrasilis Docker cluster.
ActiveMQ Broker user to sync catalog between GeoServer instances on cluster.

 > WARNING: Until the construction of the docker images based on the 2.16.x series, the broker component does not function properly using the same settings as the previous version. Therefore, in production, we use the broker based on the 2.15.x series together the GeoServer docker images based on 2.16.x series.

The cluster topology following here is describe on ["Topology 2: 1 Master and 1 Slave instances with shared data directory using a stand-alone broker"](https://geoserver.geo-solutions.it/edu/en/clustering/clustering/active/topologies.html#topology-2-1-master-and-1-worker-instances-with-shared-data-directory-using-a-stand-alone-broker).

![External topology picture](./docs/img/clustering_external_broker.png?raw=true "Topology representation")

### Docker container

To build the docker images we use as base image the official image tomcat:9-jre11 and the GeoServer WAR file downloaded directly by the building script.

### Building base on script

We improved this version with a script to create all the images or create on demand.
To define the image version and the desired version of GeoServer, we have a JSON file called PROJECT_VERSION. So all you have to do is change that file and call one of the scripts.

```
# to build all
./docker-build.sh

# to build master and worker GeoServer
./docker-build-geoserver.sh

# or to build only the broker
./docker-build-braker.sh
```

### Manually building

The build command expects you to set some of the values ​​described by the following variables:

VERSION="x.y.z"
GS_BASE_VERSION="x.y"
GS_PATCH_VERSION="z"

 > Where x is the major version number, y is the minor version number and z is the version number patch. The first variable, VERSION, is the version of the docker image and the second and third variables, GS_BASE_VERSION and GS_PATCH_VERSION, which are used to define the version of the GeoServer.


#### Building ActiveMQ Broker image manually

Observe the aspects of manual building described on Manually building session.

```
docker build -t terrabrasilis/geoserver-broker:v$VERSION \
--build-arg VERSION=$VERSION \
--build-arg GS_BASE_VERSION=$GS_BASE_VERSION \
--build-arg GS_PATCH_VERSION=$GS_PATCH_VERSION \
BrokerActiveMQ/
```

#### Building GeoServer images manually

Observe the aspects of manual building described on Manually building session.

There are two types of image, master and worker.
To create a master image, you must pass var env, BUILD_TYPE, to the docker.

```
# to build a master image
docker build -t terrabrasilis/geoserver-master:v$VERSION \
--build-arg BUILD_TYPE=master \
--build-arg VERSION=$VERSION \
--build-arg GS_BASE_VERSION=$GS_BASE_VERSION \
--build-arg GS_PATCH_VERSION=$GS_PATCH_VERSION \
GeoServerDocker/

# to build a worker image
docker build -t terrabrasilis/geoserver-worker:v$VERSION \
--build-arg BUILD_TYPE=worker \
--build-arg VERSION=$VERSION \
--build-arg GS_BASE_VERSION=$GS_BASE_VERSION \
--build-arg GS_PATCH_VERSION=$GS_PATCH_VERSION \
GeoServerDocker/
```

### Prepare the environment

You must note the directory structure required to run the cluster. One of these directories is used to add new plugins from an external location, mounting as a volume on all instances.

![Directory structure needed to run the cluster](./docs/img/dir_structure.png?raw=true "Directory structure")

On first time, we need to create the two directories. On this example we use the following directories:

- /on/anything/path/you/want/gs_datadir/
- /on/anything/path/you/want/gs_extensions/

After running the cluster, some directories are created by ActiveMQ and GeoServer, but we should change a few things. So, stop the containers and go to make this changes.

In the /gs_extensions/ directory, you must put the required extension to provide communication between GeoServer instances. Geoserver-2.16-SNAPSHOT-jms-cluster-plugin.zip is the required plug-in and its contents must be unzipped to a new directory in the /gs_extensions/ directory. Note in this example that there is a directory called jmsclusterplugin and its contents are the ZIP file JARs mentioned above.

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

 > http://localhost:<port>/geoserver/ (worker instances have a unique port get by auto generates)

*Never change the catalog using worker instance

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
- https://build.geoserver.org/geoserver/2.16.x/community-latest/
- https://hub.docker.com/r/dockercloud/haproxy

