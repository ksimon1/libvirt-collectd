.PHONY: all clean

all: build

build:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o _output/bin/collectd-prometheus-collector src/collectd-prometheus-collector.go 

clean:
	-rm -rf _output