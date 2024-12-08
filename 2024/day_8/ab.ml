let read_lines filename =
  let ic = open_in filename in
  let rec read acc =
    match input_line ic with
    | line -> read (line :: acc)
    | exception End_of_file -> close_in ic; List.rev acc
  in
  read []

let positions input =
  let table = Hashtbl.create 256 in
  List.iteri (fun y row ->
    String.iteri (fun x char ->
      if char <> '.' then
        let char_positions =
          match Hashtbl.find_opt table char with
          | Some lst -> lst
          | None -> []
        in
        Hashtbl.replace table char ((x, y) :: char_positions)
    ) row
  ) input;
  table

let in_bounds input x y =
  y >= 0 && y < List.length input && x >= 0 && x < String.length (List.nth input y)

let solve1 input =
  Hashtbl.fold (fun _ positions acc ->
    let pairs =
      List.concat_map (fun p1 ->
        List.map (fun p2 ->
          let (x1, y1), (x2, y2) = p1, p2 in
          (2 * x1 - x2, 2 * y1 - y2)
        ) (List.filter ((<>) p1) positions)
      ) positions
    in
    let valid_positions = List.filter (fun (x, y) -> in_bounds input x y) pairs in
    List.fold_left (fun acc pos -> if List.mem pos acc then acc else pos :: acc) acc valid_positions
  ) (positions input) []
  |> List.length

let solve2 input =
  Hashtbl.fold (fun _ positions acc ->
    let all_chains =
      List.concat_map (fun p1 ->
        List.concat_map (fun p2 ->
          let (x1, y1), (x2, y2) = p1, p2 in
          let dx, dy = x2 - x1, y2 - y1 in
          let rec trace_chain v acc =
            let nx, ny = x1 - dx * v, y1 - dy * v in
            if in_bounds input nx ny then
              trace_chain (v + 1) ((nx, ny) :: acc)
            else
              acc
          in
          trace_chain 0 []
        ) (List.filter ((<>) p1) positions)
      ) positions
    in
    List.fold_left (fun acc pos -> if List.mem pos acc then acc else pos :: acc) acc all_chains
  ) (positions input) []
  |> List.length

let () = 
    let input = read_lines "input.txt" in
    let a = solve1 input in
    let b = solve2 input in
    Printf.printf "a: %d\nb: %d\n" a b

