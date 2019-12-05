# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang

# Add Maintainer Info
LABEL maintainer="Cedric Grothues <cedricgrothues@gmail.com>"
RUN git config --global url."https://589b62795c79fff2fee9152874dc3dfcf6381ef6:@github.com/".insteadOf "https://github.com/"

ADD . go/src/github.com/cedricgrothues/home-automation/

# Build the outyet command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
RUN go get -v -t -d ./...
RUN go install github.com/cedricgrothues/home-automation/service.device-registry

# Run the outyet command by default when the container starts.
ENTRYPOINT /go/bin/service.device-registry

# Document that the service listens on port 8080.
EXPOSE 4001