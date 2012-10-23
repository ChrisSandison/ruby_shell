# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'echo'
require 'shell'

class TestEcho < Test::Unit::TestCase
  def test_printarray
    wordarray = %w[some words]
    echo = Echo.new(wordarray)
    assert_equal("some words", echo.printarray, "printarray: incorrect output")
  end
  
  def test_directtext
    wordarray = %w[some words > newfile]
    instance = Shell.instance
    root = Directory.new("/",nil)
    instance.currentdir(root)
    echo = Echo.new(wordarray)
    echo.directtext
    assert_equal("some words", root.getentry("newfile").readfile, "directtext: incorrect text")
  end
end
