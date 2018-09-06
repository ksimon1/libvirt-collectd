# libvirtd-collectd

This is a simple container wrapping libvirtd, augmented adding collectd configured
to monitor the processes running inside the container, and report their metrics
through collectd.

## How to use in a kubevirt cluster?

1. Grab kubevirt sources. Supported version is 0.7.z (k8s). The last tested version is 0.7.0 (k8s).
2. Apply [this patch](https://github.com/fromanirh/kubevirt/commit/3292207e65294bbd630a9be138c69cf2ee2cf37b). Now your kubevirt installation support pod metrics.
3. Apply [this other patch](https://github.com/fromanirh/kubevirt/commit/007112d9ef3a2fdd654221cc2666d3edbdbb01fc). Now your VM pods are transparently instrumented to report metrics.
4. Deploy prometheus in your cluster.
   - If you are running on top of kubernetes: To get pod metrics, you need [to configure node\_exporter](https://github.com/fromanirh/libvirt-collectd/blob/master/manifests/k8s/node-exporter-daemonset.yaml).
     You can use [those manifests](https://github.com/fromanirh/libvirt-collectd/tree/master/manifests/k8s) in [this order](https://github.com/fromanirh/libvirt-collectd/blob/master/apply.sh) to deploy a pre-configured prometheus.
   - If you are running on top of OCP: TODO
5. Done! You can now access prometheus server.

## Notes for developers

1. if you run on top of kubevirt development cluster, you most likely to need this last step to indeed access your prometheus server:

   `port-forward -n <prometheus_pod_namespace>  <prometheus_pod_name> 36000:9090`
   
