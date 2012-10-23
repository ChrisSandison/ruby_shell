require 'file'
require 'investigate'

class Directory
  
  attr_accessor :name, :parent, :contents, :created
  
  def initialize(name, parent)
    @name = name
    @parent = parent
    if parent
      parent.addentry(name, self) #add into the current directory
    end
    @contents = Hash.new
    @created = Time.now
  end
  
  # creates a directory inside of current directory
  def mkdir(dirname)
    dirname.chomp!
    dirname.gsub!('/', '') #remove any slashes
    newdir = Directory.new(dirname, self)
    @contents[dirname] = newdir
    newdir #returns dir for testing's sake
  end
  
  # returns the parent directory
  # if root, returns itself
  def getparent
      if @parent.nil?
        self
      else
        @parent
      end
  end
  
  # sets the parent directory
  # if it is root, sets self
  def setparent(parent)
    if @parent.nil?
      @parent = self
    else
      @parent = parent
    end
  end
  
  # returns the name of the directory
  def getname
    @name
  end
  
  # returns directory entry corresponding tot he name or nil if it doesn't exist
  def getentry(entryname)
    @contents[entryname]
  end
  
  # adds entry to current directory
  # if entry is a dir, sets self as the entry's parent
  def addentry(entryname, entry)
    if entry.class.eql?(Directory)
      entry.setparent(self) 
    else #file
      entry.setdir(self)
    end
    @contents[entryname] = entry
  end
  
  # lists the contents of each directory (excluding . and ..)
  # lists details about the contents
  def ls
    display = ""
    modifiedtime = ""
    @contents.each do |key, value|
      if value.class.eql?(File)
        modifiedtime = "\tModified: " + value.modified.to_s 
      end
      display << "Name: #{key}\tType: #{value.class}\tCreated: #{created.to_s}" + modifiedtime + "\n"
    end
    display
  end
  
  # updates currently modified time if file exists, or creates it if it doesn't
  # adds file to directory
  def touch(filename)
    filename.chomp!
    if @contents[filename] and @contents[filename].class.eql?(File)
      @contents[filename].modifyfile
    else
      createfile(filename)
    end
  end
  
  # creates file in the current directory
  def createfile(filename)
    newfile = File.new(filename, self)
    @contents[filename] = newfile
  end
  
  # returns the file specified by filename
  def openfile(filename)
    foundfile = @contents[filename]
    unless foundfile #if file does not exist
      createfile(filename)
      foundfile = @contents[filename]
    end
    foundfile
  end
  
  # removes the contents of this directory
  # TODO recursively remove directories
  def removecontents
    puts "INSIDE DIR: #{@name}"
    @contents.each do |k, v|
      if Investigate.instance.isa(v,Directory)
        v.removecontents
        v = nil
      else
        @contents[k] = nil
      end
    end
  end
end