package main

import (
	"context"
	"log"
	"net"

	identitypb "github.com/kahunacohen/proto-gen/identity"

	"google.golang.org/grpc"
	"google.golang.org/protobuf/types/known/emptypb"
)

// Server struct
type identityServer struct {
	identitypb.UnimplementedIdentityServiceServer
}

// Implement the RPC
func (s *identityServer) GetIdentity(
	ctx context.Context,
	req *identitypb.GetIdentityRequest,
) (*identitypb.GetIdentityResponse, error) {

	// Dummy data for now
	identity := &identitypb.Identity{
		Id:         req.Id,
		Name:       "Alice Example",
		Email:      "alice@example.com",
		NationalId: "123456789",
	}

	return &identitypb.GetIdentityResponse{
		Identity: identity,
	}, nil
}

func (s *identityServer) DeleteIdentity(ctx context.Context, req *identitypb.DeleteIdentityRequest) (*emptypb.Empty, error) {
	return nil, nil
}

func main() {
	lis, err := net.Listen("tcp", ":9090") // internal container port
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer()
	identitypb.RegisterIdentityServiceServer(grpcServer, &identityServer{})

	log.Println("gRPC server listening on :9090")
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
