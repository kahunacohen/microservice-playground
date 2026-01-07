package main

import (
	"fmt"
	"time"
)

func main() {
	for {
		fmt.Println("scheduling server")
		time.Sleep(5 * time.Second)
	}
}
