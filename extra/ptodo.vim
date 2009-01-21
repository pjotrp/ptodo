" Vim syntax file
"
" Keywords
syn keyword todoTodo TODO FIXME contained
syn match todoIdentifier /\<\d\+\>/
syn match todoTags /\[.*\]/
syn match todoList /\s\+[1-9.-]\+\s/
syn keyword todoStatement	later soon
syn match todoSpaceError	"\s\+$" display
syn match todoSpaceError	"\t\+" display

" Comments
syn match   todoComment	"#.*$" display contains=todoStatement

highlight link todoStatement Statement
highlight link todoComment Comment
highlight link todoIdentifier Identifier
highlight link todoTags Question
highlight link todoList Question
highlight link todoSpaceError Error
let b:current_syntax = "todo"
