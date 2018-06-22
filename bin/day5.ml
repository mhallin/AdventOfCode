let read_input () =
  let result = ref [||] in
  let rec loop () =
    match read_line () with
    | exception End_of_file -> result
    | l -> begin
        let () = result := Array.append (! result) [| int_of_string l |] in
        loop ()
      end
  in ! (loop ())

let count_p1 numbers =
  let max_i = Array.length numbers in
  let rec loop i count =
    if i >= max_i then count
    else
      let offset = numbers.(i) in
      let () = numbers.(i) <- offset + 1 in
      loop (i + offset) (count + 1)
  in 
  loop 0 0

let count_p2 numbers =
  let max_i = Array.length numbers in
  let rec loop i count =
    if i >= max_i then count
    else
      let offset = numbers.(i) in
      let modifier = if offset >= 3 then -1 else 1 in
      let () = numbers.(i) <- offset + modifier in
      loop (i + offset) (count + 1)
  in 
  loop 0 0

let solve counter =
  let numbers = read_input () in
  let count = counter numbers in
  Printf.printf "Count: %i\n" count


(* let () = solve count_p1 *)
let () = solve count_p2
