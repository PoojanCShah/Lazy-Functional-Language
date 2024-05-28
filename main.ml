open List
open Parser
open Lexer

exception STUCK





type clos = 
  | Clos of exp* ((string * clos) list) 



type ans = 
  | N of int 
  | B of bool
  | P of clos * clos
  | FUN


let rec print_ans a =
  match a with
  | N n -> print_int n
  | B b -> print_string (string_of_bool b)
  | P(c1,c2) -> print_string "PAIR"
  | FUN -> print_string "FUN"




type table = 
  | Table of (string * clos) list



let rec lookup x l = 
  match l with Table g ->
  match g with
  | [] -> raise STUCK
  | (h,a) :: t -> if (x = h) then a else lookup x (Table t)
 


let rec krivine closure closure_stack = 
  match closure,closure_stack with Clos(e,g), s ->
  match e,s with 
  | Num n , s -> N n
  | Bool b ,s -> B b


  |App(e1,e2),s -> krivine (Clos(e1,g)) (Clos(e2,g) :: s)
  |Abs(x,e'), s  -> let eval_fun =  match s with
      | [] -> FUN
      | h :: t -> krivine (Clos(e', (x,h) :: g)) t 
    in eval_fun


  |V x,s -> krivine (lookup x (Table(g))) s 


  | Plus(e1,e2) , s -> let N n1 = krivine (Clos(e1,g)) s and  N n2 = krivine (Clos(e2,g)) s
    in N (n1+n2)
  | Times(e1,e2) , s -> let N n1 = krivine (Clos(e1,g)) s and  N n2 = krivine (Clos(e2,g)) s
    in N (n1*n2)
  | Minus(e1,e2) , s -> let N n1 = krivine (Clos(e1,g)) s and  N n2 = krivine (Clos(e2,g)) s
    in N (n1-n2)
  | Divd(e1,e2) , s -> let N n1 = krivine (Clos(e1,g)) s and  N n2 = krivine (Clos(e2,g)) s
    in N (n1/n2) 


  | Gt(e1,e2) , s -> let N n1 = krivine (Clos(e1,g)) s and  N n2 = krivine (Clos(e2,g)) s
    in B (n1>n2)
  | Lt(e1,e2) , s -> let N n1 = krivine (Clos(e1,g)) s and  N n2 = krivine (Clos(e2,g)) s
    in B (n1<n2)
  | Eq(e1,e2) , s -> let N n1 = krivine (Clos(e1,g)) s and  N n2 = krivine (Clos(e2,g)) s
    in B (n1=n2)

  |IfTE(e1,e2,e3),s -> let B b = krivine (Clos(e1,g)) s in
    if b then krivine (Clos(e2,g)) s else krivine (Clos(e3,g)) s

  | And(e1,e2) , s -> let B b1 = krivine (Clos(e1,g)) s in
    if (not b1) then B false else krivine (Clos(e2,g)) s
  | Or(e1,e2) , s -> let B b1 = krivine (Clos(e1,g)) s in
    if (b1) then B true else krivine (Clos(e2,g)) s
  | Not(e') , s -> let B b = krivine (Clos(e',g)) s in
    B (not b)






  | Pair(e1,e2) ,s -> P(Clos(e1,g),Clos(e2,g))
  | Fst e' , s -> let fst = match (krivine (Clos(e',g)) s) with |P(cl1,cl2) -> krivine cl1 s
    in fst
  |Snd e' , s -> let snd = match (krivine (Clos(e',g)) s) with |P(cl1,cl2) -> krivine cl2 s
    in snd




let intrprt e = krivine (Clos(e,[])) []



let rec repl () =
  let ic = open_in Sys.argv.(1) in
  let rec read_all acc =
    try
      let line = input_line ic in
      read_all (acc ^ line ^ "\n")
    with End_of_file ->
      acc
  in
  let all_lines = read_all "" in
  let lexbuf = Lexing.from_string all_lines in
  let parsed = Parser.root Lexer.token lexbuf in
  let result = intrprt parsed in
  (* print_tree  0 parsed;
     print_opcode_list (compile parsed); *)
  print_ans result;
  print_newline ();
  close_in ic



let _ = repl ()

