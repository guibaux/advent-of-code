proc part1(file: string): seq[int] = 
    var ids: seq[int]
    
    for line in lines file:
        var halfs = [0, 127]
        var cols  = [0,   7]
        
        for l in line:
            let half     = (halfs[1] + halfs[0]) div 2
            let col_half = (cols[1]  + cols[0])  div 2
            case l:
                of 'F':
                    halfs[1] = half 
                of 'B':
                    halfs[0] = half 
                of 'L':
                    cols[1]  = col_half 
                of 'R':
                    cols[0]  = col_half 
                else:
                    echo "Uga Buga this file is not correct"
        
        let seat_id = (halfs[1] * 8) + cols[1]
        ids.add(seat_id)    
    return ids

proc part2(ids: seq[int]): int = 
    for id in ids:
        if not ids.contains(id + 1) and ids.contains(id + 2):
            result = id + 1


let ids = part1("input.txt")

echo "Highest Seat ID: ", ids.max 
echo "My seat ID: ", part2(ids) 
