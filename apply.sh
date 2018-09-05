#!/bin/bash

TOOL="$1"

if [ -z "$TOOL" ]; then
	echo "usage: $0 TOOL"
	echo "TOOL is kubectl, oc..."
	exit 1
fi

$TOOL create -f manifests/monitoring-namespace.yaml
$TOOL create -f manifests/prometheus-config.yaml
$TOOL create -f manifests/prometheus-deployment.yaml
$TOOL create -f manifests/prometheus-service.yaml
$TOOL create -f manifests/node-exporter-daemonset.yaml
