# Build stage
FROM golang:1.24.1-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod tidy && go build -o main ./app

# Run stage
FROM alpine:latest
WORKDIR /opt/main
COPY --from=builder /app/main .
EXPOSE 4444
ENTRYPOINT ["./main"]