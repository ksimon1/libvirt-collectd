FROM kubevirt/libvirt:4.2.0

MAINTAINER "Francesco Romani" <fromani@redhat.com>
ENV container docker

RUN \
  dnf install -y \
    collectd collectd-write_prometheus && \
  dnf clean all

CMD ["/libvirtd.sh"]
