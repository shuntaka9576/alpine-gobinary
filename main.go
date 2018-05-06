package main

import (
	"fmt"
	"time"
)

func main() {
	now := time.Now().Format("20060102 15:04")
	fmt.Println(now, "Hello!")
}
