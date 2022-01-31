pTODO is a command line todo manager, written in Ruby, which hooks into the
remind calender tool. Unlike other textual todo managers it works from a
straight text file - with an easy format for tags and dates.

ptodo has nice colour support for VIM and does colour output in the console.

    ptodo | less -R

Run './bin/ptodo --help' to see all options:


```
Usage: ptodo [options]
    -f filename                      Read from file (default from config)
        --tags                       Show all tags
    -l, --line                       Show line info
        --no-color                   No colours
        --due                        List all due items
        --dated                      List all dated items
        --remind                     Generate output for remind
    -q, --quiet                      Run quietly
    -v, --[no-]verbose               Run verbosely
    -t, --[no-]trace                 Trace
    -d, --[no-]debug                 Debug
    -a date [tags] -m "msg"          Add item to Todo list
    -m
    -h, --help                       Show help and examples

Examples:

    ptodo soon                ; print all non-tagged items
    ptodo later               ; print all items with tags named 'later'
    ptodo later math          ; print all items with tags 'later' and 'math'
    ptodo '(later|math)'      ; print all items with tags 'later' or 'math'
    ptodo (math200\d)         ; print all math items with tags like math2007
    ptodo --dated             ; print all dated items
    ptodo --due               ; print all due items (2 weeks ahead) [default]
    ptodo --remind| remind -c -       ; pipe into remind program

    ptodo -a date [tags] -m "description"
    ptodo -a tomorrow [joe] -m "dinner with joe"

To run nice calender style output:

    ptodo --remind|remind -p3 -|rem2ps > months.ps

```

Pjotr Prins
