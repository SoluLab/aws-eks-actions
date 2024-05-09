FROM alpine/k8s:1.28.9
LABEL maintainer="Ravinayag <ravinayag@gmail.com>"


RUN kubectl version --client

RUN kubectl version --client
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
