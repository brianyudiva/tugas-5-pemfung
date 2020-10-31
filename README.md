# mu

Simple untyped (and soon simply typed) lambda calculus interpreter written in Haskell.

Features:
* Bound and free variables
* Abstractions (functions)
* Function application
* Aliases to name expressions so they don't have to be typed out over and over again
* "Evaluation" through alpha conversion and beta reduction

## Grammar
```
input       ::= expr (";" expr)*
expr        ::= alias | application
alias       ::= ALIASIDENT ":=" application
application ::= (term)* | "(" application ")"
term        ::= variable | abstraction
variable    ::= VARIDENT | ALIASIDENT
abstraction ::= ("\" | "λ") VARIDENT "." application

VARIDENT    ::= _any single lowercase letter_
ALIASIDENT  ::= _any series of alpha numeric characters_
```

Whitespace after any token is ignored.
Comments can be started with `--`.

## Examples

```
> ID := \x.x -- The identity function.
\x.x
> ID a
a
> AND := \p.\q.p q p -- Boolean and.
\p.\q.p q p
> TRUE := \x.\y.x -- Boolean true.
\x.\y.x
> FALSE := \x.\y.y -- Boolean false.
\x.\y.y
> AND TRUE FALSE ; AND TRUE TRUE
\x.\y.y ; \x.\y.x
```

## Building & Running

The project can be easily built using Cabal (install via `ghcup` on Linux):
```
$ cabal build
```
and can also be run using
```
$ cabal run
```

This will launch a REPL in which Lambda Calculus expressions can be typed and evaluated.

The program REPL can be installed by using
```
$ cabal install
```
This way it can be executed from anywhere by just invoking the `mu` command. 

## License

Licensed under the [MIT License](./LICENSE).
