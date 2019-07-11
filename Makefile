ROOT_DIR:=$(shell git rev-parse --show-toplevel)
REPO:=$(shell git rev-parse --show-toplevel | sed 's/.*github/github/')
GOFILES:=$(shell find . -name '*.go' | grep -v -E '(./vendor)')
IMAGE_REPO=
IMAGE_TAG:=$(shell $(ROOT_DIR)/hack/git-version.sh)
VERSION_OVERRIDE:=$(shell git describe --abbrev=8 --dirty --always)
HASH:=$(shell git rev-parse --verify 'HEAD^{commit}')
BUILD_DATE:=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
GLDFLAGS=-X $(REPO)/pkg/version.versionFromGit=$(VERSION_OVERRIDE) -X $(REPO)/pkg/version.commitFromGit=$(HASH) -X $(REPO)/pkg/version.buildDate=$(BUILD_DATE)
GOFALGS=

$(shell mkdir -p bin)

build: bin/cluster-etcd-operator bin/setup-etcd-environment

bin/%: $(GOFILES) 
	@echo Building $@
	@go build $(GOFLAGS) -ldflags "$(GLDFLAGS)" -o $(ROOT_DIR)/$@ github.com/openshift/cluster-etcd-operator/cmd/$*

test-unit:
	@go test -v ./...

verify:
	@go vet $(shell go list ./... | grep -v /vendor/)

verify-deps:
	@go mod tidy
	@go mod vendor
	@go mod verify

clean:
	rm -rf $(ROOT_DIR)/bin

.PHONY: build clean verify-deps
