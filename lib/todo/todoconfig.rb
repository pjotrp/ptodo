#
# Author:: Pjotr Prins
# Copyright:: July 2007
# License:: Ruby License
TODOCONFIG = ENV['HOME']+'/.ptodo'

require 'fs/configfile'

class TodoConfig < ConfigFile

  def initialize
    super(TODOCONFIG)
  end

end
