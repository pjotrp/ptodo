# Author:: Michael J. Bruderer
# Copyright:: March 2009
# License:: Ruby License
# Email: ojos@gmx.ch

begin
  require 'rubygems'
  require 'chronic'
  require 'date' 
  $CHRONIC_INSTALLED=true
rescue LoadError
  $CHRONIC_INSTALLED=false
end


class Newtodos

  @todo_string = ''

  def initialize s=''
    $stderr.print "Warning: chronic gem not installed - you can not add new todos\n"
    msg = self.extract_msg(s)
    tags = self.extract_tags(s)
    date = extract_date(s)
    @todo_string = "\n#{date} #{tags} #{msg}"
  end

  def extract_msg(s)
    reg = /"(.*)"/
    res = s.scan(reg)
    res.to_s
  end

  def extract_date(s)
    s.sub!(/"(.*)"/, '')
    s.sub!(/\[(.*)\]/, '')
    s.tr!('.','/')
    split = s.split(/\//) # splits string on /
    if split.length == 0
      s
    elsif split.length == 2
      s  = [split[1], split[0]].join("/") # US format date 
    elsif split.length == 3
      s  = [split[1], split[0], split[2]].join("/") # US format date 
    end
    
    european_date = '%d/%m/%Y'
    date = Chronic.parse(s).strftime(european_date) 

  end

  def extract_tags(s)
    reg = /\[.*\]/
    res = s.scan(reg)
    if res.length == 0
      res = "[soon]"
    end
    res
  end

  def to_s
    @todo_string
  end

  def add_to_file(todofile)
    if todofile.class == 'Array'
      infile = todofile[0]
    else
      infile = todofile
    end
    f = File.open(infile, 'a') 
    f.write(@todo_string)
    f.close
    puts "Added: "+@todo_string
  end
end
