let process_line_p1 line =
  let num_strs = Str.split_delim (Str.regexp "[ \t]") line in
  let numbers = List.map int_of_string num_strs in
  match numbers with
  | first :: _ -> 
    let max = List.fold_left max first numbers in
    let min = List.fold_left min first numbers in
    max - min
  | [] -> 0


let evenly_divisble n1 n2 =
  (n1 mod n2) = 0

let rec divide_one_step n1 l =
  match l with
  | hd :: tl when evenly_divisble n1 hd -> n1 / hd
  | hd :: tl when evenly_divisble hd n1 -> hd / n1
  | _ :: tl -> divide_one_step n1 tl
  | [] -> 0

let process_line_p2 line = 
  let numbers = Str.split_delim (Str.regexp "[ \t]") line |> List.map int_of_string in
  let rec outer_loop numbers = match numbers with
    | hd :: tl -> begin match divide_one_step hd tl with
        | 0 -> outer_loop tl
        | v -> v
      end
    | [] -> 0
  in
  outer_loop numbers

let read_loop process_line =
  let rec loop acc =
    try loop (acc + process_line (read_line ()))
    with End_of_file -> acc
  in
  let sum = loop 0 in
  Printf.printf "Sum: %i\n" sum

(* let () = read_loop process_line_p1 *)
let () = read_loop process_line_p2