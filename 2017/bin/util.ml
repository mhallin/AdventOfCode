let rec read_loop process_line =
  try 
    while true do
      process_line (read_line ())
    done;
    ()
  with
    End_of_file -> ()
