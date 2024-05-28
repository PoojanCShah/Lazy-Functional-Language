# COL226 Assignment 7 : A Lazy Functional Language 

We implement a haskell - like functional language which performs lazy evaluation using a kirvine machine inspired interpreter. 

## How to run this project ? 
`make init` : to generate the lexer-parser

`make run file = code.txt` : type your code in `code.txt` and run this command to get output 

`make clean` : to clean up the directory

## Be Lazy, Not Eager
In a lazy functional programming language, function and expressions can be _non-strict_ in the sense that the function may be defined even when the input to it is not defined (i.e, not terminating). To explain using some examples, we will use $\Omega$ to denote some non-terminating lambda term . For example, something like $\Omega = (\lambda x.(xx))(\lambda x.(xx))$.
#### Examples :  
$\lambda x. 2$  $\Omega$ = 2

$first (1,\Omega)$ = 1

## Test Cases

Note that the test cases are created so as to rigourosly check if the lazy evaluation is done completely. None of these expressions would terminate on a simple SECD machine which implemets call by value semantics.

### tc0
```
first ((2,(true+4) / 0))
```
```
Fst(
  Pair(
    Num(2),
    Divd(
      Plus(
        Bool(true),
        Num(4)
      ),
      Num(0)
    )
  )
)
```
```
2
```

### tc1
```
let omega = (fun x -> (x x)) (fun x -> (x x)) in
(
    let f = fun x -> (fun y -> (x,y)) in
    (
        first ( f 12 omega)
    )
)
```

```
App(
  Abs("omega",
    App(
      Abs("f",
        Fst(
          App(
            App(
              V("f"),
              Num(12)
            ),
            V("omega")
          )
        )
      ),
      Abs("x",
        Abs("y",
          Pair(
            V("x"),
            V("y")
          )
        )
      )
    )
  ),
  App(
    Abs("x",
      App(
        V("x"),
        V("x")
      )
    ),
    Abs("x",
      App(
        V("x"),
        V("x")
      )
    )
  )
)
```
```
12
```
### tc2
```
let omega = 1/0 in
(
    if (true) then (1) else (omega +12)
)

```

```
App(
  Abs("omega",
    IfTE(
      Bool(true),
      Num(1),
      Plus(
        V("omega"),
        Num(12)
      )
    )
  ),
  Divd(
    Num(1),
    Num(0)
  )
)
```
```
1
```
### tc3
```
let omega = 1/0 in
(
    ((fun x -> 2) (omega)) + first((12,omega))
)
```

```
App(
  Abs("omega",
    Plus(
      App(
        Abs("x",
          Num(2)
        ),
        V("omega")
      ),
      Fst(
        Pair(
          Num(12),
          V("omega")
        )
      )
    )
  ),
  Divd(
    Num(1),
    Num(0)
  )
)
```
```
14
```
### tc4
```
let x = 2 in
(
    let y = 2/(2-x) in
    (
        x+2
    )
)
```

```
App(
  Abs("x",
    App(
      Abs("y",
        Plus(
          V("x"),
          Num(2)
        )
      ),
      Divd(
        Num(2),
        Minus(
          Num(2),
          V("x")
        )
      )
    )
  ),
  Num(2)
)
```
```
4
```
### tc5
```
let omega = (fun x -> (x x)) (fun x -> (x x)) in
(
    let cond = first ( (true, omega)) in
    (
        if (cond) then (1) else (omega)
    )
)
```

```
App(
  Abs("omega",
    App(
      Abs("cond",
        IfTE(
          V("cond"),
          Num(1),
          V("omega")
        )
      ),
      Fst(
        Pair(
          Bool(true),
          V("omega")
        )
      )
    )
  ),
  App(
    Abs("x",
      App(
        V("x"),
        V("x")
      )
    ),
    Abs("x",
      App(
        V("x"),
        V("x")
      )
    )
  )
)
```
```
1
```