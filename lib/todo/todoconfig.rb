TODOCONFIG = ENV['HOME']+'/.ptodo'

require 'fs/configfile'

class TodoConfig < ConfigFile

  def initialize
    super(TODOCONFIG)
  end

end
