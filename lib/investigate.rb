require 'shell'

class Investigate
  @@instance = Investigate.new
  
  def self.instance
    return @@instance
  end
  
  private_class_method :new
  
  # returns the type
  def gettype(obj)
    obj.class
  end
  
  # compares the classes of two objects
  def isof(obj, clazz)
    type = false
    type = true if obj.class.eql?(clazz.class)
    type
  end
  
  def isa(obj, clazz)
    type = false
    type = true if obj.class.eql?(clazz)
    type
  end
  
  # checks if directory is the root directory
  def isroot?(dir)
    isroot = false
    if isa(dir, Directory) and dir.getname.eql?("/")
      isroot = true
    end
    isroot
  end
  
  # checks for validity of directory names passed into move or copy
  def qualitycheck_dirs(dest, sourcedir, destdir)
    quality = true
    if sourcedir.nil?
      puts "Source directory does not exist."
      quality = false
    elsif destdir.nil?
      puts "Destination directory does not exist."
      quality = false
    elsif isroot?(sourcedir) and isa(sourcedir, Directory)
      puts "Can not copy root directory."
      quality = false
    elsif not isa(destdir, Directory) and not dest.eql?("..")
      puts destdir.class
      puts "Destination must be a directory."
      quality = false
    end
    quality
  end
  
  def getflags(args)
    flagstring = args[1]
    if flagstring.match(/^-.*/)
      flags = flagstring.gsub!('-','').scan(/./) #runs faster than .split(//)
      return flags
    end
    return nil
  end
  
    #parse input line for arguments
  def parseargs(line, delimiter)
    argsarray = line.split(delimiter)
    argsarray
  end
      
end
