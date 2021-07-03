.PHONY: all
all: build
FORCE: ;

SHELL  := env LIBRARY_ENV=$(LIBRARY_ENV) $(SHELL)
LIBRARY_ENV ?= dev

BIN_DIR = $(PWD)/bin

.PHONY: build

docker-build:
	docker build -t gandolfo/hello-go:$(v) .

docker-run:
	docker run -it --rm -p 8080:8080 gandolfo/hello-go:$(v)

docker-push:
	docker push gandolfo/hello-go:$(v)

docker-flow:
	make docker-build v=$(v) && make docker-push v=$(v) 

kind-init: 
	kind create cluster --config=k8s/kind.yml --name=gand && kubectl cluster-info --context kind-gand

kind-clear:
	kind delete cluster --name=gand

k8s-init:
	kubectl apply -f k8s/secrets.yml
	kubectl apply -f k8s/configmap-env.yml
	kubectl apply -f k8s/deployment.yaml
	kubectl apply -f k8s/service.yaml
	kubectl apply -f k8s/hpa.yml 

apiservices:
	kubectl get apiservices

