from itertools import cycle
from typing import List, Tuple, Set

def parse_input(file_path: str) -> Tuple[List[str], Tuple[int, int]]:
    with open(file_path) as f:
        grid = [line.strip() for line in f]
    start = next((y, line.index('^')) for y, line in enumerate(grid) if '^' in line)
    return grid, start


def walk(
    map: List[str],
    start: Tuple[int, int],
    obstacle: Tuple[int, int] = (-1, -1)
) -> Tuple[int, bool, Set[Tuple[int, int]]]:
    
    directions = cycle([(-1, 0), (0, 1), (1, 0), (0, -1)])  # up, right, down, left
    current_pos = start
    current_dir = next(directions)
    visited = {(current_pos, current_dir)}
    
    while True:
        new_pos = tuple(a + b for a, b in zip(current_pos, current_dir))
        
        if not (0 <= new_pos[0] < len(map) and 0 <= new_pos[1] < len(map[0])):
            break  # Out of bounds
        if map[new_pos[0]][new_pos[1]] == '#' or new_pos == obstacle:
            current_dir = next(directions)  # Change direction
        else:
            current_pos = new_pos
        
        if (current_pos, current_dir) in visited:
            return len({pos for pos, _ in visited}), True, {pos for pos, _ in visited}
        visited.add((current_pos, current_dir))
    
    return len({pos for pos, _ in visited}), False, {pos for pos, _ in visited}

def count_loops(
    map: List[str],
    start: Tuple[int, int],
    obstacles: Set[Tuple[int, int]]
) -> int:
    return sum(walk(map, start, obstacle)[1] for obstacle in obstacles)


grid, start = parse_input("input.txt")

_,_, map = walk(grid, start)
b = count_loops(grid, start, map - {start})
print(f"b: {b}")
