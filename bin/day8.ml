type dir = | Inc | Dec
type ineq = | Lt | Le | Gt | Ge | Eq | Ne

type instr = {
  reg: string;
  change_dir: dir;
  change_val: int;
  cond_reg: string;
  cond_ineq: ineq;
  cond_val: int;
}

let line_re = Str.regexp "^\\([^ ]+\\) \\([^ ]+\\) \\(-?[0-9]+\\) if \\([^ ]+\\) \\([^ ]+\\) \\(-?[0-9]+\\)$"

let parse_dir = function
  | "inc" -> Inc
  | "dec" -> Dec
  | _ -> raise (Invalid_argument "Invalid direction")

let parse_ineq = function
  | "<" -> Lt
  | "<=" -> Le
  | ">" -> Gt
  | ">=" -> Ge
  | "==" -> Eq 
  | "!=" -> Ne
  | _ -> raise (Invalid_argument "Invalid inequality")

let parse_line line =
  let m = Str.string_match line_re line 0 in
  let () = assert m in
  let reg = Str.matched_group 1 line in
  let change_dir = Str.matched_group 2 line |> parse_dir in
  let change_val = Str.matched_group 3 line |> int_of_string in
  let cond_reg = Str.matched_group 4 line in
  let cond_ineq = Str.matched_group 5 line |> parse_ineq in
  let cond_val = Str.matched_group 6 line |> int_of_string in
  { reg; change_dir; change_val; cond_reg; cond_ineq; cond_val }

let eval_cond v1 v2 = function
  | Lt -> v1 < v2
  | Le -> v1 <= v2
  | Gt -> v1 > v2
  | Ge -> v1 >= v2
  | Eq -> v1 = v2
  | Ne -> v1 != v2

let add_dir v1 v2 = function
  | Inc -> v1 + v2
  | Dec -> v1 - v2

let exec_instr regs instr =
  let cond_lhs = match Hashtbl.find regs instr.cond_reg with | v -> v | exception Not_found -> 0 in
  let cond = eval_cond cond_lhs instr.cond_val instr.cond_ineq in
  if cond then
    let curr_val = match Hashtbl.find regs instr.reg with | v -> v | exception Not_found -> 0 in
    let new_val = add_dir curr_val instr.change_val instr.change_dir in
    Hashtbl.replace regs instr.reg new_val

let get_max regs =
  let max_val = ref None in
  let () = Hashtbl.iter (fun _ v -> match (v, ! max_val) with 
      | v, None -> max_val := Some v
      | v, Some x when v > x -> max_val := Some v
      | _ -> ())
      regs in
  match ! max_val with
  | None -> raise (Invalid_argument "No max value")
  | Some x -> x

let solve () =
  let regs = Hashtbl.create 10 in
  let max_val = ref 0 in
  let rec loop () =
    match read_line () with
    | exception End_of_file -> ()
    | line ->
      let instr = parse_line line in
      let () = exec_instr regs instr in
      let () = max_val := max (! max_val) (get_max regs) in
      loop ()
  in
  let () = loop () in
  Printf.printf "Max value ever %i\n" (! max_val)

let () = solve ()