(* let start_string = "abcde" *)
let start_string = "abcdefghijklmnop"

type move =
  | Spin of int
  | Exchange of int * int
  | Partner of char * char

let parse line =
  let parse_part part = 
    let part_rest = String.sub part 1 (String.length part - 1) in
    match part.[0] with
    | 's' -> Spin (int_of_string part_rest)
    | 'x' ->
      let args = Str.split (Str.regexp "/") part_rest in
      Exchange (List.nth args 0 |> int_of_string, List.nth args 1 |> int_of_string)
    | 'p' -> Partner (part_rest.[0], part_rest.[2])
    | _ -> raise (Invalid_argument "Unknown command")
  in
  Str.split (Str.regexp ",") line
  |> List.map parse_part

let apply_move m s = match m with
  | Spin n ->
    let right_len = String.length s - n in
    let left = String.sub s right_len n in
    let right = String.sub s 0 right_len in
    left ^ right
  | Exchange (i1, i2) ->
    let b = Bytes.of_string s in
    let t = Bytes.get b i1 in
    let () = Bytes.get b i2 |> Bytes.set b i1 in
    let () = Bytes.set b i2 t in
    Bytes.to_string b
  | Partner (p1, p2) ->
    String.map (fun p ->
      if p = p1 then p2
      else if p = p2 then p1
      else p) s

let apply_dance ms p =
  List.fold_left (fun p m -> apply_move m p) p ms

let generate_cycle ms p =
  let rec loop acc =
    let next = apply_dance ms (acc.(Array.length acc - 1)) in
    if next = p then acc
    else loop (Array.append acc [|next|])
  in loop [|p|]
  
let iterate n ms p =
  let cycle = generate_cycle ms p in
  let i = n mod (Array.length cycle) in
  cycle.(i)

let () = iterate 1_000_000_000 (read_line () |> parse) start_string
  |> Printf.printf "Final string: %s\n"
