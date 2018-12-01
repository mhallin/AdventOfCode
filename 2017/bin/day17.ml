type state = {
  pos: int;
  len: int;
  buf: int array;
  last_write: int;
}

let init_state stop =
  { pos = 0; len = 1; buf = Array.make (stop + 1) 0; last_write = 0 }

let step n state =
  let next_i = (state.pos + n) mod state.len + 1 in
  let new_buf = Array.copy state.buf in
  let () = Array.blit state.buf next_i new_buf (next_i + 1) (state.len - next_i) in
  let () = new_buf.(next_i) <- state.last_write + 1 in
  {
    pos = next_i;
    len = state.len + 1;
    buf = new_buf;
    last_write = state.last_write + 1;
  }

let run n stop =
  let rec loop state =
    if state.last_write = stop then state
    else loop (step n state)
  in loop (init_state stop)

let find_succ stop arr =
  let rec loop i =
    if arr.(i) = stop then arr.((i + 1) mod Array.length arr)
    else loop (i + 1)
  in loop 0

let runs = 50_000_000
let adv = 337

(* let () = (run adv runs).buf |> find_succ 2017
         |> Printf.printf "Solution: %i\n" *)

let track_second n stop =
  let rec loop i pos second =
    if i = stop then second
    else
      let next_pos = (pos + n) mod (i + 1) + 1 in
      let value = (i + 1) in
      loop (i + 1) next_pos (if next_pos = 1 then value else second)
  in loop 0 0 0

let () = track_second adv runs
         |> Printf.printf "Fast solution: %i\n"