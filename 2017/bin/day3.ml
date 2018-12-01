let odd_ceil x =
  match ceil x |> int_of_float with
  | x when x mod 2 == 0 -> x + 1
  | x -> x

let start_end w = 
  if w == 1 then (1, 1)
  else ((w - 2) * (w - 2) + 1, w * w)

let quad_starts w = 
  let (s, e) = start_end w in
  (s, s + w - 1, s + 2 * (w - 1), s + 3 * (w - 1))

let pos n =
  let w = n |> float_of_int |> sqrt |> odd_ceil in
  let (s, e) = start_end w in
  let off = w / 2 in 
  let (ql, qt, qr, qb) = quad_starts w in
  if n < s then raise (Invalid_argument "Number lower than quad start")
  else if n == 1 then (0, 0)
  else if n < qt then (off, - off + 1 + n - ql)
  else if n < qr then (- (- off + 1 + n - qt), off)
  else if n < qb then (- off, - (- off + 1 + n - qr))
  else if n <= e then (- off + 1 + n - qb, - off)
  else raise (Invalid_argument "Number larger than quad end")

let abs_coord (x, y) = abs x + abs y

let solve n = Printf.printf "N = %i carried %i steps\n" n (n |> pos |> abs_coord)

let () = solve 1
let () = solve 12
let () = solve 23
let () = solve 1024
let () = solve 289326

let neighbors (x, y) =
  [(x-1, y-1); (x, y-1); (x+1, y-1); (x-1, y); (x+1, y); (x-1, y+1); (x, y+1); (x+1, y+1)]

let sum_neighbors cells pos =
  List.fold_left (fun acc pos -> match Hashtbl.find cells pos with | x -> acc + x | exception Not_found -> acc) 0 (neighbors pos)

let summer stop =
  let cells = Hashtbl.create 100 in
  let _ = Hashtbl.add cells (0, 0) 1 in
  let rec loop i =
    let p = pos i in
    let v = sum_neighbors cells p in
    let _ = Hashtbl.add cells p v in
    let _ = Printf.printf "Storing %i for index %i\n" v i in
    if v > stop then () else loop (i + 1)
  in
  loop 2

let () = summer 289326