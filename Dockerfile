FROM linuxserver/code-server

RUN sudo apt-get update && sudo apt-get install -y \
	openjdk-11-jdk \
	iputils-ping

# technically these can be done in one command, but it produces an error message, definitely not the intended use case
RUN /usr/local/bin/code-server --extensions-dir /config/extensions --install-extension wpilibsuite.vscode-wpilib \
    /usr/local/bin/code-server --extensions-dir /config/extensions --install-extension vscjava.vscode-java-pack

COPY add-git.sh /config/workspace/add-git.sh
COPY get-code.sh /config/workspace/get-code.sh
