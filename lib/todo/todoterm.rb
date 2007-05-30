# Terminal output

require 'ui/term/format'

class TodoTerm

  def initialize usecolor = true
    @usecolor = usecolor
  end

  def method_missing name
    if @usecolor
      TermFormat.send(name)
    end
  end

end

