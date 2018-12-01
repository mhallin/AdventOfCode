let to_bit_array = function
  | '0' -> [| false; false; false; false |]
  | '1' -> [| false; false; false;  true |]
  | '2' -> [| false; false;  true; false |]
  | '3' -> [| false; false;  true;  true |]
  | '4' -> [| false;  true; false; false |]
  | '5' -> [| false;  true; false;  true |]
  | '6' -> [| false;  true;  true; false |]
  | '7' -> [| false;  true;  true;  true |]
  | '8' -> [|  true; false; false; false |]
  | '9' -> [|  true; false; false;  true |]
  | 'a' -> [|  true; false;  true; false |]
  | 'b' -> [|  true; false;  true;  true |]
  | 'c' -> [|  true;  true; false; false |]
  | 'd' -> [|  true;  true; false;  true |]
  | 'e' -> [|  true;  true;  true; false |]
  | 'f' -> [|  true;  true;  true;  true |]
  | _ -> raise (Invalid_argument "Unknown hex code")

let make_bitstring v =
  let rec loop i acc =
    if i = String.length v then acc
    else loop (i + 1) (Array.append acc (to_bit_array v.[i]))
  in loop 0 [||]

let count_pop a = Array.fold_left (fun sum i -> sum + if i then 1 else 0) 0 a

let hash v = Knot_hash.hash_to_sparse v
  |> make_bitstring

let count_squares base =
  let rec loop i acc =
    if i = 128 then acc
    else base ^ "-" ^ (string_of_int i) |> hash |> count_pop
      |> (+) acc
      |> loop (i + 1)
  in loop 0 0

let get_xy a x y = a.(y).(x)
let set_xy a x y v = a.(y).(x) <- v

type fill_status =
  | Unused
  | NotFilled
  | Filled

let neighbors x y =
  Array.concat [
    if x < 127 then [| x + 1, y |] else [||];
    if x > 0 then [| x - 1, y |] else [||];
    if y < 127 then [| x, y + 1 |] else [||];
    if y > 0 then [| x, y - 1 |] else [||]
  ]

let rec flood_fill a x y =
  if get_xy a x y = NotFilled then
    let () = set_xy a x y Filled in
    let () = Array.iter (fun (x, y) -> flood_fill a x y |> ignore) (neighbors x y) in
    true
  else false

let rec find_group_count a =
  let rec y_loop y count =
    let rec x_loop x count =
      if x = 128 then count
      else if flood_fill a x y then x_loop (x + 1) (count + 1)
      else x_loop (x + 1) count
    in
    if y = 128 then count
    else y_loop (y + 1) (x_loop 0 count)
  in y_loop 0 0

let make_fill_status base =
  let rec loop i acc =
    if i = 128 then acc
    else base ^ "-" ^ (string_of_int i) |> hash
      |> Array.map (fun b -> if b then NotFilled else Unused)
      |> (fun v -> Array.append acc [|v|])
      |> loop (i + 1)
  in loop 0 [||]

(* let () = count_squares (* "ffayrhll" *) "flqrgnkx"
    |> Printf.printf "Used squares: %i\n" *)

let () = make_fill_status "ffayrhll"
    |> find_group_count
    |> Printf.printf "Group count: %i\n"
