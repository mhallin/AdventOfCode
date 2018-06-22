module StringSet = Set.Make(String);;

let parse_line line =
  let b = Str.string_match (Str.regexp "^\\([a-z]+\\) (\\([0-9]+\\))\\( -> \\(.*\\)\\)?$") line 0 in
  let () = assert b in
  let name = Str.matched_group 1 line in
  let weight = Str.matched_group 2 line |> int_of_string in
  let children = match Str.matched_group 4 line with
    | children -> Str.split (Str.regexp ", ") children
    | exception Not_found -> [] in
  (name, weight, children)

let find_root known =
  let orphans = ref StringSet.empty in
  let () = Hashtbl.iter (fun k _ -> orphans := StringSet.add k (! orphans)) known in
  let () = Hashtbl.iter (fun _ (_, v) -> List.iter (fun v -> orphans := StringSet.remove v (! orphans)) v) known in
  match StringSet.elements (! orphans) with
  | root :: [] -> root
  | _ -> raise (Invalid_argument "No/multiple roots")

let rec get_weight known root =
  let (own_weight, children) = Hashtbl.find known root in
  let child_weights = List.fold_left (fun acc c -> acc + get_weight known c) 0 children in
  own_weight + child_weights

let get_some = function
  | None -> raise (Invalid_argument "Unexpected None")
  | Some x -> x

let rec verify_weights known root =
  let (_, children) = Hashtbl.find known root in
  let child_weights = Hashtbl.create (List.length children) in
  let own_child_weights = Hashtbl.create (List.length children) in
  let () = List.iter (fun c -> 
      let (w, _) = Hashtbl.find known c in
      let () = Hashtbl.add child_weights c (get_weight known c) in
      Hashtbl.add own_child_weights c w)
      children in
  let counters = Hashtbl.create 2 in
  let () = List.iter (fun c -> 
      let w = Hashtbl.find child_weights c in
      let count = match Hashtbl.find counters w with | n -> n + 1 | exception Not_found -> 1 in
      Hashtbl.replace counters w count)
      children in
  match Hashtbl.length counters with
  | 1 -> List.iter (verify_weights known) children
  | 2 -> 
    let (err_w, corr_w) = (ref None, ref None) in
    let () = Hashtbl.iter (fun k v -> if v = 1 then err_w := Some(k) else corr_w := Some(k)) counters in
    let (err_w, corr_w) = (! err_w |> get_some, ! corr_w |> get_some) in
    let err_ch = ref None in
    let () = Hashtbl.iter (fun c w -> if w = err_w then err_ch := Some(c)) child_weights in
    let err_ch = ! err_ch |> get_some in
    let diff = corr_w - err_w in
    let cw = Hashtbl.find own_child_weights err_ch in
    let () = Printf.printf "Should have weight %s %i\n" err_ch (cw + diff) in
    List.iter (verify_weights known) children
  | n when List.length children > 0  -> Printf.printf "Invalid weight count: %i\n" n
  | n -> ()

let solve () =
  let known = Hashtbl.create 100 in
  let rec loop () =
    match parse_line (read_line ()) with
    | (name, weight, children) -> let () = Hashtbl.add known name (weight, children) in loop ()
    | exception End_of_file -> ()
  in
  let () = loop () in
  let root = find_root known in
  let () = Printf.printf "Root: %s\n" root in
  verify_weights known root

let () = solve ()