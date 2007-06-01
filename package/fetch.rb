#!/usr/bin/ruby 
#
# Fetch required files from Ruby source files and copy them to ./lib/ruby.
#
#   ./fetch.rb LIBPATH sourcefile(s)

require 'language/requiredfiles.rb'

r = RequiredFiles.new ARGV.shift, ARGV
r.each_path do | src,dest |
	dpath = 'lib/ruby/'+File.dirname(dest)
  p src,dest,dpath
  print `mkdir -p #{dpath}`
  print `cp -vau #{src} lib/ruby/#{dest}`
end
