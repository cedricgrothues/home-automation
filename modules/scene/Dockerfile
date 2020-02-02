# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang

# # Add Maintainer Info
LABEL maintainer="Cedric Grothues <cedricgrothues@gmail.com>"

COPY .git/ /go/src/github.com/cedricgrothues/home-automation/.git/
ADD ./libraries/go /go/src/github.com/cedricgrothues/home-automation/libraries/go
ADD ./modules/scene /go/src/github.com/cedricgrothues/home-automation/modules/scene

# Build the core.api-gateway command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
RUN go get -v -t -d github.com/cedricgrothues/home-automation/modules/scene/...
RUN go install github.com/cedricgrothues/home-automation/modules/scene

# Run the service.schedule command by default when the container starts.
ENTRYPOINT /go/bin/scene

# Document that the service listens on port 4006.
EXPOSE 4006