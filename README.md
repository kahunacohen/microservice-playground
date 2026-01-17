# Microservice Playground

A test-bed for a simple, realistic, modern microservice backend.

This repository is intentionally designed as a **learning and experimentation playground**, not a production-ready system. The goal is to explore *how real microservice systems are structured*, how services communicate, and where common architectural decisions show up in practice.

The emphasis is on:
- Realistic service boundaries
- Internal service-to-service communication
- Build and code generation flows
- Avoiding overly magical abstractions

---

## High-Level Architecture

At a high level, the system consists of:

- **Gateway service**
  - Exposes a JSON/HTTP API to the outside world
  - Translates HTTP ↔ gRPC using `grpc-gateway`
  - Acts as the single external entry point

- **Internal services**
  - Communicate over gRPC
  - Are not directly exposed to the outside world
  - Represent realistic microservice boundaries

- **Protocol Buffers**
  - Define service contracts
  - Used to generate:
    - gRPC server/client code
    - HTTP gateway bindings

---

## Generated vs Committed Code

This repo intentionally draws a **clear line** between different types of generated artifacts.

### third_party/

- Contains external protobuf dependencies
- **Not committed to git**
- Generated or fetched as part of the build process
- Ignored via `.gitignore`

Rationale:
- These are pure dependencies
- They can always be re-fetched
- Keeping them out of the repo avoids noise and bloat

---

### proto-gen/

- Contains code generated from the repo’s own `.proto` files
- **Committed to git**

Rationale:
- Makes the repo easier to build and explore
- Avoids forcing every consumer to install the full protobuf toolchain
- Allows code review of API surface changes
- Reflects a common compromise seen in real-world repos

In a strict production setup, this directory might be generated in CI instead — but for a learning-focused playground, committing it is intentional.

---

## Build & Run

### Prerequisites

- Docker
- Docker Compose (v2)

### Run everything

```bash
docker compose build
docker compose up
```

This will:
- Build all services
- Fetch or generate any required dependencies
- Start the full system locally

---

## Code Generation

Protobuf code generation is handled via a script (`compile-proto.sh`), but the
playground can be run without running this script. This script is meant for the
repo maintainers.

Typical responsibilities include:
- Fetching third-party proto dependencies
- Generating gRPC server/client code
- Generating HTTP gateway bindings

The generated output is written to:
- `proto-gen/` (committed)
---

## Design Goals & Non-Goals

### Goals

- Be realistic enough to expose real architectural trade-offs
- Avoid hand-wavy abstractions
- Make service boundaries and communication explicit
- Be easy to reason about and modify

### Non-Goals

- Production hardening
- Full service mesh implementation
- Perfect security model
- Framework completeness

Those concerns are deliberately left out or deferred to keep the playground focused and understandable.

---

## Why This Exists

Many examples of microservices are either:
- Too trivial to be useful, or
- So production-heavy they obscure the fundamentals

This repo sits in the middle:

**Real enough to matter, simple enough to reason about.**

---

## Notes

- This repo favors explicit scripts over hidden automation
- Decisions are documented intentionally, even when imperfect
- The structure is expected to evolve as new experiments are added

