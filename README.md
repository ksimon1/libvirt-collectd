# libvirtd-collectd

This is a simple container wrapping libvirtd, augmented adding collectd configured
to monitor the processes running inside the container, and report their metrics
through collectd.

## How to use in a kubevirt cluster?

1. Grab kubevirt sources. Supported version is 0.8.z. The last tested version is 0.8.0-alpha.2
2. Apply [this patch](https://github.com/fromanirh/kubevirt/commit/3292207e65294bbd630a9be138c69cf2ee2cf37b). Now your kubevirt installation support pod metrics.
3. Apply [this other patch](https://github.com/fromanirh/kubevirt/commit/007112d9ef3a2fdd654221cc2666d3edbdbb01fc). Now your VM pods are transparently instrumented to report metrics.
4. Deploy prometheus in your cluster. To get pod metrics, you need [to configure node\_exporter](https://github.com/fromanirh/libvirt-collectd/blob/master/manifests/node-exporter-daemonset.yaml).
   You can use [those manifests](https://github.com/fromanirh/libvirt-collectd/tree/master/manifests) in [this order](https://github.com/fromanirh/libvirt-collectd/blob/master/apply.sh) to deploy a pre-configured prometheus.
5. Done! You can now access prometheus server.

