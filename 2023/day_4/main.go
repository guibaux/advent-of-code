package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
    sum1 := 0
    sum2 := 0
	scanner := bufio.NewScanner(os.Stdin)

	for scanner.Scan() {
		line := scanner.Text()
		if len(line) <= 5 {
			continue
		}

        tmp := sol1(line)
        println(tmp)
        sum1 += tmp
        sum2 += sol2(line)
	}

	fmt.Printf("Sum: %d %d\n", sum1, sum2)

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Error reading standard input:", err)
	}
}

func sol1(line string) int {
	data := strings.Split(line, ":")[1]
	cards := strings.Split(data, "|")
    winning := strings.Split(cards[0], " ")
    draw := strings.Split(cards[1], " ")

    var win []int

    for _, card := range winning {
        tmp, _ := strconv.ParseInt(card, 10, 32)
        win = append(win, int(tmp))  
    }

    count := 0

	for _, card := range draw {
        tmp, _ := strconv.ParseInt(card, 10, 32)
        if contains(win, int(tmp)) && tmp != 0 {
            println(tmp)
            if count == 0 {
                count = 1
                continue
            }
            
            count *= 2
        }
	}

    return count
}

func contains(a []int, x int) bool {
    for _, b := range a {
            if b == x {
                return true
            }
        }
    return false
}

func sol2(line string) int {
	return 0
}
