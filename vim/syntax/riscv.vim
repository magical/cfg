" Vim syntax file
" Language:	GNU Assembler (RISC-V variant)
" Maintainer:	Andrew Ekstedt
"		Previous maintainers:
"		Erik Wognsen <erik.wognsen@gmail.com>
"		Kevin Dahlhausen <kdahlhaus@yahoo.com>
" Last Change:	2023 Apr 23

" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

"        A-Za-z  $  .  0-9   _
syn iskeyword @,36,46,48-57,95,192-255

syn case ignore

" 1. An item that starts in an earlier position has priority over items that start in later positions.
" 2. A Keyword has priority over Match and Region items.
" 3. When multiple Match or Region items start in the same position, the item defined last has priority.

" storage types
syn match riscvType "\.ascii"
syn match riscvType "\.asciz"
syn match riscvType "\.string"
syn match riscvType "\.space"

syn match riscvType "\.byte"
syn match riscvType "\.hword"
syn match riscvType "\.short"
"syn match riscvType "\.int"
syn match riscvType "\.word"
syn match riscvType "\.long"
syn match riscvType "\.dword"
syn match riscvType "\.quad"

syn match riscvType "\.float"
syn match riscvType "\.single"
syn match riscvType "\.double"


" Partial list of register symbols
syn keyword riscvReg	zero
syn keyword riscvReg	ra sp gp tp fp
syn keyword riscvReg	a0 a1 a2 a3 a4 a5 a6 a7
syn keyword riscvReg	t0 t1 t2 t3 t4 t5 t6
syn keyword riscvReg	s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11

syn keyword riscvReg	x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15
syn keyword riscvReg	x16 x17 x18 x19 x20 x21 x22 x23 x24 x25 x26 x27 x28 x29 x30 x31

" instructions
syn keyword riscvInsn add[i] sub xor[i] or[i] and[i]
syn keyword riscvInsn sll[i] srl[i] sra[i]
syn keyword riscvInsn j jal jalr jr ret call tail
syn keyword riscvInsn beq bne blt[u] bgt[u] ble[u] bge[u]
syn keyword riscvInsn beqz bnez bltz blez bgtz bgez
syn keyword riscvInsn slt sltu slti sltui
syn keyword riscvInsn seqz snez sltz sgtz
syn keyword riscvInsn ecall ebreak

syn keyword riscvInsn ld lw lwu lh lhu lb lbu
syn keyword riscvInsn sd sw swu sh shu sb sbu
syn keyword riscvInsn li lui la auipc

syn keyword riscvInsn mul mulh mulhu mulhsu
syn keyword riscvInsn div divu rem remu
syn keyword riscvInsn divw divuw remw remuw

syn keyword riscvInsn nop
syn keyword riscvInsn mv
syn keyword riscvInsn not neg negw

syn keyword riscvInsn fence
syn keyword riscvInsn lr.w lr.d sc.w sc.d
syn keyword riscvInsn amoswap.w amoadd.w amoand.w amoor.w amoxor.w amomax.w amomin.w amomaxu.w amominu.w
syn keyword riscvInsn amoswap.d amoadd.d amoand.d amoor.d amoxor.d amomax.d amomin.d amomaxu.d amominu.d

syn match riscvIdentifier	/\<[a-z_][a-z0-9_]*\>/
syn match riscvLabel		/\<[a-z_][a-z0-9_]*:/he=e-1

" Various #'s as defined by GAS ref manual sec 3.6.2.1
" Technically, the first decNumber def is actually octal,
" since the value of 0-7 octal is the same as 0-7 decimal,
" I (Kevin) prefer to map it as decimal:
syn match decNumber		"\<0\+[1-7]\?\>\|\<[1-9]\d*\>"
syn match octNumber		"\<0[0-7][0-7]\+\>"
syn match hexNumber		"\<0[xX][0-9a-fA-F]\+\>"
syn match binNumber		"\<0[bB][0-1]*\>"

