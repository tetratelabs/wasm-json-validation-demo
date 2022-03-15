.PHONY: build
build:
	tinygo build -o plugin.wasm -scheduler=none -target=wasi main.go

PROXYV2_IMAGE := containers.istio.tetratelabs.com/proxyv2:1.9.7-tetrate-v0

.PHONY: run-envoy
run-envoy:
	docker run --rm -p 18000:18000 -v $$(pwd)/envoy.yaml:/envoy.yaml -v $$(pwd)/plugin.wasm:/plugin.wasm --entrypoint envoy $(PROXYV2_IMAGE) -l debug -c /envoy.yaml

.PHONY: docker-build-and-push
docker-build-and-push: build
	docker build . -t ${HUB}/json-validation:v1
	docker push ${HUB}/json-validation:v1

.PHONY: run-istio
run-istio:
	# TODO
