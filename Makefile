.PHONY: build
build:
	tinygo build -o main.wasm -scheduler=none -target=wasi main.go

PROXYV2_IMAGE := containers.istio.tetratelabs.com/proxyv2:1.9.7-tetrate-v0

.PHONY: run-envoy
run-envoy:
	docker run --rm -p 18000:18000 -v $$(pwd)/envoy.yaml:/envoy.yaml -v $$(pwd)/main.wasm:/main.wasm --entrypoint envoy $(PROXYV2_IMAGE) -l debug -c /envoy.yaml

.PHONY: run-istio
run-istio:
	# TODO
