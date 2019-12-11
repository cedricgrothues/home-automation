# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang

# Add Maintainer Info
LABEL maintainer="Cedric Grothues <cedricgrothues@gmail.com>"

ADD ./libraries/go /go/src/github.com/cedricgrothues/home-automation/libraries/go
ADD ./service.api-gateway /go/src/github.com/cedricgrothues/home-automation/service.api-gateway

# Build the service.api-gateway command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
RUN go get -v -t -d github.com/cedricgrothues/home-automation/...
RUN go install github.com/cedricgrothues/home-automation/service.api-gateway

# Run the service.api-gateway command by default when the container starts.
ENTRYPOINT /go/bin/service.api-gateway /go/src/github.com/cedricgrothues/home-automation/service.api-gateway/config.yaml

# Document that the service listens on port 8080.
EXPOSE 4000