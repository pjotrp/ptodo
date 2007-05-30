" Vim syntax file
" Language:	Python
" Maintainer:	Dmitry Vasiliev <dima@hlabs.spb.ru>
" URL:		http://www.hlabs.spb.ru/vim/python.vim
" Last Change:	$Date: 2006-09-26 15:46:55 +0400 (Втр, 26 Сен 2006) $
" Filenames:	*.py
" Version:	2.5.5
" $Rev: 477 $
"
" Keywords
syn keyword todoTodo TODO FIXME contained
syn match todoIdentifier /\<\d\+\>/
syn match todoTags /\[.*\]/
syn keyword todoStatement	later soon
syn match todoSpaceError	"\s\+$" display
syn match todoSpaceError	"\t\+" display

" Comments
syn match   todoComment	"#.*$" display contains=todoStatement

highlight link todoStatement Statement
highlight link todoComment Comment
highlight link todoIdentifier Identifier
highlight link todoTags Question
highlight link todoSpaceError Error
let b:current_syntax = "todo"
