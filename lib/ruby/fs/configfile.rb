
class ConfigFile < Hash

  def initialize fn
    return if not File.exist?(fn)
    File.new(fn).each_line do | line |
      next if line =~ /^#/ or line.strip =~ /^$/
      key,value = line.strip.split(/:/,2)
      self[key.strip] = value.strip
    end
  end
  
end
