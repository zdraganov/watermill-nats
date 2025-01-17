up:
	docker-compose up -d

test:
	go test -parallel 20 ./...

test_v:
	go test -parallel 20 -v ./...

test_short:
	go test -parallel 20 ./... -short

test_race:
	go test ./... -short -race

test_stress:
	STRESS_TEST_COUNT=4 go test -tags=stress -parallel 30 -timeout=45m ./...

test_reconnect:
	go test -tags=reconnect ./...

BENCHCNT := 1

bench:
	# benchmarks for marshalers are in _examples/marshalers/protobuf so that marshaler can be included in result
	cd _examples && go test ./marshalers/protobuf -bench=. -count $(BENCHCNT)

wait:
	go run github.com/ThreeDotsLabs/wait-for@latest localhost:4222

build:
	go build ./...

fmt:
	gofmt -l $$(find . -type f -name '*.go'| grep -v "/vendor/")
	[ "`gofmt -l $$(find . -type f -name '*.go'| grep -v "/vendor/")`" = "" ]

vet:
	go vet ./...

lint:
	@if which golangci-lint >/dev/null ; then golangci-lint run --config .golangci.yml ; else echo "WARNING: go linter not installed. To install, run\n  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b \$$(go env GOPATH)/bin v1.42.1"; fi

check: fmt vet lint

update_watermill:
	go get -u github.com/ThreeDotsLabs/watermill
	go mod tidy

	sed -i '\|go 1\.|d' go.mod
	go mod edit -fmt

