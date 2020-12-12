FROM ubuntu

# install dependencies
RUN apt update -y && apt install -y curl xz-utils

WORKDIR /home/factorio

# copy install script
COPY install.sh .
RUN chmod +x ./install.sh

ENTRYPOINT [ "/home/factorio/install.sh" ]

