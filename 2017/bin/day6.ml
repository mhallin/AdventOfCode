let maxi arr =
  let max = ref arr.(0) in
  let max_i = ref 0 in
  let () = Array.iteri (fun idx v -> if v > ! max then let () = max := v in max_i := idx) arr in
  (! max_i, ! max)

let redist arr =
  let len = Array.length arr in
  let arr = Array.copy arr in
  let (max_i, max) = maxi arr in
  let ()  = arr.(max_i) <- 0 in
  let rec loop i =
    if i > max then arr
    else
      let () = arr.((i + max_i) mod len) <- arr.((i + max_i) mod len) + 1 in
      loop (i + 1)
  in loop 1

let solve_p1 arr =
  let seen = Hashtbl.create 10 in
  let rec loop arr =
    match Hashtbl.find seen arr with
    | _ -> Hashtbl.length seen
    | exception Not_found ->
      let () = Hashtbl.add seen arr true in
      loop (redist arr)
  in loop arr

let solve_p2 arr =
  let seen = Hashtbl.create 10 in
  let added = ref [| |] in
  let rec loop arr =
    match Hashtbl.find seen arr with
    | _ -> arr
    | exception Not_found ->
      let () = Hashtbl.add seen arr true in
      let () = added := Array.append (! added) [| arr |] in
      loop (redist arr)
  in
  let last = loop arr in
  let index = ref (-1) in
  let () = Array.iteri (fun idx v -> if v = last && (! index) == (-1) then index := idx else ()) (! added) in
  Array.length (! added) - (! index)

let main solve =
  let arr = Str.split (Str.regexp "[\t ]") (read_line ()) |> List.map int_of_string |> Array.of_list in
  let count = solve arr in
  Printf.printf "Count: %i\n" count

let () = main solve_p2