TODOCONFIG = ENV['HOME']+'/.todo'

require 'fs/configfile'

class TodoConfig < ConfigFile

  def initialize
    super(TODOCONFIG)
  end

end
