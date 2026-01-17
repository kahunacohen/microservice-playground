package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"

	"github.com/kahunacohen/proto-gen/identity"
	"github.com/kahunacohen/proto-gen/invoice"
	"github.com/kahunacohen/proto-gen/scheduling"
	"google.golang.org/grpc"
)

func main() {
	// Create a cancellable context for the server
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// Handle OS signals for graceful shutdown
	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, os.Interrupt)

	go func() {
		<-sigs
		log.Println("Shutting down gateway...")
		cancel()
	}()

	// Create a new grpc-gateway mux
	// handles mapping between http/grcp
	mux := runtime.NewServeMux()

	// Dial options for connecting to gRPC services
	dialOpts := []grpc.DialOption{grpc.WithInsecure()}

	// Register identity service
	if err := identity.RegisterIdentityServiceHandlerFromEndpoint(ctx, mux, "identity-service:8080", dialOpts); err != nil {
		log.Fatalf("Failed to register identity service: %v", err)
	}

	// Register scheduling service
	if err := scheduling.RegisterSchedulingServiceHandlerFromEndpoint(ctx, mux, "scheduling-service:8080", dialOpts); err != nil {
		log.Fatalf("Failed to register scheduling service: %v", err)
	}

	// Register invoice service
	if err := invoice.RegisterInvoiceServiceHandlerFromEndpoint(ctx, mux, "invoice-service:8080", dialOpts); err != nil {
		log.Fatalf("Failed to register invoice service: %v", err)
	}

	// Start HTTP server
	server := &http.Server{
		Addr:    ":8080",
		Handler: mux,
	}

	log.Println("Starting HTTP gateway on :8080")
	if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		log.Fatalf("HTTP server failed: %v", err)
	}

	// Graceful shutdown
	<-ctx.Done()
	shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer shutdownCancel()
	server.Shutdown(shutdownCtx)
}

