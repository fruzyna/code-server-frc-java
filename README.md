# code-server-frc-java
Extension to linuxserver's code-server container to include Java 11, WPI Lib, and some git helpers.

## Build Image
`docker build . --tag code-server`

## Run code-server
`docker run -d --name=code-server -e PUID=1000 -e PGID=1000 -e TZ=America/Chicago -p 8443:8443 code-server`

View at `localhost:8443`
