module StrSet = Set.Make(String);;

let sort_str s =
  let len = String.length s in
  let chars = Array.init len (String.get s) in
  let () = Array.sort Char.compare chars in
  String.init len (Array.get chars)

let process_line_p2 line =
  let parts = Str.split (Str.regexp "[ \t]") line
    |> List.map sort_str in
  let uniques = StrSet.of_list parts in
  if StrSet.cardinal uniques = List.length parts then 1 else 0

let process_line line =
  let parts = Str.split (Str.regexp "[ \t]") line in
  let uniques = StrSet.of_list parts in
  if StrSet.cardinal uniques = List.length parts then 1 else 0

let solve process_line =
  let rec loop acc =
    match process_line (read_line ()) with
    | n -> loop (acc + n)
    | exception End_of_file -> acc
  in
  let num = loop 0 in
  Printf.printf "Valid: %i\n" num

(* let () = solve process_line *)
let () = solve process_line_p2