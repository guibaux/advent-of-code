package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"regexp"
	"strings"
)

func main() {
	file, err := os.Open("input.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	b, err := ioutil.ReadAll(file)
	passports := strings.Split(string(b), "\n\n")
	fields := []string{"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"}

	regex_fields := []string{"byr:(1|2)(9[2-9][0-9]|00[0-2])( |\n)", "iyr:20(1[0-9]|20)( |\n)",
		"eyr:20(2[0-9]|30)( |\n)", "hgt:(1([5-8][0-9]|9[0-3])cm|(59|(6[0-9]|7[0-6]))in)( |\n)",
		"hcl:#([0-9]|[a-f]){6}( |\n)", "ecl:(amb|blu|brn|gry|grn|hzl|oth)( |\n)", "pid:[0-9]{9}( |\n)"}

	count := len(passports)
	for _, v := range passports {
		for _, field := range fields {
			if !strings.Contains(v, field) {
				count--
				break
				//fmt.Printf("%s", v)
			}
		}
	}
	fmt.Printf("Valid: %d\n", count)

	count = len(passports)
	for _, v := range passports {
		for _, ptrn := range regex_fields {
			m, _ := regexp.MatchString(ptrn, v+"\n")
			if !m {
				count--
				break
			}
		}
	}
	fmt.Printf("Ultra valid: %d", count)
}
