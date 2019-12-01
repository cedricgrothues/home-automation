FROM golang:latest

# Add Maintainer Info
LABEL maintainer="Cedric Grothues <cedricgrothues@gmail.com>"

WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY ./service.config ./

# Build the Go app
RUN go build -o main .

# Expose port 8080 to the outside world
EXPOSE 4001

# Command to run the executable
CMD ["./main"]
