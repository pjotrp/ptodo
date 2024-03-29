# Author:: Pjotr Prins
# Copyright:: July 2007, March 2009
# License:: Ruby License

# A Todo item is read from a single string with the following format:
#     prefix [tag1 tag2 ...] postfix
# The prefix contains a priority or date
# The postfix contains the description

require 'todo/priority'

class Todo

  PPOS =  0
  TPOS = 14
  DPOS = 25

  def initialize s, line, fn
    # p [fn,line,s]
    @isvalid = false
    return if s.strip.size == 0
    return if s =~ /^#/
    return if s =~ /^\s*[*\+\-]/ and s !~ /^\s*[-+] \[[^X]/  # Skip org lists
    return if s =~ /^\s+[\[][\]]/   # Skip emty check boxes
    return if s =~ /^\s*-\s+\[.\]/   # Skip emty check boxes
    return if s =~ /^\s*\+\s+\[.\]/   # Skip emty check boxes
    return if s =~ /^\s+[-.+*x=]\s+[^\[]/

    @original = s
    @line     = line
    @fn       = fn
    @displayfn = File.basename(fn).sub(/\.\w+$/,'')
    if s =~ /(.*?)\[(.*?)\](.*)/
      # items contains tags container [] e.g.
      #  - [soon] description
      @priority = Priority.new($1)
      descr = $3
      @tags = $2.split(/\s+/)
      if descr != nil
        @description = descr.strip
      else
        $stderr.print "WARNING: No description for #{s}\n"
        return
      end
    else
      if s.strip =~ /^(\S)\s+(.*)/
        # A oneliner with a single letter priority (but no tags) e.g.
        #  ! test
        # @priority = Priority.new($1)
        # @description = $2
        # @tags = [ 'soon' ]
        return
      elsif s.strip =~ /^\d+\/\d+/
        # Ah, it has a date
        s.strip =~ /^(\S+)\s+(.*)/
        @priority = Priority.new($1)
        @description = $2
        @tags = [ 'soon' ]
      else
        # A oneliner without tags
        # @priority = Priority.new('-')
        # @description = s.strip
        return
      end
    end
    @isvalid = true
  end

  # returns an array of tags
  def tags
    @tags
  end

  def later?
    tags.each do | tag |
      return true if tag == 'later'
    end
    false
  end

  # returns whether an item is only shown in the TODO list (no export to remind)
  # These are marked with a 'nodiary' or 'nd' tag.
  def isdiary?
    tags.each do | tag |
      return false if tag == 'nodiary' or tag == 'nd' or tag == '!'
    end
    true
  end

  def expired?
    @priority.expired?
  end

  def has_priority?
    @priority.has?
  end

  # returns expiry date
  def date
  end

  # test all tags for a fit
  def apply_filter filters
    tags.each do | tag |
      found = true
      filters.each do | filter |
        found = false if tag !~ /#{filter}/
      end
      return true if found == true
    end
    false
  end

  def print_remind options
    print @priority.remind_s
    print ' ',@description[0,25]
    print '...' if @description.size > 25
    print "\n"
  end

  def prettyprint options=nil
    @terminal = TodoTerm.new(options.color)
    # p @original
    pwidth = priority_width
    twidth = tags_width+2

    tpos   = pwidth.max(TPOS)
    dpos   = twidth.max(DPOS)

    printf("%s%3d: ",@displayfn,@line) if options.line
    if date?
      if expired?
        @terminal.red
      else
        @terminal.green
      end
    else
      @terminal.blue
    end
    print @priority.to_s.ljust(12)
    @terminal.red
    print ('['+@tags.join(' ')+']').ljust(tpos)
    @terminal.blue
    print "\t",@description
    @terminal.normal
    print "\n"
  end

  def valid?
    return @isvalid
  end

  def date?
    @priority.date?
  end

  def due?
    @priority.due?
  end

  def more_than_one_month_away?
    @priority.more_than_one_month_away?
  end

  def sortby
    @priority.sortby+@tags.join(' ')+@description
  end

  # This method handles the sorting criteria for todo items. In order:
  #
  #   1. dated items less than one month from now
  #   2. prioritised items
  #   3. unmarked items
  #   4. dated items more than one month away
  #   5. items marked 'later'
  #

  def <=> y
    # first handle dates
    if date? and not y.date?
      if more_than_one_month_away?
        return -1
      else
        return 1
      end
    end
    if y.date? and not date?
      if more_than_one_month_away?
        return -1
      else
        return 1
      end
    end
    if date? and y.date?
      return sortby <=> y.sortby
    end
    if has_priority? and not y.has_priority?
      return 1
    end
    if y.has_priority? and not has_priority?
      return -1
    end
    sortby <=> y.sortby
  end

protected

  def priority_width
    @priority.size
  end

  def tags_width
    @tags.join(' ').size
  end

end

# This class maintains a list of TodoItems
class Todos

  def initialize
    @list = []
  end

  def add s, line, fn
    p [s,line,fn] if $debug
    todo = Todo.new(s,line,fn)
    @list.push(todo) if todo.valid?
  end

  def no_later_list
    list = []
    @list.each do | todo |
      if not todo.later?
        list.push todo
      end
    end
    list
  end

  def later_list
    list = []
    @list.each do | todo |
      if todo.later?
        list.push todo
      end
    end
    list
  end

  def print_tags
    tags = {}
    @list.each do | todo |
      todo.tags.each do | tag |
        tags[tag] = 0 if tags[tag] == nil
        tags[tag] += 1
      end
    end
    tags.sort.each do | key, value |
      print '(',value,")\t",key,"\n"
    end
  end

  # Generate output for the remind program that can be piped in

  def print_remind options
    reminders = ENV['HOME']+'/.reminders'
    print "include #{reminders}\n" if File.exist? reminders
    @list.sort.each do | todo |
      if todo.date? and todo.isdiary?
        todo.print_remind options
      end
    end
  end

  # Contains the logic for different options

  def selected? todo,filters,options
    if options.due
      return todo.due?
    end
    (not options.dated and todo.apply_filter(filters)) or (options.dated and todo.date?)
  end

  def print_filtered filters, options
    print_line options.color
    # list all items without 'later' tag
    no_later_list.sort.each do | todo |
      todo.prettyprint(options) if selected?(todo,filters,options)
    end
    print_line options.color
    # list all items with 'later' tag
    later_list.sort.each do | todo |
      todo.prettyprint(options) if selected?(todo,filters,options)
    end
  end

  def print_line color
    terminal = TodoTerm.new color
    terminal.green
    print '-'*70,"\n"
    terminal.normal
  end
end
