# Build stage
FROM golang:1.22.5 AS base
WORKDIR /app

COPY go.mod .
RUN go mod download

COPY . .
RUN go build -o main .

################################################################################
# Final stage (minimal distroless image)
FROM gcr.io/distroless/base
WORKDIR /app

# Copy the compiled Go binary from the build stage
COPY --from=base /app/main .

# Copy static assets (HTML, CSS, JS, etc.)
COPY --from=base /app/static ./static

# Expose application port (adjust if your app uses a different port)
EXPOSE 8080

# Command to run the application
CMD ["./main"]
