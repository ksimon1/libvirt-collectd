#!/bin/bash

PLATFORM="$1"
TOOL="$2"
DIR=$(pwd)

if [ -z "$PLATFORM" ]; then
	echo "usage: $0 PLATFORM"
	echo "* supported PLATFORMS:"
	echo "k8s - vanilla kubernetes"
	echo "ocp - openshift"
	exit 1
fi

if [ "$PLATFORM" == "k8s" ]; then
	if [ -z "$TOOL" ]; then
		TOOL="kubectl"
	fi
elif [ "$PLATFORM" == "ocp" ]; then
	if [ -z "$TOOL" ]; then
		TOOL="oc"
	fi
else
	echo "unsupported tool: [$TOOL]"
	exit 2
fi


echo $TOOL create -f $DIR/manifests/monitoring-namespace.yaml
if [ "$PLATFORM" == "ocp" ]; then
	echo $TOOL adm policy add-scc-to-user privileged system:serviceaccount:monitoring:default
#	echo $TOOL annotate namespace monitoring openshift.io/node-selector=\"\"
fi
echo $TOOL create -f $DIR/manifests/prometheus-config.yaml
echo $TOOL create -f $DIR/manifests/prometheus-deployment.yaml
echo $TOOL create -f $DIR/manifests/prometheus-service.yaml
echo $TOOL create -f $DIR/manifests/node-exporter-daemonset.yaml
