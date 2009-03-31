# $Id: version.rb,v 1.3 2004/01/09 12:36:15 wrk Exp $
# $Source: /home/cvs/opensource/lib/ruby/util/other/version.rb,v $
#
# This module will return a version number from a file sitting in the source tree
# (by convention in package/src/VERSION)
#
# Info:: Pjotr's shared Ruby modules
# Author:: Pjotr Prins
# mail:: pjotr.public05@thebird.nl
# Copyright:: July 2007
# License:: Ruby License

module Version

  def Version.get path, file, package=nil
    sep = File::Separator
    fn = path+sep+file
    if File.exist?(fn.downcase)
      fn = fn.downcase
    else
      if File.exist?(fn.upcase)
        fn = fn.upcase
      else
        if !File.exist?(fn)
          # ---- hack for MS Windows users since $0 points to cwd
          fn = path+sep+'src'+sep+file
        end
        if !File.exist?(fn) and package
          # ---- umph. last resort use hard coded path
          fn = ENV['RUBYPKG']+sep+package+sep+'src'+sep+file
        end
      end
    end
    f = File.open(fn);
    f.gets.chop
  end

end
