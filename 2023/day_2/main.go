package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	var sum1 int64 = 0
	var sum2 int64 = 0
	scanner := bufio.NewScanner(os.Stdin)

	for scanner.Scan() {
		line := scanner.Text()
		if len(line) <= 5 {
			continue
		}

        sum1 += sol1(line)
        sum2 += sol2(line)
	}

	fmt.Printf("Sum: %d %d\n", sum1, sum2)

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Error reading standard input:", err)
	}
}

func sol2(line string) int64 {
	data := strings.Split(line, ":")[1]
	rounds := strings.Split(data, ";")

	bigColor := make(map[string]int64)

	for _, round := range rounds {
		colorCounts := strings.Split(strings.TrimSpace(round), ",")

		for _, colorCount := range colorCounts {
			parts := strings.Fields(strings.TrimSpace(colorCount))
			if len(parts) == 2 {
				color := parts[1]
				countstr := parts[0]

				count, _ := strconv.ParseInt(countstr, 10, 32)

				if count > bigColor[color] {
					bigColor[color] = count
				}
			}
		}
	}

	return bigColor["red"] * bigColor["blue"] * bigColor["green"]
}

func sol1(line string) int64 {
	possible := true
	gameId := int64(0)

	re := regexp.MustCompile(`Game (\d+):`)
	matches := re.FindStringSubmatch(line)

	if len(matches) > 1 {
		gameId, _ = strconv.ParseInt(matches[1], 10, 32)
	}
	rounds := strings.Split(line, ";")

	for _, round := range rounds {
		colorCounts := strings.Split(strings.TrimSpace(round), ",")

		for _, colorCount := range colorCounts {
			parts := strings.Fields(strings.TrimSpace(colorCount))
			if len(parts) == 2 {
				color := parts[1]
				countstr := parts[0]

				count, _ := strconv.ParseInt(countstr, 10, 32)

				if color == "red" && count > 12 {
					possible = false
					break
				} else if color == "green" && count > 13 {
					possible = false
					break
				} else if color == "blue" && count > 14 {
					possible = false
					break
				}
			}
		}
	}

	if possible {
		return gameId
	}
	return 0
}
