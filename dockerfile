FROM golang:1.16 as builder

RUN mkdir /app
WORKDIR /app
COPY . .

RUN go env -w GOPROXY=https://goproxy.cn,direct
RUN go mod download

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -a -o the_binary main.go

FROM alpine:3.14.1
WORKDIR /
COPY --from=builder /app/the_binary .

ENTRYPOINT ["/the_binary"]
