type equation = { expected : int; nums : int list }

let parse_line line =
  let parts = String.split_on_char ':' line in
  match parts with
  | [expected_str; nums_str] ->
      let expected = int_of_string (String.trim expected_str) in
      let nums =
        nums_str
        |> String.trim
        |> String.split_on_char ' '
        |> List.map int_of_string
      in
      { expected; nums }
  | _ -> failwith "Invalid input format"

let generate_possibilities head possibilities include_concat =
  let plus = List.map (fun i -> i + head) possibilities in
  let times = List.map (fun i -> i * head) possibilities in
  let concat =
    if include_concat then
      List.map
        (fun i ->
          int_of_string (string_of_int i ^ string_of_int head))
        possibilities
    else []
  in
  plus @ times @ concat

let solve1 { expected; nums } =
  let rec loop nums =
    match nums with
    | [head] -> [head]
    | head :: tail ->
        let possibilities = List.filter (fun i -> i <= expected) (loop tail) in
        generate_possibilities head possibilities false
    | [] -> raise (Invalid_argument "Invalid input")
  in
  let possibilities = loop (List.rev nums) in
  if List.exists ((=) expected) possibilities then expected else 0

let solve2 { expected; nums } =
  let rec loop nums =
    match nums with
    | [head] -> [head]
    | head :: tail ->
        let possibilities = List.filter (fun i -> i <= expected) (loop tail) in
        generate_possibilities head possibilities true
    | [] -> raise (Invalid_argument "Invalid input")
  in
  let possibilities = loop (List.rev nums) in
  if List.exists ((=) expected) possibilities then expected else 0

let solve lines =
  let solve_part solve1 =
    List.fold_left
      (fun acc line -> acc + (parse_line line |> solve1))
      0 lines
  in
  (solve_part solve1, solve_part solve2)

let read_lines filename =
  let in_channel = open_in filename in
  let rec read_all_lines acc =
    match input_line in_channel with
    | line -> read_all_lines (line :: acc)
    | exception End_of_file ->
      close_in in_channel;
      List.rev acc
  in
  read_all_lines []

let () =
  match read_lines "./input.txt" |> solve with
  | a, b -> Printf.printf "a: %d\nb: %d\n" a b
