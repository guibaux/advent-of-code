package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main(){
    vertices := make(map[string][2]string)
    var endsWithA []string
    instructions := ""

    scanner := bufio.NewScanner(os.Stdin)
    
    fmt.Println("Ganesh trilegal")
  
    for scanner.Scan() {
        line := scanner.Text()
        if(instructions == ""){
            instructions = line
            continue
        }
        if len(line) <= 5 {
            continue
        }

        vertex := strings.TrimSpace(strings.Split(line, "=")[0])
        children := strings.Split(line, "=")[1]

        left := strings.Split(children, ",")[0]
        left = strings.Trim(left, "() ")
 
        right := strings.Split(children, ",")[1]
        right = strings.Trim(right, "() ")

        vertices[vertex] = [2]string{left, right}

        if(vertex[2] == 'A' ){
            endsWithA = append(endsWithA, vertex)
        }
    }
    
    acc := 0
    start := vertices["AAA"]

    for i := 0;; i++ {
        if(i >= len(instructions)){
            i = 0
        }
        c := instructions[i]
        if(c == 'L'){
            if(start[0] == "ZZZ"){
                break
            }
            start = vertices[start[0]] 
        }else if (c == 'R'){
            if(start[1] == "ZZZ"){
                break
            }
            start = vertices[start[1]] 
        }
        acc++
    }
    fmt.Printf("Part 1: %d\n", acc+1)

    acc = 0
    inst := 'L'
    for ;;acc++ {
        biggest := 0
        for _, node := range endsWithA {
            left := int(vertices[node][0][2] - node[2])
            right := int(vertices[node][1][2] - node[2])

            // Overflow handling
            if left > 26 {
                left = 0
            }
            if right > 26 {
                right = 0
            }

            //fmt.Printf("Right %d left: %d\n", right, left)
            if left > biggest {
                inst = 'L' 
                biggest = left
            } 
            if right > biggest {
                inst = 'R' 
                biggest = right
            }
        }
        /*if biggest == 0 {
            break 
        }
        fmt.Println(biggest)*/
        zzz := true
        for _, s := range endsWithA {
            if s[2] != 'Z' {
                //fmt.Println("Sunday ", s)
                zzz = false
                break
            }
        }
        if zzz {
            break
        }

        for i := range endsWithA {
            if inst == 'L' {
                endsWithA[i] = vertices[endsWithA[i]][0]
            } else if inst == 'R'{
                endsWithA[i] = vertices[endsWithA[i]][1]
            }
        }
    }
    
    fmt.Printf("Part 2: %d\n", acc)
}
