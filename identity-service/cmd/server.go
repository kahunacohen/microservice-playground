package main

import (
	"fmt"
	"time"
)

func main() {
	for {
		fmt.Println("identity server")
		time.Sleep(5 * time.Second)
	}
}
