# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang

# Add Maintainer Info
LABEL maintainer="Cedric Grothues <cedricgrothues@gmail.com>"
RUN git config --global url."https://589b62795c79fff2fee9152874dc3dfcf6381ef6:@github.com/".insteadOf "https://github.com/"

COPY .git/ /go/src/github.com/cedricgrothues/home-automation/.git/
ADD ./libraries/go /go/src/github.com/cedricgrothues/home-automation/libraries/go
ADD ./service.controller.sonoff /go/src/github.com/cedricgrothues/home-automation/service.controller.sonoff

# Build the service.controller.sonoff command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
RUN go get -v -t -d github.com/cedricgrothues/home-automation/service.controller.sonoff/...
RUN go install github.com/cedricgrothues/home-automation/service.controller.sonoff

# Run the service.controller.sonoff command by default when the container starts.
ENTRYPOINT /go/bin/service.controller.sonoff

# Document that the service listens on port 4002.
EXPOSE 4002