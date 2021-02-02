# code-server-frc-java

Extension to linuxserver's code-server container to include Java 11, WPI Lib, and some git helpers. Plus, tools to create and destroy instances.

Note all scripts (bash and python) are intended to be run from the root of this repository.

## code-server Image

The core component of this repo is the Dockerfile which extends [linuxserver's code-server image](https://github.com/linuxserver/docker-code-server). In order to provide the tools needed for FRC Java development the Dockerfile installs OpenJDK 11 and the [WPILib](https://marketplace.visualstudio.com/items?itemName=wpilibsuite.vscode-wpilib) and [Java Extension Pack](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack) extensions. Finally, the Dockerfile adds two scripts, `add-git.sh` and `get-code.sh`. `add-git.sh` guides a user through setting up Git with an SSH key and adding it to GitHub. `get-code.sh` helps a user clone and open a repo of robot code. The repo is configured to be [wildstang/XXXX_robot_software](https://github.com/wildstang), this would have to be changed for other teams.

### Build Image

`docker build . --tag code-server` will build the Dockerfile and tag it `code-server`.

### Run code-server

`docker run -d --name=code-server -e PUID=1000 -e PGID=1000 -e TZ=America/Chicago -p 8443:8443 code-server` will create the most basic image, accessible through [localhost:8443](http://localhost:8443).

## create-instance.sh Script

The `create-instance.sh` script wraps the run command to add improved functionality. It takes three parameters, a name, password, and port. It creates new instance of the `code-server` image named `code-server-[name]`. In addition to the provided run command, it adds a given password to the UI and a sudo password from configuration file. Then limits the number of CPUs to 0.5 and RAM to 2 GB, these resources were deemed enough for FRC development. After creating the container the script adjusts `code.subfolder.conf.sample` to fit the given parameters. This configuration file is used to describe a subfolder reverse proxy for nginx such as that in [linuxserver/swag](https://github.com/linuxserver/docker-swag). Finally it restarts said nginx proxy.

### remove-instance.sh Script

To undo the `create-instance.sh` script the `remove-instance.sh` script stops and remove the container, then removes the proxy config and restarts the proxy.

## gui.py Web GUI

To allow easier management of these instances there is a modified [Python HTTP server](https://docs.python.org/3/library/http.server.html). The server can also operate through a reverse proxy and has a `setup-gui.sh` script to prepare the config file and restart the proxy. Speaking of which the index of the GUI allows creation of a new instance at a path of the submitted name. This page can be secured with an access code set at `config/gui_password`. The `/status` page allows stopping, restarting, and removing of currently created containers.

## Config File Dictionary 

| file            | description |
| --------------- | ----------- |
| domain          | The domain where the server is externally accessible, e.g. www.example.com. |
| gui_password    | Access code necessary to create new instances. |
| gui_path        | Subfolder where GUI is accessible, e.g. init. |
| gui_port        | Port where GUI is accessible, default is 8110. |
| max_port        | Maximum port number the GUI can assign to a container, default is 8111. |
| min_port        | Minimum port number the GUI can assign to a container, default is 8120. |
| proxy_container | Name of the reverse proxy container. |
| proxy_path      | Path of proxy config files. |
| sudo_password   | Password to use for instances' sudo users. |