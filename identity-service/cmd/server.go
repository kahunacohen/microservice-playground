package main

import (
	"fmt"
	"time"
)

func main() {
	for {
		fmt.Println("serving...")
		time.Sleep(1 * time.Second)
	}
}
