FROM golang:alpine

WORKDIR /go/src/app
EXPOSE 8080

RUN apk add bash
RUN go install github.com/cosmtrek/air@latest
