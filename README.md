# code-server-frc-java

Extension to linuxserver's code-server container to include Java 11, WPI Lib, and some git helpers.

## code-server Image

The core component of this repo is the Dockerfile which extends [linuxserver's code-server image](https://github.com/linuxserver/docker-code-server). In order to provide the tools needed for FRC Java development the Dockerfile installs OpenJDK 11 and the [WPILib](https://marketplace.visualstudio.com/items?itemName=wpilibsuite.vscode-wpilib) and [Java Extension Pack](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack) extensions. Finally, the Dockerfile adds two scripts, `add-git.sh` and `get-code.sh`. `add-git.sh` guides a user through setting up Git with an SSH key and adding it to GitHub. `get-code.sh` helps a user clone and open a repo of robot code. The repo is configured to be [wildstang/XXXX_robot_software](https://github.com/wildstang), this would have to be changed for other teams.

### Build Image

`docker build . --tag code-server` will build the Dockerfile and tag it `code-server`.

### Run code-server

`docker run -d --name=code-server -e PUID=1000 -e PGID=1000 -e TZ=America/Chicago -p 8443:8443 code-server` will create the most basic image, accessible through [localhost:8443](http://localhost:8443).