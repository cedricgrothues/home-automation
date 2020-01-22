# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang

# Add Maintainer Info
LABEL maintainer="Cedric Grothues <cedricgrothues@gmail.com>"

COPY .git/ /go/src/github.com/cedricgrothues/home-automation/.git/
ADD ./libraries/go /go/src/github.com/cedricgrothues/home-automation/libraries/go
ADD ./modules/sonos /go/src/github.com/cedricgrothues/home-automation/modules/sonos

# Build the modules.sonos command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
RUN go get -v -t -d github.com/cedricgrothues/home-automation/modules/sonos/...
RUN go install github.com/cedricgrothues/home-automation/modules/sonos

# Run the modules.sonos command by default when the container starts.
ENTRYPOINT /go/bin/sonos

# Document that the service listens on port 4003.
EXPOSE 4003