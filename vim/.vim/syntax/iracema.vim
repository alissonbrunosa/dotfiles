" Vim syntax file
" Language:     Iracema
" Maintainer:   Alisson Bruno <alisonbruno.sa@gmail.com>

if exists("b:current_syntax")
  finish
endif

let s:keepcpo = &cpo
set cpo&vim



syntax match   iracemaSpecialError      contained "\\."
syntax match   iracemaSpecialCharError  contained "[^']"
syntax match   iracemaSpecialChar       contained "\\\([4-9]\d\|[0-3]\d\d\|[\"\\'ntbrf]\|u\x\{4\}\)"
syntax region  iracemaString            start=+"+ end=+"+ end=+$+ contains=iracemaSpecialChar,iracemaSpecialError,@Spell

syntax match  iracemaNumber             "\<\(0[bB][0-1]\+\|0[0-7]*\|0[xX]\x\+\|\d\(\d\|_\d\)*\)[lL]\=\>"
syntax match  iracemaNumber             "\(\<\d\(\d\|_\d\)*\.\(\d\(\d\|_\d\)*\)\=\|\.\d\(\d\|_\d\)*\)\([eE][-+]\=\d\(\d\|_\d\)*\)\=[fFdD]\="
syntax match  iracemaNumber             "\<\d\(\d\|_\d\)*[eE][-+]\=\d\(\d\|_\d\)*[fFdD]\=\>"
syntax match  iracemaNumber             "\<\d\(\d\|_\d\)*\([eE][-+]\=\d\(\d\|_\d\)*\)\=[fFdD]\>"
syntax match  iracemaComment            "#.*" contains=iracemaTodo,@Spell


syntax keyword irDecl                   let var const
syntax keyword irImport                 use
syntax keyword iracemaTodo              FIXME NOTE NOTES TODO XXX contained
syntax keyword iracemaConditional       if else switch
syntax keyword iracemaRepeat            while for in
syntax keyword iracemaBranch            next stop
syntax keyword iracemaBoolean           true false
syntax keyword iracemaStatement         return
syntax keyword iracemaLabel             case default
syntax keyword iracemaError             throw catch
syntax keyword iracemaNone              none
syntax keyword iracemaTypeDef           this super
syntax keyword iracemaOperator          and or new


syntax match iracemaObjectName         /\w\+/ contained skipwhite skipnl
syntax match iracemaFunctionName       /\w\+/ contained skipwhite skipnl

syntax keyword iracemaObject           object is nextgroup=iracemaObjectName skipwhite
syntax keyword iracemaFunction         fun nextgroup=iracemaFunctionName skipwhite


highlight def link irDecl              Keyword
highlight def link irImport            Include
highlight def link iracemaTodo         Todo
highlight def link iracemaComment      Comment
highlight def link iracemaObjectName   Special
highlight def link iracemaString       String
highlight def link iracemaNumber       Number
highlight def link iracemaConditional  Conditional
highlight def link iracemaBranch       Conditional
highlight def link iracemaLabel        Label
highlight def link iracemaRepeat       Repeat
highlight def link iracemaStatement    Statement
highlight def link iracemaError        Exception
highlight def link iracemaObject       Keyword
highlight def link iracemaFunction     Keyword
highlight def link iracemaNone         Keyword
highlight def link iracemaTypeDef      TypeDef
highlight def link iracemaBoolean      Boolean
highlight def link iracemaFunctionName Function
highlight def link iracemaOperator     Operator


let b:current_syntax = "iracema"
let &cpo = s:keepcpo
unlet s:keepcpo

" vim: sw=2 sts=2 et
