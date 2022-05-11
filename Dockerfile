# syntax = docker/dockerfile:1.2
# Dockerfile References: https://docs.docker.com/engine/reference/builder/

# Start from the latest golang base image
FROM golang:1.17-alpine AS builder

# Add Maintainer Info
LABEL maintainer="ming luo"
LABEL stage=build

RUN apk update && apk --no-cache add build-base git

# for confluent kafka goclient
RUN apk add g++ libc-dev librdkafka-dev pkgconf

# Build Delve
RUN go get github.com/google/gops

WORKDIR /root/
COPY . .
RUN go mod download

RUN --mount=type=cache,target=/root/.cache/go-build cd /root/src && \
  GIT_COMMIT=$(git rev-list -1 HEAD) && \
  go build -tags musl -o perf -ldflags "-X main.gitCommit=$GIT_COMMIT"

######## Start a new stage from scratch #######
FROM alpine

# RUN apk update
WORKDIR /root/bin
RUN mkdir /root/config/

# Copy debug tools
COPY --from=builder /go/bin/gops /root/bin

# Copy the Pre-built binary file and default configurations from the previous stage
COPY --from=builder /root/src/perf /root/bin

# Command to run the executable
# ENTRYPOINT []