syn match riscvEscape "\\[bfnrt\\'\"]" contained
syn match riscvEscape "\\[0-7]\{1,3}" contained

syn region riscvString		start=/"/ end=/"/ skip=/\\"/ contains=riscvEscape

" TODO: characters


syn keyword riscvTodo		contained TODO XXX FIXME

" Thanks to Ori Avtalion for feedback on the comment markers!

" GAS supports one type of multi line comments:
syn region riscvComment		start="/\*" end="\*/" contains=riscvTodo

" GAS (undocumentedly?) supports C++ style comments. Unlike in C/C++ however,
" a backslash ending a C++ style comment does not extend the comment to the
" next line (hence the syntax region does not define 'skip="\\$"')
syn region riscvComment		start="//" end="$" keepend contains=riscvTodo

" Line comment characters depend on the target architecture and command line
" options and some comments may double as logical line number directives or
" preprocessor commands. This situation is described at
" http://sourceware.org/binutils/docs-2.22/as/Comments.html
" Some line comment characters have other meanings for other targets. For
" example, .type directives may use the `@' character which is also an ARM
" comment marker.
" As a compromise to accommodate what I arbitrarily assume to be the most
" frequently used features of the most popular architectures (and also the
" non-GNU assembly languages that use this syntax file because their asm files
" are also named *.asm), the following are used as line comment characters:
syn match riscvComment		"[#].*" contains=riscvTodo

" Side effects of this include:
" - When `;' is used to separate statements on the same line (many targets
"   support this), all statements except the first get highlighted as
"   comments. As a remedy, remove `;' from the above.
" - ARM comments are not highlighted correctly. For ARM, uncomment the
"   following two lines and comment the one above.
"syn match riscvComment		"@.*" contains=riscvTodo
"syn match riscvComment		"^#.*" contains=riscvTodo

" Advanced users of specific architectures will probably want to change the
" comment highlighting or use a specific, more comprehensive syntax file.

syn match riscvInclude		"\.include"
syn match riscvCond		"\.if"
syn match riscvCond		"\.else"
syn match riscvCond		"\.endif"
syn match riscvMacro		"\.macro"
syn match riscvMacro		"\.endm"

" Assembler directives start with a '.' and may contain upper case (e.g.,
" .ABORT), numbers (e.g., .p2align), dash (e.g., .app-file) and underscore in
" CFI directives (e.g., .cfi_startproc). Only match at the start of a line.
"
" This will also match labels starting " with '.', including the GCC
" auto-generated '.L' labels.
syn match riscvDirective	"^\s*\zs\.[A-Za-z][0-9A-Za-z-_]*"

" Match '.L' labels, overriding riscDirective
syn match riscvLocalLabel	/\.L\k*/

" Anonymous labels are defined as label with a numeric name
" and referenced with an 'f' or 'b' suffix.
syn match riscvAnonLabel	/^\s*\zs[0-9]\+[$]\?:/he=e-1
syn match riscvAnonLabel	"[0-9]\+[$]\?[fb]"

syn match riscvDot		/\<\.\>/

syn case match

" Define the default highlighting.
" Only when an item doesn't have highlighting yet

" The default methods for highlighting.  Can be overridden later
hi def link riscvSection	Special
hi def link riscvLabel		Function
hi def link riscvComment	Comment
hi def link riscvTodo		Todo
hi def link riscvDirective	Statement
hi def link riscvReg		Identifier
hi def link riscvInsn		Keyword

hi def link riscvInclude	Include
hi def link riscvCond		PreCondit
hi def link riscvMacro		Macro

hi def link hexNumber		Number
hi def link decNumber		Number
hi def link octNumber		Number
hi def link binNumber		Number

hi def link riscvString		String
hi def link riscvEscape		SpecialChar

"hi def link riscvIdentifier	Identifier
hi def link riscvIdentifier	Normal
hi def link riscvType		Type

hi def link riscvLocalLabel	Label
hi def link riscvAnonLabel	Label
hi def link riscvDot		Identifier

let b:current_syntax = "riscv"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=8
