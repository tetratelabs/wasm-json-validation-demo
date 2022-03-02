# Example JSON Payload validation by Proxy-Wasm Go

`main.go` demonstrates how to perform validation on a request body.

This wasm plugin checks whether the request has JSON payload and has required keys in it.
If not, the wasm plugin ceases the further process of the request and returns 403 immediately.

See https://github.com/tetratelabs/proxy-wasm-go-sdk/ for the detailed document of proxy-wasm-go SDK.

### Build

```sh
make build
```

### Run it via Envoy

`envoy.yaml` is the example envoy config file that you can use for running the wasm plugin
with standalone Envoy.
The following make rule will run the wasm plugin in the version of Envoy used in the Istio 1.9 sidecar.

```sh
make run-envoy
```

Envoy listens on `localhost:18000`, responding to any requests with static content "hello from server".
However, the wasm plugin also runs to validate the requests' payload.
The plugin intercepts the request and makes Envoy return 403 instead of the static content
if the request has no JSON payload or the payload JSON doesn't have "id" or "token" keys.

```console
# Returns the normal response when the request has the required keys, id and token.
$ curl -X POST localhost:18000 -H 'Content-Type: application/json' --data '{"id": "xxx", "token": "xxx"}'
hello from the server

# Returns 403 when the request has missing required keys.
$ curl -v -X POST localhost:18000 -H 'Content-Type: application/json' --data '"required_keys_missing"'
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1:18000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 18000 (#0)
> POST / HTTP/1.1
> Host: localhost:18000
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Type: application/json
> Content-Length: 23
>
* upload completely sent off: 23 out of 23 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 403 Forbidden
< content-length: 15
< content-type: text/plain
< date: Tue, 01 Mar 2022 19:22:24 GMT
< server: envoy
<
* Connection #0 to host localhost left intact
invalid payload

```

### Run it via Istio

TODO: write instructions. Basically just follow this https://istio.io/v1.9/docs/ops/configuration/extensibility/wasm-module-distribution/
