let parse_line line =
  let m = Str.string_match (Str.regexp "^\\([^ ]+\\) <-> \\(.*\\)$") line 0 in
  let () = assert m in
  let f = Str.matched_group 1 line |> int_of_string |> Int32.of_int in
  let t = Str.matched_group 2 line
          |> Str.split (Str.regexp ", ")
          |> List.map int_of_string
          |> List.map Int32.of_int in
  f, t

module IntSet = Set.Make(Int32)

let build_graph lines =
  let conns = Hashtbl.create 20 in
  let add_conn f t =
    let () = match Hashtbl.find_all conns f with
      | [] -> Hashtbl.add conns f (IntSet.add t IntSet.empty)
      | x :: _ -> Hashtbl.replace conns f (IntSet.add t x)
    in match Hashtbl.find_all conns t with
    | [] -> Hashtbl.add conns t (IntSet.add f IntSet.empty)
    | x :: _ -> Hashtbl.replace conns t (IntSet.add f x)
  in
  let () = List.iter (fun (f, t) ->
      List.iter (fun t ->
          add_conn f t)
        t) lines in
  conns

let find_conns i conns =
  let rec find_conns f acc =
    match Hashtbl.find_all conns f with
    | [] -> acc
    | ts :: _ -> 
      IntSet.fold (fun t acc ->
          if IntSet.mem t acc then acc
          else find_conns t (IntSet.add t acc))
        ts acc
  in find_conns i IntSet.empty

let find_all_groups conns =
  let all_ids = Hashtbl.fold (fun k _ acc -> IntSet.add k acc) conns IntSet.empty in
  let rec loop remain count =
    if IntSet.is_empty remain then count
    else let g = find_conns (IntSet.min_elt remain) conns in
      loop (IntSet.diff remain g) (count + 1) in
  loop all_ids 0

let read_lines () =
  let rec loop acc =
    match read_line () with
    | exception End_of_file -> acc
    | l -> loop (parse_line l :: acc)
  in loop []

(* let () = read_lines ()
         |> build_graph
         |> find_conns 
         |> IntSet.cardinal 
         |> Printf.printf "Connection count: %i\n" *)

let () = read_lines ()
         |> build_graph
         |> find_all_groups
         |> Printf.printf "Group count: %i\n"