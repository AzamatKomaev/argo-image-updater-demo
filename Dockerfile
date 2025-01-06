# syntax=docker/dockerfile:1
FROM golang:1.23 AS build

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY .. ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /ping

# Run the tests in the container
#FROM build-stage AS run-test-stage
#RUN go test -v ./...

# Deploy the application binary into a lean image
FROM gcr.io/distroless/base-debian11 AS release

WORKDIR /

COPY --from=build /ping /ping

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/ping"]