FROM debian

ARG SSH_USER
ENV SSH_USER ${SSH_USER:-user}

ARG SSH_PATH
ENV SSH_PATH ${SSH_PATH:-/home/$SSH_USER/.ssh}

ARG BIN_PATH
ENV BIN_PATH ${BIN_PATH:-/home/$SSH_USER/bin}

RUN useradd -ms /bin/bash $SSH_USER

RUN apt-get update && \
    apt-get install -y ssh netcat && \
    rm -rf /var/lib/apt

RUN mkdir -p $BIN_PATH $SSH_PATH

COPY bin/ $BIN_PATH/

RUN chmod +x $BIN_PATH/*

USER $SSH_USER

WORKDIR /home/$SSH_USER

ENTRYPOINT [ "bin/tunnel.sh" ]

CMD [ "bin/ping.sh" ]
