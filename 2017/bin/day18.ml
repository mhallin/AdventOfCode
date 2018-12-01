type value =
  | Reg of char
  | Const of int

type instr =
  | Snd of value
  | Set of char * value
  | Add of char * value
  | Mul of char * value
  | Mod of char * value
  | Rcv of value
  | Jgz of value * value

let parse_value v =
  match int_of_string v with
  | v -> Const v
  | exception (Failure _) -> Reg v.[0]

let parse_instr i = match Str.split (Str.regexp " ") i with
  | "snd" :: a1 :: [] -> Snd (parse_value a1)
  | "set" :: a1 :: a2 :: [] -> Set (a1.[0], parse_value a2)
  | "add" :: a1 :: a2 :: [] -> Add (a1.[0], parse_value a2)
  | "mul" :: a1 :: a2 :: [] -> Mul (a1.[0], parse_value a2)
  | "mod" :: a1 :: a2 :: [] -> Mod (a1.[0], parse_value a2)
  | "rcv" :: a1 :: [] -> Rcv (parse_value a1)
  | "jgz" :: a1 :: a2 :: [] -> Jgz (parse_value a1, parse_value a2)
  | _ -> raise (Invalid_argument "Unknown instruction")

let parse_stdin () =
  let rec loop acc =
    match read_line () |> parse_instr with
    | i -> loop (i :: acc)
    | exception End_of_file -> acc |> List.rev |> Array.of_list
  in loop []

type state = {
  regs: (char, int) Hashtbl.t;
  pos: int;
  program: instr array;
  last_sound: int option;
}

exception RecoveredAudio of int

let get_value state = function
  | Const x -> x
  | Reg r -> match Hashtbl.find state.regs r with
    | v -> v
    | exception Not_found -> 0

let set_reg state r v =
  (* let () = Printf.printf "%c <- %i\n" r v in *)
  Hashtbl.replace state.regs r v

let step state = 
  match state.program.(state.pos) with
  | Snd x -> {state with pos = state.pos + 1; last_sound = Some (get_value state x)}
  | Set (d, v) ->
    let () = set_reg state d (get_value state v) in
    {state with pos = state.pos + 1}
  | Add (d, v) ->
    let v = (get_value state v) + (get_value state (Reg d)) in
    let () = set_reg state d v in
    {state with pos = state.pos + 1}
  | Mul (d, v) ->
    let v = (get_value state v) * (get_value state (Reg d)) in
    let () = set_reg state d v in
    {state with pos = state.pos + 1}
  | Mod (d, v) ->
    let v = (get_value state (Reg d)) mod (get_value state v) in
    let () = set_reg state d v in
    {state with pos = state.pos + 1}
  | Jgz (x, y) ->
    let x = get_value state x in
    if x > 0 then { state with pos = state.pos + (get_value state y)}
    else { state with pos = state.pos + 1}
  | Rcv v ->
    let v = get_value state v in
    match (v, state.last_sound) with
    | (_, None) | (0, _) -> {state with pos = state.pos + 1}
    | (_, Some(f)) -> raise (RecoveredAudio f)

let run_until_finish program =
  let rec loop state =
    if state.pos < 0 || state.pos >= Array.length program then ()
    else loop (step state)
  in loop { regs = Hashtbl.create 10; pos = 0; program = program; last_sound = None }

let () = parse_stdin () |> run_until_finish
