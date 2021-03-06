## Data model
*Metric*: a single semantic measurement that may have many label dimensions.

*Time-series*: a sequence of data points identified by a metric *and* a set of
key-value pairs (labels). Each time-series is uniquely identified by its metric
name and labels. Any given combination of labels for the same metric name
identifies a particular dimensional instantiation of that metric .

*Metric name*: `[a-zA-Z_:][a-zA-Z0-9_:]*` (for example, http_requests_total)

*Label name*: `[a-zA-Z_][a-zA-Z0-9_]*`. Label names beginning with `__` are
reserved for internal use.

A sample time-series for metric `api_http_requests_total` with labels `method`
and `handler`:

    api_http_requests_total{method="POST", handler="/messages"}


## HTTP API

Instant queries (a single data point for each matching timeseries)

    GET /api/v1/query --data-urlencode '<query>'

    curl -G host:9090/api/v1/query --data-urlencode 'query=node_memory_MemFree{instance="10.2.0.10:9100"}' | jq -r

Range queries (multiple data points for each matching timeseries)

    GET /api/v1/query --data-urlencode '<query>' --data-urlencode 'start=<time>" --data-urlencode 'end=<time>' --data-urlencode 'step=<duration>'

    curl -G host:9090/api/v1/query_range --data-urlencode 'query=node_memory_MemFree{instance="10.2.0.10:9100"}' --data-urlencode 'start=2018-04-20T06:48:34.000Z' --data-urlencode "end=2018-04-20T08:53:45.000Z" --data-urlencode 'step=30s'


### Finding time-series matching a certain metric name and/or label set

    GET /api/v1/series --data-urlencode 'match[]=<series_selector>' --data-urlencode 'start=<time>" --data-urlencode 'end=<time>'

Find all time-series with a metric name `process_open_fds`:

    curl -G host:9090/api/v1/series --data-urlencode 'match[]=process_open_fds'

Find all time-series with a metric name starting with `node`:

    curl -G host:9090/api/v1/series --data-urlencode 'match[]={__name__=~"node.+"}'

Find all time-series with a metric name starting with 'node' and a label
`instance=10.2.0.11:9100`:

    curl -G host:9090/api/v1/series --data-urlencode 'match[]={__name__=~"node.+", instance="10.2.0.11:9100"}'

Find all time-series with a label `job=node-exporter`:

    curl -G host:9090/api/v1/series --data-urlencode 'match[]={job="node-exporter"}'

### Finding label values


Find all metrics (that is, find all label values for the `__name__` label):

    curl host:9090/api/v1/label/__name__/values

Find all scrape target names (jobs):

    curl host:9090/api/v1/label/job/values

Find time-series per scrape target (note: time-consuming!)

    for job in $(curl -G 10.2.0.10:30900/api/v1/label/job/values | jq -r '.data[]'); do
        echo "************************************************"
        echo "all time-series for target/job ${job}:"
        curl -G 10.2.0.10:30900/api/v1/series --data-urlencode "match[]={job=\"${job}\"}" | jq -r '.'
    done | tee per-scraper-time-series.txt


### Scrape targets

    GET /api/v1/targets

    curl -v -G 10.2.0.10:30900/api/v1/targets
