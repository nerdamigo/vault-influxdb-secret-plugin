package main

import (
	"fmt"
	"math/rand"
)

func main() {
	for i := 0; i < 10; i++ {
		fmt.Printf("whatup!\n %v", rand.Intn(20))
	}
}
