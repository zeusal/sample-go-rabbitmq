FROM golang:1.12.1 as builder

# Copy the code from the host and compile it
WORKDIR $GOPATH/src/sample-go-rabbitmq

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go install ./cmd/*

FROM alpine:3.6 as alpine

RUN apk add -U --no-cache ca-certificates

FROM scratch
COPY --from=builder /go/bin/receive /go/bin/send /usr/local/bin/
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
CMD ["receive"]
