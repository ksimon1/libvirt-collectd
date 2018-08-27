FROM kubevirt/libvirt:4.2.0

MAINTAINER "Francesco Romani" <fromani@redhat.com>
ENV container docker

RUN \
  dnf install -y \
    collectd collectd-write_prometheus && \
  dnf clean all

COPY config/collectd.conf /etc/collectd.conf
COPY config/processes.conf /etc/collectd.d/processes.conf
COPY config/write_prometheus.conf /etc/collectd.d/write_prometheus.conf

EXPOSE 9103

CMD ["/libvirtd.sh"]
