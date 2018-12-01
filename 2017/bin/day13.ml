let parse_line l = match Str.split (Str.regexp ": ") l with
  | depth :: range :: _ -> (int_of_string depth, int_of_string range)
  | _ -> raise (Invalid_argument "Invalid line")

let parse_lines () =
  let ranges = Hashtbl.create 10 in
  let chan = open_in "day13.txt" in
  let rec loop max_depth =
    (* match read_line () |> parse_line with *)
    match input_line chan |> parse_line with
    | (d, r) -> let () = Hashtbl.add ranges d r in loop (max max_depth d)
    | exception End_of_file -> (ranges, max_depth)
  in
  let (ranges, max_depth) = loop 0 in
  Array.init (max_depth + 1)
    (fun i -> match Hashtbl.find ranges i with
    | n -> n
    | exception Not_found -> 0)

let run delay ranges =
  let max_depth = Array.length ranges in
  let rec loop i sum hit =
    if i = max_depth then (sum, hit)
    else match ranges.(i) with
    | 0 -> loop (i + 1) sum hit
    | r when (i + delay) mod (r * 2 - 2) == 0 -> loop (i + 1) (sum + i * r) true
    | r -> loop (i + 1) sum hit
  in loop 0 0 false

let first_zero config =
  let rec loop i =
    match run i config with
    | (_, true) -> loop (i + 1)
    | (_, false) -> i
  in loop 0

(* let () = parse_lines () |> run 0 |> fst |> Printf.printf "Score: %i\n" *)

let () = parse_lines () |> first_zero |> Printf.printf "Minimum delay: %i\n"
