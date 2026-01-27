FROM golang:1.25-alpine

WORKDIR /app
RUN apk add --no-cache git

# Install air
RUN go install github.com/air-verse/air@latest

EXPOSE 8080
#CMD ["air"]
CMD ["air", "-c", "gateway-service/.air.toml"]


