package main

import (
	"fmt"
	"time"
)

func main() {
	for {
		fmt.Println("serving invoice service...")
		time.Sleep(1 * time.Second)
	}
}
