FROM golang:1.23-alpine AS builder

WORKDIR /app

COPY go.mod ./
COPY . .

# Regenerate go.sum and build the application
RUN go mod tidy && \
    CGO_ENABLED=0 GOOS=linux go build -o main .

FROM alpine:latest

# Add non-root user for security
RUN adduser -D appuser
USER appuser

WORKDIR /app

# Copy the pre-built binary file from the previous stage
COPY --from=builder /app/main .

EXPOSE 8080

CMD ["./main"]
