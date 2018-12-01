let process_line line =
  let line_len = String.length(line) in
  let rec loop i acc =
    if i == line_len then
      acc
    else
      let c1 = int_of_char line.[i] - 48 in
      (* let c2 = int_of_char line.[(i + 1) mod line_len] - 48 in *)
      let c2 = int_of_char line.[(i + line_len / 2) mod line_len] - 48 in
      let acc = if c1 = c2 then acc + c1 else acc in
      loop (i + 1) acc
  in
  let sum = loop 0 0 in
  Printf.printf "Sum: %i\n" sum

let rec read_loop process_line =
  try 
    while true do
      process_line (read_line ())
    done;
    ()
  with
    End_of_file -> ()

let () = read_loop process_line
