package main

import (
	"context"
	"log"
	"net"

	pb "github.com/kahunacohen/microservice-playground/identity-service/proto"
	"google.golang.org/grpc"
)

// Server struct
type identityServer struct {
	pb.UnimplementedIdentityServiceServer
}

// Implement the RPC
func (s *identityServer) GetIdentity(
	ctx context.Context,
	req *pb.GetIdentityRequest,
) (*pb.GetIdentityResponse, error) {

	// Dummy data for now
	identity := &pb.Identity{
		Id:         req.Id,
		Name:       "Alice Example",
		Email:      "alice@example.com",
		NationalId: "123456789",
	}

	return &pb.GetIdentityResponse{
		Identity: identity,
	}, nil
}

func (s *identityServer) DeleteIdentity(ctx context.Context, id int) error {
	return nil
}

func main() {
	lis, err := net.Listen("tcp", ":9090") // internal container port
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer()
	pb.RegisterIdentityServiceServer(grpcServer, &identityServer{})

	log.Println("gRPC server listening on :9090")
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
