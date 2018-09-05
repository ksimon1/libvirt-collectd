#!/bin/sh

# expected call: 
# /etc/libvirt/hooks/daemon - start - start
if [ "$2" != "start" ] || [ "$4" != "start" ]; then
	exit 0
fi

VM_NAME=$(hostname)

# TODO: abort (and log) if fileLocation is not accessible - e.g. noone created the metrics-files subdirectory
/usr/bin/collectd-prometheus-collector -collectdURL=http://localhost:9090/metrics -fileLocation=/var/run/kubevirt/metrics-files/${VM_NAME}.prom &
/usr/sbin/collectd &
exit 0
