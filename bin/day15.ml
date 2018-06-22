let a_mult = 16807
let b_mult = 48271

let a_div = 4
let b_div = 8

let step_gen mult prev = (prev * mult) mod 2147483647

let step_filt mult div prev =
  let rec loop prev =
    let next = step_gen mult prev in
    if (next mod div) = 0 then next
    else loop next
  in loop prev

let step_a = step_filt a_mult a_div
let step_b = step_filt b_mult b_div

let score a_start b_start iters =
  let rec loop i last_a last_b score =
    if i = iters then score
    else
      let (a, b) = (step_a last_a, step_b last_b) in
      let score = score + if (a land 0xffff) = (b land 0xffff) then 1 else 0 in
      loop (i + 1) a b score
  in loop 0 a_start b_start 0

let iter_count = 5_000_000
let () = score 703 516 iter_count
    |> Printf.printf "Score after %i iterations = %i\n" iter_count