let list_of_string s =
  let sl = String.length s in
  let rec loop i acc =
    if i == String.length s then acc
    else loop (i + 1) (s.[sl - i - 1] :: acc)
  in loop 0 []

type group =
  | Garbage of char list
  | Subgroups of group list

let parse_garbage l =
  let rec loop acc = function
  | '!' :: v :: tl -> loop acc tl
  | '>' :: tl -> (Garbage (List.rev acc), tl)
  | x :: tl -> loop (x :: acc) tl
  | [] -> raise (Invalid_argument "Unexpected end of input in garbage")
  in loop [] l

let rec parse_group = function
  | '{' :: '}' :: tl -> (Subgroups [], tl)
  | '<' :: tl -> parse_garbage tl
  | '{' :: tl -> begin
      let rec loop acc l =
        let (item, tl) = parse_group l in
        match tl with
        | ',' :: l -> loop (item :: acc) l
        | '}' :: tl -> (Subgroups (item :: acc), tl)
        | [] -> raise (Invalid_argument "Unexpected end of input in sub-group")
        | v -> raise (Invalid_argument "Unexpected value in sub-group")
      in loop [] tl
    end
  | [] -> raise (Invalid_argument "Unexpected end of input in group")
  | v -> raise (Invalid_argument "Unexpected value in group")

let rec score_subgroups base = function
  | Subgroups ls -> base + List.fold_left (fun acc c -> acc + score_subgroups (base + 1) c) 0 ls
  | Garbage _ -> 0

let rec sum_garbage = function
  | Subgroups ls -> List.fold_left (fun acc c -> acc + sum_garbage c) 0 ls
  | Garbage g -> List.length g

let solve () = 
  let (data, _) = read_line () |> list_of_string |> parse_group in
  let score = score_subgroups 1 data in
  let garbage = sum_garbage data in
  Printf.printf "Score: %i, garbage %i" score garbage

let () = solve ()