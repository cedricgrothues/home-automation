# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang:latest

# Add Maintainer Info
LABEL maintainer="Cedric Grothues <cedricgrothues@gmail.com>"

ADD ./libraries/go /go/src/github.com/cedricgrothues/home-automation/libraries/go
ADD ./service.api-gateway /go/src/github.com/cedricgrothues/home-automation/service.api-gateway

# Build the service.api-gateway command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
RUN go get -v -t -d github.com/cedricgrothues/home-automation/...
RUN go build -o app github.com/cedricgrothues/home-automation/service.api-gateway

# Document that the service listens on port 4000.
EXPOSE 4000

# Run the service.api-gateway command by default when the container starts.
CMD [ "./app", "/go/src/github.com/cedricgrothues/home-automation/service.api-gateway/config.yaml" ]