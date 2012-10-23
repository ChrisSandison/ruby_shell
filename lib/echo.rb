require 'shell'

class Echo
  def initialize(wordarray)
    @wordarray = wordarray
    @filename = ""
    @filecontents = ""
  end
  
  def printarray
    @wordarray.join(' ').to_s
  end
  
  #detects if a redirect character is used as second-last entry in array
  def detectredirect
    detect = false
    detect = true if @wordarray[@wordarray.size-2].eql?(">")
    detect
  end
  
  #redirects output to specified file
  def directtext
    #handle the text
    parseline
    #open the file
    file = Shell.instance.getcurrentdir.openfile(@filename)
    #write to file
    file.writetofile(@filecontents)
  end
  
  def parseline
    @filename = @wordarray[@wordarray.size-1] #saves the filename to open
    @filecontents << @wordarray[0..@wordarray.size-3].join(' ').to_s #create string of text
  end
end
