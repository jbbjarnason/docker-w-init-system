FROM ubuntu:22.04 as builder

RUN apt-get update && apt-get install -y sudo curl net-tools dumb-init runit

RUN curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-2/cfg/setup/bash.deb.sh' | bash

RUN KEA_VERSION="2.2.0-isc20220726061131" && \
    apt-get update && apt-get install -y \
    isc-kea-common=$KEA_VERSION \
    isc-kea-dhcp4-server=$KEA_VERSION \
    isc-kea-dhcp6-server=$KEA_VERSION \
    isc-kea-ctrl-agent=$KEA_VERSION

COPY service /var/service/
RUN chmod +x /var/service/kea-dhcp4/run
RUN chmod +x /var/service/kea-dhcp6/run
RUN chmod +x /var/service/kea-ctrl-agent/run

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/bin/runsvdir", "-P", "/var/service"]

