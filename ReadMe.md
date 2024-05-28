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
1
```