# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang

# Add Maintainer Info
LABEL maintainer="Cedric Grothues <cedricgrothues@gmail.com>"

ADD ./service.advertise.ssdp /go/src/github.com/cedricgrothues/home-automation/service.advertise.ssdp

# Build the service.advertise.ssdp command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
RUN go get -v -t -d github.com/cedricgrothues/home-automation/service.advertise.ssdp/...
RUN go install github.com/cedricgrothues/home-automation/service.advertise.ssdp

# Run the service.advertise.ssdp command by default when the container starts.
ENTRYPOINT /go/bin/service.advertise.ssdp

# Document that the service listens on port 1900.
EXPOSE 1900