package main

import (
	"flag"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"
	"time"
)

/*  collectd-prometheus-collector is a script which retrives data from collectd prometheus server and saves it to file.
*   By default it removes last column with timestamp(https://prometheus.io/docs/instrumenting/exposition_formats/#line-format) from data due to node-exporter
 */

func main() {
	var (
		collectdURL     string
		fileLocation    string
		pollInterval    int
		removeTimestamp bool
	)

	flag.StringVar(&collectdURL, "collectd-url", "", "collectd URL *required")
	flag.StringVar(&fileLocation, "file-location", "", "location of file to write in *required")
	flag.IntVar(&pollInterval, "poll-interval", 15, "poll interval")
	flag.BoolVar(&removeTimestamp, "remove-timestamp", true, "remove last column with timestamp")

	flag.Parse()

	if collectdURL == "" {
		log.Fatalln("collectd-url is required param")
	}

	if fileLocation == "" {
		log.Fatalln("file-location is required param")
	}

	for {
		data, err := getPrometheusData(collectdURL)
		if err != nil {
			log.Println("could not get data from collectd: ", err.Error())
		}

		if len(data) > 0 {
			if removeTimestamp {
				data = removeTimestampFromData(data)
			}

			err = writeToFile(fileLocation, data)
			if err != nil {
				log.Println("could not write data to file: ", err.Error())
			}
		}

		time.Sleep(time.Duration(pollInterval) * time.Second)
	}
}

//getPrometheusData retrieves prometheus data from server
func getPrometheusData(collectdURL string) ([]byte, error) {
	r, err := http.Get(collectdURL)
	if err != nil {
		return nil, err
	}

	defer r.Body.Close()

	return ioutil.ReadAll(r.Body)
}

//removeTimestampFromData deletes timestamp from each line
func removeTimestampFromData(data []byte) []byte {
	lines := strings.Split(string(data), "\n")

	updatedLines := make([]string, len(lines))
	for i, line := range lines {
		//if line is empty or starts with # skip it
		if line == "" || string(line[0]) == "#" {
			updatedLines[i] = line
			continue
		}
		updatedLines[i] = strings.TrimSuffix(line, line[strings.LastIndex(line, " "):])
	}

	return []byte(strings.Join(updatedLines, "\n"))
}

//writeToFile checks if file path exists and writes data to file
func writeToFile(fileLocation string, prometheusData []byte) error {
	pathToFile := strings.TrimSuffix(fileLocation, fileLocation[strings.LastIndex(fileLocation, "/"):])
	if _, err := os.Stat(pathToFile); os.IsNotExist(err) {
		log.Fatalln("file location is not accessible")
	}

	return ioutil.WriteFile(fileLocation, prometheusData, 0644)
}
