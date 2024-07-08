FROM docker.io/rockylinux:9

LABEL org.opencontainers.image.authors="Niclas Spreng"
LABEL org.opencontainers.image.description="Molecule Container Rockylinux 9"
LABEL org.opencontainers.image.source=https://github.com/DudeCalledBro/molecule-rockylinux9-ansible

RUN cd /lib/systemd/system/sysinit.target.wants/ ; \
    for i in * ; do [ $i = systemd-tmpfiles-setup.service ] || rm -f $i ; done ; \
    rm -f /lib/systemd/system/multi-user.target.wants/* ; \
    rm -f /etc/systemd/system/*.wants/* ; \
    rm -f /lib/systemd/system/local-fs.target.wants/* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
    rm -f /lib/systemd/system/basic.target.wants/* ; \
    rm -f /lib/systemd/system/anaconda.target.wants/*

# install requirements
RUN yum -qy install rpm dnf-plugins-core \
    && yum -qy update \
    && yum -qy install \
        epel-release \
        hostname \
        initscripts \
        iproute \
        libyaml \
        python3 \
        python3-pip \
        python3-pyyaml \
        sudo \
        which \
    && yum clean all \
    && rm -rf /var/cache/dnf

# disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

VOLUME ["/sys/fs/cgroup"]

CMD ["/lib/systemd/systemd"]
