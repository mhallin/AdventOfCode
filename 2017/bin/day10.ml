
(* let run () =
  let line = read_line () |> Str.split (Str.regexp ",") |> List.map int_of_string in
  let init_state = { elts = Array.init 256 (fun i -> i); pos = 0; skip = 0 } in
  let end_state = List.fold_left (fun state len -> step len state) init_state line in
  Printf.printf "Mult first two: %i\n" (end_state.elts.(0) * end_state.elts.(1))

let () = run () *)

let run () =
  let hash = read_line () |> Knot_hash.hash_to_sparse in
  Printf.printf "Hash: %s\n" hash

let () = run ()
