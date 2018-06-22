type state = {
  elts: int array;
  pos: int;
  skip: int;
}

let wrap_get arr i = let l = Array.length arr in arr.(i mod l)
let wrap_set arr i v = let l = Array.length arr in arr.(i mod l) <- v

let range_iter (start, len) cb =
  let e = start + len in
  let rec loop i =
    if i >= e then ()
    else let () = cb i in loop (i + 1)
  in loop start

let range_fold_left (start, len) init cb =
  let e = start + len in
  let rec loop acc i =
    if i >= e then acc
    else loop (cb acc i) (i + 1)
  in loop init start

let rev_sub old_arr start len =
  let arr = Array.copy old_arr in
  let () = range_iter (0, len) (fun i -> wrap_set arr (start + len - i - 1) (wrap_get old_arr (start + i))) in
  arr

let step len state =
  let alen = Array.length state.elts in
  let new_arr = rev_sub state.elts state.pos len in
  { elts = new_arr; pos = (state.pos + len + state.skip) mod alen; skip = state.skip + 1 }

let iterate input =
  let init_state = { elts = Array.init 256 (fun i -> i); pos = 0; skip = 0 } in
  range_fold_left (0, 64) init_state (fun state _ -> List.fold_left (fun state len -> step len state) state input)

let make_input s =
  Array.init (String.length s) (String.get s)
  |> Array.map int_of_char
  |> (fun x -> Array.append x [| 17; 31; 73; 47; 23 |])
  |> Array.to_list

let make_sparse arr =
  let m = Array.init 16 (fun o -> Array.init 16 (fun i -> arr.(o * 16 + i))) in
  let bs = Array.map (Array.fold_left (fun acc b -> acc lxor b) 0) m in
  let s = Array.map (Printf.sprintf "%02x") bs in
  String.concat "" (Array.to_list s)

let hash_to_sparse input =
  (input |> make_input |> iterate).elts |> make_sparse