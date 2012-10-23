require 'directory'
require 'file'
require 'echo'
require 'investigate'

class Shell
  include Marshal
  
  attr_reader :root
  attr_accessor :currentdir
  ACTIONS = %w[ls mkdir cd touch pwd cat echo mv cp rm] #array of commands
  @@instance = Shell.new
  
  def self.instance
    return @@instance
  end
  
  def currentdir(dir)
    @currentdir = dir
  end
  
  def getcurrentdir
    @currentdir
  end
  
  private_class_method :new
  
  def createroot
    @root = Directory.new("/", nil)
    currentdir(@root)
  end
  
  #creates root directory and initiates the shell
  def startshell()
    createroot
    while true do
      prompt = "#{@currentdir.name}>" #start in root directory
      puts prompt
      input = gets
      input.chomp!
      break if input.downcase.eql?("exit")
      
      #split into arguments and flags
      args = Investigate.instance.parseargs(input, ' ')
      @flags = Investigate.instance.getflags(args)
      args.delete_at(1) if not @flags.nil? #delete arguments from command string if found
      
      #check for valid command
      unless ACTIONS.include?(args[0])
        puts "Invalid command."
        next
      end
      
      #execute command
      case args[0]
        when  "ls"
          puts @currentdir.ls
        when "mkdir"
          newdir = @currentdir.mkdir(args[1])
        when "cd"
          cd(args[1])
        when "touch"
          @currentdir.touch(args[1])
        when "pwd"
          puts "#{pwd}"
        when "cat"
          puts @currentdir.openfile(args[1]).readfile
        when "echo"
          echo(args[1..args.size-1])
        when "mv"
          move(args[1], args[2])
        when "cp"
          copy(args[1], args[2])
        when "rm"
          remove(args[1])
      end
      
    end
    puts "Ending session." #logout message
  end
  
  #changes directory -- shell handles current dir, so method in shell
  #only handles relative paths for now
  def cd(dirname)
    case dirname
      when "."
        return
      when ".."
        if @currentdir.name.eql?("/")
          puts "Already in root directory."
        end
        currentdir(@currentdir.parent)
      else
        if @currentdir.getentry(dirname)
          currentdir(@currentdir.getentry(dirname))
        else
          puts "Directory does not exist."
          return
        end
    end
  end
  
  #prints the full path of the current directory
  def pwd
    dirs = Array.new #create array
    
    #check if in root
    if @currentdir.name.eql?("/")
      puts "/"
      return
    end
    
    #if not, carry on
    dirs.push(@currentdir.name) #add current name
    testdir = @currentdir.parent
    until testdir.getname.eql?("/") #loop until root
      dirs.push(testdir.getname) #add directory to array
      testdir = testdir.parent
    end
    dirs.reverse! #reverse directory order
    path = "" #create string for making path
    dirs.each do |i|
      path << "/" + i
    end
    path
  end
  
  #creates new echo object to handle redirection/output
  def echo(text)
   echothis = Echo.new(text)
   echothis.parseline
   if echothis.detectredirect
     echothis.directtext
   else
      puts echothis.printarray
   end
  end
  
  # removes the file from the current directory
  # will have "-r" for removing a directory (recursive)
  def remove(toremove)
    
  end
  
  # creates a copy of the current directory or file and places it in dest
  # TODO fix mysterious copying error
  # TODO create error codes
  def copy(source, dest)
    # get corresponding directories
    sourceobj = @currentdir.getentry(source)
    if dest.eql?("..")
      destdir = @currentdir.parent
    end
    destdir = @currentdir.getentry(dest)
    return unless Investigate.instance.qualitycheck_dirs(dest, sourceobj, destdir)
    # check if directory or file
    if Investigate.instance.isa(sourceobj,File)
      newobj = sourceobj.dup
      # add new file to appropriate places
      newobj.setdir(destdir)
    else
      #recursively copy new object
      newobj = Marshal.load(Marshal.dump(sourceobj)) #will copy all objects in object
      newobj.setparent(destdir)
    end
    destdir.addentry(newobj.getname, newobj)
  end
  
  # move directory source to directory dest
  def move(source, dest)
    #TODO
  end
  
end