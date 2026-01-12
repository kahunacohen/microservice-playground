package main

import (
	"fmt"
	"time"
)

func main() {
	for {
		fmt.Println("gateway-service...")
		time.Sleep(2 * time.Second)
	}
}
