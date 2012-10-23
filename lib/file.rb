require 'directory'

class File
  
  attr_accessor :name, :created, :directory, :modified, :contents 
  
  def initialize(name, dir)
    @name = name
    @created = Time.now
    @directory = dir
    if @directory
      @directory.addentry(name, self)
    end
    @modified = Time.now
    @contents = ""
  end
  
  def getname
    @name
  end
  
  def setname(name)
    @name = name
  end
  
  def getdir
    @directory
  end
  
  def setdir(dir)
    @directory = dir
  end
  
  #update last modified time each time file is created
  def modifyfile
    @modified = Time.now
  end
  
  def writetofile(message)
    @contents = message
  end
  
  def readfile
    @contents
  end
  
end