FROM kubevirt/libvirt:4.2.0

MAINTAINER "Francesco Romani" <fromani@redhat.com>
ENV container docker

RUN \
  dnf install -y \
    collectd collectd-write_prometheus && \
  dnf clean all

ADD configs/collectd.conf /etc/collectd.conf
ADD configs/collectd.d /etc/collectd.d

CMD ["/libvirtd.sh"]
