type dir = 
  | N
  | Ne
  | Se
  | S
  | Sw
  | Nw

let step (x, y, z) dir = 
  let dx, dy, dz = match dir with
    | N -> 1, 0, -1
    | Ne -> 1, -1, 0
    | Se -> 0, -1, 1
    | S -> -1, 0, 1
    | Sw -> -1, 1, 0
    | Nw -> 0, 1, -1
  in x + dx, y + dy, z + dz

let dist (x1, y1, z1) (x2, y2, z2) =
  ((x1 - x2 |> abs) + (y1 - y2 |> abs) + (z1 - z2 |> abs)) / 2

let dir_of_string = function
  | "n" -> N | "ne" -> Ne | "se" -> Se
  | "s" -> S | "sw" -> Sw | "nw" -> Nw
  | v -> raise (Invalid_argument "Unknown direction")

let parse line =
  let dirs = Str.split (Str.regexp ",") line |> List.map dir_of_string in
  let (end_coord, max_dist) = List.fold_left
      (fun (coord, md) dir -> 
         let coord = step coord dir in
         (coord, max md (dist (0, 0, 0) coord)))
      ((0, 0, 0), 0) dirs in
  Printf.printf "Distance: %i, max dist: %i\n" (dist (0, 0, 0) end_coord) max_dist

let () = parse (read_line ())