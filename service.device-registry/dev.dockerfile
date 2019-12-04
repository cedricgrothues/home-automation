# Start from the latest golang base image
FROM golang:latest as builder

# Add Maintainer Info
LABEL maintainer="Cedric Grothues <cedricgrothues@gmail.com>"
RUN git config --global url."https://7ec4a2a97066a54cc8a2ad26cea80c5c2c5a2882:@github.com/".insteadOf "https://github.com/"

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY ./service.device-registry ./
RUN go get -v -t -d ./...

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .


FROM alpine:latest  

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/main .

# Expose port 4000 to the outside world
EXPOSE 4000

# Command to run the executable
CMD ["./main"] 