package main

import (
	"bufio"
	"fmt"
	"os"
	"unicode"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	var buf []string

	for scanner.Scan() {
		line := scanner.Text()
		if len(line) <= 3 {
			continue
		}

		buf = append(buf, line)
	}

	fmt.Printf("Sum: %d %d\n", sol1(buf), sol2(buf))

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Error reading standard input:", err)
	}
}

func issymbol(b byte) bool {
	return b != '.' && !unicode.IsDigit(rune(b))
}

func sol2(buf []string) int {
	sum := 0
	for i := range buf {
		for j := 0; j < len(buf[i]); j++ {
			num := 0
			for j < len(buf[i]) && unicode.IsDigit(rune(buf[i][j])) {
				num = num*10 + int(buf[i][j]) - '0'

		    }	

			sum += num
		}
	}
	return sum
}

func sol1(buf []string) int {
	sum := 0
	for i := range buf {
		for j := 0; j < len(buf[i]); j++ {
			num := 0
			adj := 0
			for j < len(buf[i]) && unicode.IsDigit(rune(buf[i][j])) {
				num = num*10 + int(buf[i][j]) - '0'

				// check for adjacent symbols
				if j != len(buf[i])-1 && issymbol(buf[i][j+1]) {
					adj = 1
				} else if j != 0 && issymbol(buf[i][j-1]) {
					adj = 1
				} else if i != 0 && issymbol(buf[i-1][j]) {
					adj = 1
				} else if i != len(buf)-1 && issymbol(buf[i+1][j]) {
					adj = 1
				} else if i != 0 && j != 0 && issymbol(buf[i-1][j-1]) {
					adj = 1
				} else if i != len(buf)-1 && j != len(buf[i])-1 && issymbol(buf[i+1][j+1]) {
					adj = 1
				} else if i != 0 && j != len(buf[i])-1 && issymbol(buf[i-1][j+1]) {
					adj = 1
				} else if i != len(buf)-1 && j != 0 && issymbol(buf[i+1][j-1]) {
					adj = 1
				}

				j++

			}

			sum += num * adj
		}
	}
	return sum
}
