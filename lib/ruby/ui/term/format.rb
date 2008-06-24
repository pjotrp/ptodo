# $Id: format.rb,v 1.4 2004/04/22 16:35:07 wrk Exp $
# $Source: /home/cvs/opensource/lib/ruby/ui/term/format.rb,v $
#
# Terminal formatting facilities
#
# Info:: Pjotr's shared Ruby modules
# Author:: Pjotr Prins
# mail:: pjotr.public05@thebird.nl
# Copyright:: July 2007
# License:: Ruby License

LITERAL=<<EOL

BASH SCRIPT
T='gYw'   # The test text                               
                                                        
echo -e "\n                 40m     41m     42m     43m\
     44m     45m     46m     47m";                                  
                                                                    
for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
           '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
           '  36m' '1;36m' '  37m' '1;37m';                         
  do FG=${FGs// /}                                                  
  echo -en " $FGs \033[$FG  $T  "                                   
  for BG in 40m 41m 42m 43m 44m 45m 46m 47m;                        
    do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";              
  done                                                              
  echo;                                                             
done                                                                         
echo

EOL

module TermFormat

  BG_NORMAL = '0m'
  BG_BLACK  = '40m' 
  BG_RED    = '41m'
  BG_GREEN  = '42m'
  BG_YELLOW = '43m' 
  BG_BLUE   = '44m' 
  BG_PURPLE = '45m' 
  BG_CYAN   = '46m'
  BG_WHITE  = '47m'

  FG_NORMAL = 'm'
  FG_BLACK  = '30m'
  FG_RED    = '31m'
  FG_GREEN  = '32m'
  FG_YELLOW = '33m'
  FG_BLUE   = '34m'
  FG_PINK   = '35m'
  FG_CYAN   = '36m'
  FG_WHITE  = '37m'

  def TermFormat.s_color fg,bg=nil
    s = "\033["+fg
    s += "\033["+bg if bg
    s
  end

  def TermFormat.color fg,bg=nil
    print s_color(fg,bg)
  end

  def TermFormat.emph_color fg,bg=nil
    color '1;'+fg,bg
  end

  def TermFormat.normal 
    color FG_NORMAL,BG_NORMAL
  end

  def TermFormat.black
    color FG_BLACK
  end

  def TermFormat.pink
    color FG_PINK
  end

  def TermFormat.blue
    color FG_BLUE
  end

  def TermFormat.green
    color FG_GREEN
  end

  def TermFormat.red
    color FG_RED
  end

  def TermFormat.s_normal 
    s_color FG_NORMAL,BG_NORMAL
  end

  def TermFormat.s_black
    s_color FG_BLACK
  end

  def TermFormat.s_pink
    s_color FG_PINK
  end

  def TermFormat.s_green
    s_color FG_GREEN
  end

  def TermFormat.s_red
    s_color FG_RED
  end

end
