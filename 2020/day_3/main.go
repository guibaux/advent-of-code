package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"
)

func slope(trees []string, x int, y int) int {
	local := []int{0, 0}
	count := 0
	for {
		local[0] += y
		local[1] += x
		diff := (len(trees[0]) - 1) - local[1]
		if diff < 0 {
			local[1] = -diff - 1
		}
		if local[0] >= len(trees)-1 {
			break
		}
		// Path
		//fmt.Printf("Y: %d, X: %d\n", local[0], local[1])
		if trees[local[0]][local[1]] == '#' {
			count++
		}
	}
	return count
}

func main() {
	file, err := os.Open("input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	b, err := ioutil.ReadAll(file)
	trees := strings.Split(string(b), "\n")

	fmt.Printf("%d trees\n", slope(trees, 3, 1))
	fmt.Printf("%d more trees\n", slope(trees, 1, 1)*slope(trees, 3, 1)*
		slope(trees, 5, 1)*slope(trees, 7, 1)*slope(trees, 1, 2))
}
